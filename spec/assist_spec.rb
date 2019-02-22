require 'spec_helper'

describe AssistApi do
  it "has a version number" do
    expect(AssistApi::VERSION).not_to be nil
  end

  describe "api methods" do
    before { set_config }
    after { clear_config }

    describe ".payment_url" do
      subject { AssistApi.payment_url(123, 100) }

      it "shoud return payment url" do
        expect(subject).to eq AssistApi::PaymentInterface.new(123, 100).url
      end
    end

    describe ".order_status" do
      before do
        stub_request(:post, /.*orderstate\/orderstate.cfm/).to_return(
          status: 200,
          body: File.read(File.join("spec", "fixtures", "order_status_ok.xml"))
        )
      end

      subject { AssistApi.order_status(123) }

      it "shoud return OrderStatus instance" do
        expect(subject).to be_a AssistApi::WebServices::OrderStatus
      end

      it "shoud contain passed parameter" do
        expect(subject.request_params[:ordernumber].to_s).to eq "123"
      end

      it "should have been performed" do
        expect(subject.instance_variable_get("@response")).to be
      end
    end

    describe ".cancel_order" do
      before do
        stub_request(:post, /.*cancel\/cancel.cfm/).to_return(
          status: 200,
          body: File.read(File.join("spec", "fixtures", "cancel_order_ok.xml"))
        )
      end

      subject { AssistApi.cancel_order("1234567890") }

      it "shoud return CancelOrder instance" do
        expect(subject).to be_a AssistApi::WebServices::CancelOrder
      end

      it "shoud contain passed parameter" do
        expect(subject.request_params[:billnumber].to_s).to eq "1234567890"
      end

      it "should have been performed" do
        expect(subject.instance_variable_get("@response")).to be
      end
    end

    describe ".confirm_order" do
      before do
        stub_request(:post, /.*charge\/charge.cfm/).to_return(
          status: 200,
          body: File.read(File.join("spec", "fixtures", "confirm_order_ok.xml"))
        )
      end

      subject { AssistApi.confirm_order("1234567890") }

      it "shoud return CancelOrder instance" do
        expect(subject).to be_a AssistApi::WebServices::ConfirmOrder
      end

      it "shoud contain passed parameter" do
        expect(subject.request_params[:billnumber].to_s).to eq "1234567890"
      end

      it "should have been performed" do
        expect(subject.instance_variable_get("@response")).to be
      end
    end
  end

  describe ".setup" do
    after(:each) { clear_config }

    it "should set configuration" do
      AssistApi.setup { |config| assign_config_options(config) }

      required_config_options.each do |key, value|
        expect(AssistApi.config[key]).to eq value
      end
    end

    it "should clear previously set configuration" do
      AssistApi.setup do |config|
        assign_config_options(config)
        config.secret_word = 'secret'
      end
      expect(AssistApi.config.secret_word).to be

      AssistApi.setup { |config| assign_config_options(config) }
      expect(AssistApi.config.secret_word).to_not be
    end

    context "when configuration is not valid" do
      it "should raise an error" do
        expect{ AssistApi.setup {} }.to raise_error AssistApi::Exception::ConfigurationError
      end
    end
  end

  describe ".config" do
    context "when configuration is set" do
      before(:each) { set_config }
      after(:each) { clear_config }

      it "should return configuration" do
        expect(AssistApi.config).to be_a AssistApi::Configuration
      end
    end

    context "when configuration is not set" do
      it "should raise an error" do
        expect{ AssistApi.config }.to raise_error(AssistApi::Exception::ConfigurationError,
                                               "Configuration is not set")
      end
    end
  end
end
