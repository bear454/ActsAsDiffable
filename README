ActsAsDiffable provides a dead-simple way to compare two instances of a class,
including any or all associations, or more complex relationships.

The return is a hash*, suitable for digestion by case-based textualizers, 
JSON processors, etc., in the form { 'attribute' => [from, to] }
* In the instance of no changes, a nil is returned
 
== Usage

  class Foo < ActiveRecord::Base
    acts_as_diffable
  end
  > Foo.first.diff(Foo.last) => { 'bar' => ['foo', nil] }

=== Associations

For plural associations, a :diff_key option needs to be added to the association,
defining how to relate disparate instances within each parent's collections.  
This can be a single field or a collection of fields in an array, and will be 
expressed as the key side of a hash with the value being the hash of attribute 
differences.

For singular association, there is no need to specify a way to organize and
compare, so we only need to express which associations to include in the diff,
by adding a :diff option to the association that evaluates to true.

  class Foo < ActiveRecord::Base
    acts_as_diffable
   
    has_one :bar, :diff => true
    has_many :fish, :diff_keypattern => :name
    has_and_belongs_to_many :users, :diff_keypattern => [:firstname, :lastname]
  end
  > Foo.first.diff(Foo.last) 
  => { 'bar'   => { 'attr1' => ['a', 'b'], 
                    'attr2' => [14, nil] },
       'fish   => { 'nemo'   => {'fish_attr1' => [nil, 'zip']   },
                    'goldie' => {'fish_attr1' => ['zap', 'zop'] } },
       'users' => { ['Jane', 'Doe'] => { 'firstname' => 'Jane',
                                         'lastname'  => 'Doe' },
                    ['John', 'Doe'] => { '_deleted' => true   } } }

=== More complex relationships

In addition to the marked associations, any method on the class that returns an
ActiveRecord-ish object can be included in the diff by adding a 
manual_diff_definiton.  For comparing collections of ActiveRecord objects, 
use the form:

  manual_diff_definition :name, :eval => 'instance_eval_code',
                                :diff_key => [:key, :pattern]
                                
For simpler singular comparisons, omit the diff_key option.


Have a lot of fun!
