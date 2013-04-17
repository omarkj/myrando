# Myrando

MyRando! Get your Rando feed in your Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'myrando'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install myrando

## Usage

### Get pictures that have been delivered to you

``` ruby
require 'myrando'
rando = Myrando::MyRando.new(:username => "your email", :password => "your password")
rando.get_photos()
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
