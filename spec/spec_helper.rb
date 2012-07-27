require 'rubygems'
require 'spork'
require 'simplecov'
SimpleCov.start

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'webmock/rspec'
  require 'vcr_setup'
  #require 'capybara/poltergeist'


  # TODO disabled until I get jazz_hands to work
  # require 'pry'
  # require 'pry-remote'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.include AcceptanceHelper,  :type => :request
  end

  module TestResponseExtensions
    def json_body
      JSON.parse(self.body)
    end

    def unauthorized?
      code.to_i == 401
    end
  end

  def expect_id_and_return(id, ret_val)
    lambda { |id| id.to_s.should == id.to_s; ret_val }
  end

end

Spork.each_run do
  FactoryGirl.reload
end
