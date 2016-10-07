# Otp-Qr

Simple wrapper for implement otp (one time password) and create a qr code for use e.g with google authenticator

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'otp-qr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install otp-qr

## Usage

Create a otp.rb file in initializers folder and put this
```ruby
OTP = OTP::QR.new('base32secret3232','issuer name')
```
Then you can access to OTP anywhere, e.g rails controller
```ruby
class HomeController < ApplicationController

  def index
    OTP.current_code # => 123456

    OTP.validate_code(123456) # => true
    OTP.validate_code(298765) # => false

    OTP.generate_qr('myemail@email.com')
    # or you can pass a custom size and margin
    OTP.generate_qr('myemail@email.com', "150x150", 4)
  end
end

```
``OTP.generate_qr('myemail@email.com')`` will return a string (https://chart.googleapis.com/chart?cht=qr&chl=otpauth%3A%2F%2Ftotp%2Fissuer%2520name%3Amyemail%40email.com%3Fsecret%3Dbase32secret3232%26issuer%3Dissuer%2Bname&chs=150x150&chld=L%7C4) that contain a qr code

![alt tag](https://raw.githubusercontent.com/patriciojofre/otp-qr/master/docs/qr.png)

if you use google authenticator, this app will show a random code

![alt tag](https://raw.githubusercontent.com/patriciojofre/otp-qr/master/docs/google-authenticator.png)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/patriciojofre/otp-qr.

