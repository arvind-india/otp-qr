require "otp/qr/version"
require "rotp"
require "google-qr"

module ActsAsOTPable

  def otp_generate_secret
    self.secret = ROTP::Base32.random_base32
    self.save
    self.secret
  end

  def otp_current_code
    @otp = ROTP::TOTP.new(self.secret, issuer: ActsAsOTPable.config.issuer)
    @otp.now
  end

  def otp_qr_code
    @otp = ROTP::TOTP.new(self.secret, issuer: ActsAsOTPable.config.issuer)
    chart = GoogleQR.new(:data => @otp.provisioning_uri(self.email), :size => ActsAsOTPable.config.size, :margin => ActsAsOTPable.config.margin, :error_correction => "L")
    chart.to_s
  end

  def otp_valid_code?(code, drift = 30)
    @otp = ROTP::TOTP.new(self.secret, issuer: ActsAsOTPable.config.issuer)
    @otp.verify_with_drift(code.to_s, 60, Time.now - drift)
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  class Config

    attr_accessor *%w(issuer size margin)

    def initialize
      @issuer        = nil
      @size          = nil
      @margin        = nil
    end
    
  end

end
