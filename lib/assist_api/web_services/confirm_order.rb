require 'assist_api/web_services/base'

module AssistApi
  module WebServices
    class ConfirmOrder < Base
      SERVICE_PATH = "/charge/charge.cfm".freeze

      PERMITTED_EXTRA_PARAMS = %w(
        Amount Currency Language ClientIP
      ).map(&normalize_block).freeze

      def initialize(billnumber, extra_params = {})
        super(extra_params)
        @params[:billnumber] = billnumber
      end

      private

      def parse_result
        last_result = response_xml.elements.each("result/orders/order") {}.last
        Hash[last_result.elements.map { |e| [normalize(e.name), e.text] }]
      end
    end
  end
end