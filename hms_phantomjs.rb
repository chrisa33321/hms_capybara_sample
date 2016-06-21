####################################################
# File:hms.rb                                       #
# Author:Chris Arthur                               #
# Date Last Modified:6/15/16                        #
# Purpose: A series of tests that will verify that  #
# the repos listed in the github ui are in the same #
# order (sorted by push descending) as returned by  #
# the api                                           #
####################################################
require 'capybara/rspec'
require 'capybara/poltergeist'
require_relative 'gh_api.rb'

# Handles navigating through the GitHub site
class SearchResults
  include GitHubApi

  def initialize
    Capybara.javascript_driver = :poltergeist
    @session = Capybara::Session.new(:poltergeist)
    @search_css = '.form-control.header-search-input.js-site-search-focus'
    @user_tab_xpath = '/html/body/div[4]/div[1]/div[2]/div/div[1]/nav/a[4]'
  end

  def visit
    @session.visit('http://www.github.com')
    @session
  end

  def search
    @session.find(@search_css).set('catalyst-automation-testing')
    @session.find(@search_css).send_keys(:return)
    @session
  end

  def click_user_tab
    @session.find(:xpath, @user_tab_xpath).click
    @session
  end

  def click_user
    @session.click_link('catalyst-automation-testing')
    @session
  end

  def show_repos
    @session.click_link('Repositories')
    @session
  end
end

describe 'search results', type: :feature do
  before :all do
    @search_results = SearchResults.new
  end

  context 'when navigating to the github page' do
    it 'has a search bar' do
      sb_css = '.form-control.header-search-input.js-site-search-focus'
      expect(@search_results.visit).to have_css sb_css
    end
  end

  context 'when searching for catalyst-automation-testing' do
    it 'does not return any repos' do
      str = "We couldn’t find any repositories"
      exp_str = str + " matching 'catalyst-automation-testing'"
      expect(@search_results.search).to have_content(exp_str)
    end
  end

  context 'when clicking on the users tab' do
    it 'shows catalyst-automation-testing user' do
      exp_str = 'catalyst-automation-testing Joined on Feb 5, 2016'
      expect(@search_results.click_user_tab).to have_content(exp_str)
    end
  end

  context 'when clicking on the user' do
    it 'shows the user profile page' do
      expect(@search_results.click_user).to have_content('Popular repositories')
    end
  end

  context 'when selecting repositories' do
    it 'Shows all the repositories in the expected order' do
      success = @search_results.retrieve_matcher
      expect(@search_results.show_repos).to have_content(success)
    end
  end
end
