require 'assist_api/exception/configuration_error'

module AssistApi
  class Configuration
    ENDPOINTS = {production: "https://payments318.paysecure.ru",
                 test: "https://payments.demo.paysecure.ru"}.freeze

    REQUIRED_OPTIONS = [:merchant_id, :login, :password, :mode].freeze

    ALLOWED_OPTIONS  = [:return_url, :success_url, :fail_url,
                        :payment_methods, :secret_word].freeze

    attr_accessor(*(REQUIRED_OPTIONS + ALLOWED_OPTIONS))

    def [](opt_name)
      public_send(opt_name)
    end

    def validate!
      missing_options = REQUIRED_OPTIONS.select { |opt| self[opt].nil? }
      return if missing_options.empty?

      raise Exception::ConfigurationError,
            "Missing configuration options: #{missing_options.join(', ')}"
    end

    def endpoint
      ENDPOINTS[test_mode? ? :test : :production]
    end

    def checkvalue?
      !secret_word.to_s.strip.empty?
    end

    private

    def test_mode?
      mode.to_sym != :production
    end
  end
end
