module Yt
  # Provides an object to store global configuration settings.
  #
  # This class is typically not used directly, but by calling
  # {Yt::Config#configure Yt.configure}, which creates and updates a single
  # instance of {Yt::Models::Configuration}.
  #
  # @example Set the API client id/secret for a web-client YouTube app:
  #   Yt.configure do |config|
  #     config.client_id = 'ABCDEFGHIJ1234567890'
  #     config.client_secret = 'ABCDEFGHIJ1234567890'
  #   end
  #
  # @see Yt::Config for more examples.
  #
  # An alternative way to set global configuration settings is by storing
  # them in the following environment variables:
  #
  # * +YT_CLIENT_ID+ to store the Client ID for web/device apps
  # * +YT_CLIENT_SECRET+ to store the Client Secret for web/device apps
  # * +YT_API_KEY+ to store the API key for server/browser apps
  # * +YT_LOG_LEVEL+ to store the verbosity level of the logs
  #
  # In case both methods are used together,
  # {Yt::Config#configure Yt.configure} takes precedence.
  #
  # @example Set the API client id/secret for a web-client YouTube app:
  #   ENV['YT_CLIENT_ID'] = 'ABCDEFGHIJ1234567890'
  #   ENV['YT_CLIENT_SECRET'] = 'ABCDEFGHIJ1234567890'
  #
  class Configuration
    # @return [String] the Client ID for web/device YouTube applications.
    # @see https://console.developers.google.com Google Developers Console
    attr_accessor :client_id

    # @return [String] the Client Secret for web/device YouTube applications.
    # @see https://console.developers.google.com Google Developers Console
    attr_accessor :client_secret

    # @return [String] the API key for server/browser YouTube applications.
    # @see https://console.developers.google.com Google Developers Console
    attr_accessor :api_key

    # @return [String] the level of output to print for debugging purposes.
    attr_accessor :log_level

    # @return [String] the access token to act on behalf of a YouTube account.
    attr_accessor :access_token

    # @return [String] a mock error to raise when trying to authenticate.
    attr_accessor :mock_auth_error

    # @return [String] a mock email to return when authenticating.
    # If 'invalid-email' then try to authenticate will raise an error.
    attr_accessor :mock_auth_email

    # Initialize the global configuration settings, using the values of
    # the specified following environment variables by default.
    def initialize
      @client_id = ENV['YT_CLIENT_ID']
      @client_secret = ENV['YT_CLIENT_SECRET']
      @api_key = ENV['YT_API_KEY']
      @log_level = ENV['YT_LOG_LEVEL']
      @mock_auth_error = ENV['YT_MOCK_AUTH_ERROR']
      @mock_auth_email = ENV['YT_MOCK_AUTH_EMAIL']
    end

    # @return [Boolean] whether the logging output is extra-verbose.
    #   Useful when developing (e.g., to print the curl of every request).
    def developing?
      %w(devel).include? log_level.to_s
    end

    # @return [Boolean] whether the logging output is verbose.
    #   Useful when debugging (e.g., to print the curl of failing requests).
    def debugging?
      %w(devel debug).include? log_level.to_s
    end
  end
end