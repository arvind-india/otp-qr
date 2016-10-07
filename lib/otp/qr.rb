require "otp/qr/version"
require "rotp"
require "google-qr"

module OTP
  class QR

    def initialize(secret, issuer)
      before_setup(issuer)
      secret = secret || ROTP::Base32.random_base32
      @otp = ROTP::TOTP.new(secret, issuer: issuer)
    end

    def generate_qr(email, size = "150x150", margin = 4)
      before_generate(email, size, margin)
      chart = GoogleQR.new(:data => @otp.provisioning_uri(email), :size => size, :margin => margin, :error_correction => "L")
      chart.to_s
    end

    def current_code
      @otp.now
    end
    
    def validate_code(code, drift = nil)
      drift = drift || 0
      @otp.verify_with_drift(code.to_s, 60, Time.now - drift)
    end

    private

    def before_setup(issuer)
      raise "you should provide a issuer" and return if issuer == "" || issuer.nil?
    end

    def before_generate(email, size, margin)
      size = size.split("x")
      raise "invalid size" if size[0].to_i == 0 || size[1].to_i == 0
      raise "invalid margin" if margin.to_i == 0
      raise "you should provide a valid email" and return if email == "" || email.nil?
      raise "first initialize the otp" and return if @otp.nil? 
    end

  end
end
