require 'active_record'

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Diffable #:nodoc:

      SINGULAR_MACROS = [:has_one, :belongs_to]
      PLURAL_MACROS   = [:has_many, :has_and_belongs_to_many]

      def self.included(base)
        base.extend(ClassMethods)
        
      end

      module ClassMethods
        def acts_as_diffable
          class_variable_set :@@manual_diff_definitions, {}
          extend ActiveRecord::Acts::Diffable::SingletonMethods
          include ActiveRecord::Acts::Diffable::InstanceMethods
        end
        
      end

      module SingletonMethods
        def manual_diff_definition(name, options = {})
          definitions = class_variable_get :@@manual_diff_definitions
          definitions[name.to_s] = options if options[:eval] # otherwise just ignore it
          class_variable_set :@@manual_diff_definitions, definitions
        end
        
        def manual_diff_definitions
          class_variable_get :@@manual_diff_definitions
        end
      end

      # Adds instance methods.
      module InstanceMethods
        # Return a hash of the different attributes between two hashes, such as
        # attributes of an ActiveRecord class.
        def diff(other)
          # is other an instance or just an id?
          case other.class
          when self.class
            other
          else
            other = self.class.find(other)
          end
          # diff the top-level attributes
          differences = attributes_diff(self, other) || {}
          # has_one and belongs_to associations
          ActiveRecord::Acts::Diffable::SINGULAR_MACROS.each do |macro|
            self.class.reflect_on_all_associations(macro).each do |a|
              differences[a.name.to_s] = singular_association_diff(self, other, a.name) if a.options[:diff]
              differences.delete(a.options[:foreign_key] || "#{a.name}_id")
            end
          end
          # has_many and habtm associations
          ActiveRecord::Acts::Diffable::PLURAL_MACROS.each do |macro|
            self.class.reflect_on_all_associations(macro).each do |a|
              differences[a.name.to_s] = plural_association_diff(self, other, a.name, a.options[:diff_key]) if a.options[:diff_key]
            end
          end
          # manually defined diffs
          self.class.manual_diff_definitions.each{|d_name, d_props|
            if d_props[:diff_key]
              differences[d_name] = plural_association_diff(self, other, d_props[:eval], d_props[:diff_key])
            else
              differences[d_name] = singular_association_diff(self, other, d_props[:eval])
            end
          }
          remove_unchanged_entries differences
        end
        
        def timed_log(start_time, msg)
          puts "%04.2fs %s" % [(Time.now - start_time), msg]
        end
        
        # Helper for processing a single associated object, 
        # such as has_one (or belongs_to) associations.
        def singular_association_diff(left_parent, right_parent, association)
          association = association.to_s #instance_eval doesn't like symbols.  What'ev.
          attributes_diff(
            left_parent.instance_eval(association),
            right_parent.instance_eval(association),
            association_ids(left_parent) )
        end    

        # Helper for processing a collection of associated objects,
        # such as has_many (or habtm) association.
        def plural_association_diff(left_parent, right_parent, association, key_pattern)
          key_pattern = Array(key_pattern)
          association = association.to_s #instance_eval doesn't like symbols.  What'ev.
          left_association_set = Array(left_parent.instance_eval(association))
          right_associaton_set = Array(right_parent.instance_eval(association))
          # construct a set of values (key_set) from the attributes defined in key_pattern
          key_sets = (
            left_association_set.collect{|i| key_pattern.collect{|k| i.send(k) } } +
            right_associaton_set.collect{|i| key_pattern.collect{|k| i.send(k) } } ).uniq
          # for each key_set, compare instances in each collection
          diff_set = {}
          key_sets.each do |key_set|
            conditions = {}   
            key_pattern.each_with_index{|k, i| conditions[k] = key_set[i] } 
            left_instance = left_association_set.find{|i|
              conditions.collect{|cf,cv| i.send(cf) == cv}.all?
            }
            right_instance = right_associaton_set.find{|i|
              conditions.collect{|cf,cv| i.send(cf) == cv}.all?
            }
            diff_set[keyify(key_set)] = attributes_diff(left_instance, right_instance, association_ids(left_parent) )
          end
          
          # clean up unchanged pairs
          remove_unchanged_entries diff_set
        end

        # reduce the key out of an array to a single string if only one element
        def keyify(keyset)
          case keyset.size
          when 1
            keyset[0]
          else
            keyset
          end    
        end
        
        # Helper for collecting ids to ignore.
        def association_ids(*instances)
          ['id'] + instances.collect{|i| i.class.to_s.underscore + '_id'}
        end
        
        # Helper for handing objects with an attributes hash (a la ARec).
        def attributes_diff(left, right, ignore = [:id])
          left_attributes = case
            when left.is_a?(Hash) then 
              left
            when left.respond_to?(:attributes) then 
              left.attributes
            else 
              left.instance_values
            end
          right_attributes = case
            when right.is_a?(Hash) then
              right
            when right.respond_to?(:attributes) then
              right.attributes
            else
              right.instance_values
            end

          if left_attributes == right_attributes
            return nil
          else
            generate_diff_hash(left_attributes, right_attributes, *ignore)
          end
        end
        
        # Helper for thinning the herd
        def remove_unchanged_entries(diff_hash)
          return nil if !diff_hash
          diff_hash.delete_if{|k,v| v.nil? }
          if diff_hash.empty?
            return nil 
          else
            return diff_hash
          end
        end

        # Accepts a left & right hash, and an array of keys to ignore,
        # returns a hash of the differences.
        #
        # This here is the meat & potatoes!
        def generate_diff_hash(left, right, *ignore)
          case [left.blank?, right.blank?] 
          when [false, true] # the represented object was deleted
            { '_delete' => true } # inspired by nested_attributes
          when [true, false] # the represented object was added
            (ignore + %w(created_at updated_at)).each{|k| right.delete(k.to_s) }
            return right # just return the attributes to add
          when [false, false] # the represented object changed
            # generate the attribute diffs from each side and
            # merge them together as attribute => [left_value, right_value]
            if left == right
              return nil
            else
              diff_hash = left.diff(right).merge(right.diff(left)){|k, lv, rv| [lv, rv] }
              # remove any ignored attributes
              ignore.each {|k| diff_hash.delete(k.to_s) }
              # compress created_at/updated_at duplication
              diff_hash.delete('updated_at') if diff_hash['created_at'] == diff_hash['updated_at']
              remove_unchanged_entries diff_hash
            end
          end
        end

      end

    end
  end
end

# reopen ActiveRecord and include all the above to make
# them available to all our models if they want it

ActiveRecord::Base.class_eval do
  include ActiveRecord::Acts::Diffable
end

# monkeypatch the diff keys onto the association proxies
ActiveRecord::Associations::Builder::BelongsTo.class_eval("self.valid_options += [:diff]")
ActiveRecord::Associations::Builder::HasOne.class_eval("self.valid_options += [:diff]")
ActiveRecord::Associations::Builder::HasMany.class_eval("self.valid_options += [:diff_key]")
ActiveRecord::Associations::Builder::HasAndBelongsToMany.class_eval("self.valid_options += [:diff_key]")
