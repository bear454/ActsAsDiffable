# top-level class
class User < ActiveRecord::Base
  acts_as_diffable

  belongs_to :group, :diff => true
  has_many :tags, :diff_key => :name
  
  manual_diff_definition :group_name, :eval => 'group.name'
  manual_diff_definition :m_tags, :eval => 'tags', :diff_key => 'name'

end
