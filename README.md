# rails_template
An simple rails template

# What's inside the box?

Some basic stuff used in development, like: byebug, rubocop, dotenv and pry.

And testing stuff, like: rspec, factory_bot, database_cleaner, ffaker, shoulda-matchers and simplecov.

Generates rubocop files using `--auto-gen-config` option.

# How to use it
On creating a new app
```
rails new new_app \
  -d postgresql \
  -m <path where you've cloned this repo>/template.rb
```

On ~/.railsrc
```
--database=postgresql
--template=<path where you've cloned this repo>/template.rb
```