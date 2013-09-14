class Person < ActiveRecord::Base
  attr_accessible :cv, :name

  has_many :actions
end
