# Add the current dir to source_paths so that Thor actions like
# copy_file and template resolve against our source files.
source_paths.unshift(File.dirname(__FILE__))

gem_group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

gem_group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
end

run "bundle install"

# Add .env as ignored file by git
append_to_file '.gitignore', <<~CODE

# Ignore dotenv-rails .env file
.env*

# Ignore coverage folder
coverage
CODE

template "README.md.tt", force: true
remove_file "README.rdoc"

copy_file "bin/setup", "bin/setup", force: true
chmod "bin/setup", "+x"

copy_file "lib/tasks/factory_bot.rake", "lib/tasks/factory_bot.rake"

# DotEnv files
template "env.example.tt", "env.example"

# Database
template "database.yml.tt", "config/database.yml", force: true

# Rspec
generate('rspec:install')
append_to_file ".rspec", "--color\n"

copy_file "spec/support/database_cleaner.rb", "spec/support/database_cleaner.rb"
copy_file "spec/support/shoulda_matchers.rb", "spec/support/shoulda_matchers.rb"
copy_file "spec/support/factory_bot.rb", "spec/support/factory_bot.rb"

uncomment_lines 'spec/rails_helper.rb', /Dir\[Rails.root.join\('spec', 'support', '\*\*', '\*.rb'\)\]/

comment_lines 'spec/rails_helper.rb', /config\.fixture_path/
comment_lines 'spec/rails_helper.rb', /config\.use_transactional_fixtures/

insert_into_file "spec/rails_helper.rb", after: "ENV['RAILS_ENV'] ||= 'test'\n" do
  <<~CODE

if ENV['COVERAGE']
  # Run COVERAGE=true bundle exec rspec in other to generate coverage report
  require 'simplecov'
  SimpleCov.start :rails
end

  CODE
end

insert_into_file "spec/rails_helper.rb", after: "# Add additional requires below this line. Rails is not loaded until this point!\n" do
  [
    "require 'shoulda/matchers'",
    "require 'ffaker'",
    "require 'factory_bot'"
  ].join("\n")
end

# Rubocop
copy_file "rubocop.yml", ".rubocop.yml"
run "bundle exec rubocop --auto-gen-config"

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }