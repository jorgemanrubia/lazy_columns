class Action < ActiveRecord::Base

  lazy_load :comments

  attr_accessible :comments, :title

  belongs_to :person
end
