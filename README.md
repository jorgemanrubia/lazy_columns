# lazy_columns

lazy_columns is a Rails plugin that lets you specify columns to be loaded lazily in your Active Record models.

By default, Active Records loads all the columns in each model instance. This plugin lets you specify columns to be excluded by default. It is intended for scenarios where you have large attributes and don't want to load them in every operation because of performance.

Notice that a much better approach is moving those columns to new models, since Rails loads related models lazily by default. This plugin is an easy workaround. 

## Installation

In your `Gemfile`

```ruby
gem 'lazy_columns'
```

## Usage

Use `lazy_load` in your Active Record models to define which column or columns should be loaded lazily:

```ruby
class Action < ActiveRecord::Base
  lazy_load :comments

  attr_accessible :comments, :title
end
```

Now, when you fetch some action the comments are not loaded:

```ruby
Action.create(:title=>"Some action", :comments=>"Some comments") # => <Action id: 1...>
action = Action.find(1) # => <Action id: 1, title: "Some action">
```

And if you try to read the `comments` attribute it will be loaded into the model:

```ruby
action.comments # => "Some comments"
action # => <Action id: 1, title: "Some action", comments: "Some comments" 
```

## How the plugin works

This plugin does two things:

- Modify the [default scope](http://apidock.com/rails/ActiveRecord/Base/default_scope/class) of the model so that it fetches all the attributes except the marked as lazy.
- Define an accessor method per lazy attribute that will reload the corresponding column under demand.

### Eager loading of attributes defined as lazy

The first time you access a lazy attribute a new database query will be executed to load it. If you are going to operate on a number of objects and want to have the lazy attributes eagerly loaded use Active Record `.select()` in the initial query. For example:

```ruby
Action.select(:comments).all 
```

## Credits

- I learned about the possibility of using a default scope to exclude columns in [this answer by Chris Hoffman in stackoverflow](http://stackoverflow.com/questions/95061/stop-activerecord-from-loading-blob-column/3274347#3274347).



