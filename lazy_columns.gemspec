$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lazy_columns/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lazy_columns"
  s.version     = LazyColumns::VERSION
  s.authors     = ["Jorge Manrubia"]
  s.email       = ["jorge.manrubia@gmail.com"]
  s.homepage    = "https://github.com/jorgemanrubia/lazy_columns"
  s.summary     = "Rails plugin that let you configure ActiveRecord columns to be loaded lazily"
  s.description = "This plugin lets you define specific columns in ActiveRecord models to be loaded lazily"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.10"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec', '~>2.12.0'
  s.add_development_dependency 'rspec-rails', '~>2.12.0'
end
