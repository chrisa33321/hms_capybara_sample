#########################################################
# File:gh_api.rb				                #
# Author:Chris Arthur                                    #
# Date Last Modified:6/15/16                             #
# Purpose:A module that provides a way to get the return #
# value in sorted descending order of repos by calling   #
# the github api                                         #
#########################################################
require 'github_api'

# Utilizes the github_api gem to construct a capybar
# matcher string by calling the github api
module GitHubApi
  def init
    @repo_info = {}
    repos = Github::Client::Repos.new
    @response = repos.list user: 'catalyst-automation-testing'
    @ret_str = ''
  end

  def retrieve_matcher
    init
    fill_repo_hash
    create_str
    @ret_str
  end

  private

  def fill_repo_hash
    @response.each_page do |page|
      page.each do |repo|
        @repo_info[repo.name] = repo.pushed_at
      end
    end
  end

  def create_str
    sorted_repos = @repo_info.sort_by { |_repo, pushed_at| pushed_at }.reverse
    sorted_repos.each do |sort_repo|
      dte = DateTime.parse(sort_repo[1].split('T')[0]).strftime('%b %-d')
      @ret_str << " 0 0 #{sort_repo[0]} Updated on #{dte}"
    end
  end
end
