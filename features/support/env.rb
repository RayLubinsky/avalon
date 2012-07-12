# -*- encoding : utf-8 -*-
# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file iwas generated by Cucumber-Rails and is only here to get you a head start
# These step definitions are thin wrappers around the Capybara/Webrat API that lets you
# visit pages, interact with widgets and make assertions about page content.
#
# If you use these step definitions as basis for your features you will quickly end up
# with features that are:
#
# * Hard to maintain
# * Verbose to read
#
# A much better approach is to write your own higher level step definitions, following
# the advice in the following blog posts:
#
# * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://elabs.se/blog/15-you-re-cuking-it-wrong 
#

require 'cucumber/rails'
require 'headless'

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css
Capybara.default_wait_time = 30
Capybara.javascript_driver = :webkit

# Set up headless once instead of for every single feature
AfterConfiguration do
  if "true" == ENV["USE_HEADLESS"]

    headless = Headless.new
    headless.start
    puts "<< Headless X server now running on #{headless.display} >>"
  end
end

# Shut down headless when you are done
at_exit do
    puts "<< Tearing down the headless instance >>"
    if ENV["USE_HEADLESS"] == "true" and @headless.present?
      puts "<< Destroying headless X server >>"
      headless.destroy
    end

    # Also be sure to delete all objects so the repository is pristine. Only those
    # fixtures that are not numeric will be retained
    Video.find(:all).each do |video|
      if video.pid =~ /^hydrant:\d+$/
        logger.info "<< Deleting #{video.pid} from the Fedora repository test instance >>"
        video.delete
      end
    end
end

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove this line if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
#DatabaseCleaner.strategy = :transaction

# Stop endless errors like
# ~/.rvm/gems/ruby-1.9.2-p0@global/gems/rack-1.2.1/lib/rack/utils.rb:16: 
# warning: regexp match /.../n against to UTF-8 string
$VERBOSE = nil
