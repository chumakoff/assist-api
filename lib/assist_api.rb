require "assist_api/configuration"
require "assist_api/payment_interface"
require "assist_api/api_methods"
require 'assist_api/exception/configuration_error'

module AssistApi
  extend ApiMethods

  class << self
    def payment_url(*args)
      PaymentInterface.new(*args).url
    end

    def setup
      self.config = Configuration.new
      yield config
      config.validate!
    end

    def config
      return @config if @config

      raise Exception::ConfigurationError, "Configuration is not set"
    end

    private

    attr_writer :config
  end
end
