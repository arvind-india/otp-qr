require "otp/qr/version"
require "rotp"
require "google-qr"
require "pry"

module Otp
  module Qr

    def self.setup(secret, issuer)
      otp_secret = secret || ROTP::Base32.random_base32
      @otp = ROTP::TOTP.new(otp_secret, issuer: issuer)
    end

    def self.generate_qr(email, size = "150x150", margin = 4)
      raise "should provide a valid email" and return if email == ""
      chart = GoogleQR.new(:data => @otp.provisioning_uri(email), :size => size, :margin => margin, :error_correction => "L")
      chart.to_s
    end

    def self.validate_code(code, drift = nil)
      drift = drift || 0
      @otp.verify_with_drift(code.to_s, 60, Time.now - drift)
    end

  end
end
