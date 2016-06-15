#! /usr/local/bin/bash 
#################################################
#File:setup_run.sh                              #
#Author:Chris Arthur                            #
#Date Last Modified:6/15/16                     #
#Purpose:This script will install rvm if        #  
#necessary and will then setup and run bundler  #
#after that it will run the rspec tests         #
################################################# 

#################################################
#function:install_rvm                           #
#purpose:installs rvm if needed and installs    #
#ruby-2.3.0 if rvm was not installed            #
#################################################
function install_rvm()
{
  clear
  echo "Installing rvm if needed..."
  which rvm > /dev/null
  if [ ${?} -ne 0 ]; then
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable --auto-dotfiles 
    source ~/.rvm/scripts/rvm
    rvm install ruby-2.3.0
  else
    source ~/.rvm/scripts/rvm
  fi
  return ${?}
}

#################################################
#function:setup_bundler                         #
#purpose:Installs the bundler if needed and runs#
#bundle install                                 #
#################################################
function setup_bundler()
{
  clear
  echo "Setting up bundler..."
  gem install bundler
  bundle install
}

#################################################
#function:run_spec				#
#purpose:Runs the rspec tests			#
#################################################
function run_spec()
{
  clear 
  echo "Running the rspec tests..."
  bundle exec rspec hms.rb
}

#################################################
#function:main                                  #
#purpose:The main function to run it all        #
#################################################
function main()
{
install_rvm && setup_bundler && run_spec || echo "Problem running script"
}

main
