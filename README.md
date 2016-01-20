# Carrierwave::Storm

An integration for Carrierwave with Storm (Steak ORM). Include the gem and everything works as normal - see carrierwave docs for how to configure.

## Additions
Things we have added to Carrierwave

### Retina Images
Have retina images automatically created for all of your versions. We follow apple's naming convension, ie. 
* normal image: my_image.jpg
* x2 retina: my_image@x2.jpg
* x3 retina: my_image@x3.jpg

All you need to do is:
* extend your uploader with `CarriwerWave::Storm::Processors`
* call `retina!`

```ruby

class LogoUploader < CarrierWave::Uploader::Base
  extend CarrierWave::Storm::Processors

  retina!
  
  version :my_version do 
    process resize_to_fit: [250, 150]
  end
end
```




## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave-storm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-storm

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/carrierwave-storm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
