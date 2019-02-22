require 'digest'

module AssistApi
  module CheckvalueGenerator
    PARAM_NAMES = [:merchant_id, :ordernumber, :orderamount,
                   :ordercurrency, :orderstate].freeze

    private

    def generate_checkvalue(attrs, separator = ';')
      Digest::MD5.hexdigest(
        (
          Digest::MD5.hexdigest(AssistApi.config.secret_word) +
            Digest::MD5.hexdigest(
              PARAM_NAMES.map(&attrs.method(:[])).compact.join(separator)
            )
        ).upcase
      ).upcase
    end
  end
end
