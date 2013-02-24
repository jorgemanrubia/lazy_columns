require 'spec_helper'

describe LazyColumns::ActsAsLazyColumnLoader do
  before(:each) do
    @action = create_and_reload_action_from_db
  end

  describe "#lazy_column" do
    it "excludes single column from active record objects" do
      @action.has_attribute?(:comments).should be_false
    end

    it "loads column when requested" do
      @action.comments.should == "some comments"
    end

    it "should not reload the object if the column was eagerly loaded" do
      @action = Action.select(:comments).first
      @action.should_not_receive :reload
      @action.comments
    end

    it "should not reload the object after the column was fetched" do
      @action.comments
      @action.should_not_receive :reload
      @action.comments
    end

    it "should let you define the attribute when creating the object" do
      @action = Action.create!(comments: "some new comments")
      @action.comments.should == "some new comments"
    end

    it "should let you update the attribute using #update_attribute" do
      @action.update_attribute(:comments, "some new comments")
      @action.comments.should == "some new comments"
    end

    it "should let you update the attribute using #update_attributes" do
      @action.update_attributes(comments: "some new comments")
      @action.comments.should == "some new comments"
    end

    it "should let you define multiple lazy columns at the same time" do
      @action = create_and_reload_action_from_db(ActionWith2LazyColumns)
      @action.has_attribute?(:comments).should be_false
      @action.has_attribute?(:title).should be_false
      @action.title.should == "some action"
      @action.comments.should == "some comments"
    end

    it "should let you modify normal attributes" do
      @action.title = 'some new title'
      @action.comments
      @action.save!
      @action.reload.title.should == 'some new title'
    end
  end

  def create_and_reload_action_from_db(klass=Action)
    klass.find Action.create(title: "some action", comments: "some comments")
  end

  class ActionWith2LazyColumns < ActiveRecord::Base
    self.table_name = "actions"

    lazy_load :comments, :title

    attr_accessible :comments, :title
  end
end
