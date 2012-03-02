# for testing single associations
class Group < ActiveRecord::Base
  has_many :users
end
