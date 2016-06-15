# hms_capybara_sample
A capybara sample which searchs the github page for a certain user and verifies that the users repos are in the same order as returned by the api

Running setup_run.sh should install rvm and ruby if needed, sets up the bundler and runs the rspec tests, if this should fail the tests can be run in the following way:

1. make sure ruby is installed
2. gem install bundler
3. bundle install
4. bundle exec rspec hms.rb
