require 'test_helper'

class ActsAsLazyColumnLoader < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  def setup
    @action = create_and_reload_action_from_db
  end

  test "exclude lazy columns from active record objects" do
    assert !@action.has_attribute?(:comments), "The action should not contain the lazy :comments attribute"
  end

  test "lazy load column when requested" do
    assert_equal "some comments", @action.comments
  end

  def create_and_reload_action_from_db
    Action.find Action.create(title: "some action", comments: "some comments")
  end
end
