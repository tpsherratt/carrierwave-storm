# class for our uploaders to inherit from, as they share a lot
# of config. TS
module CarrierWave::Storm
  class BaseUploader < CarrierWave::Uploader::Base
    # use mini magick for processing
    include CarrierWave::MiniMagick
    # include our custom retina processor
    extend CarrierWave::Storm::Processors

    # enable retina processor (ie. automatically create retina size for all versions)
    retina!

    # store images on rackspace for staging/production
    if Rails.env.staging? || Rails.env.production?
      storage :fog

    # store images locally for dev (and test)
    else
      storage :file
    end

    # grab the asset host we set in the environment
    asset_host ActionController::Base.asset_host

    # allow the following extensions
    def extension_white_list
      %w(jpg jpeg png)
    end 

    # randomize the file name
    def filename
      "#{secure_token(8)}.#{file.extension}" if original_filename.present?
    end

    protected
    # generate a random token for filename, and store on model
    def secure_token(length=16)
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
    end
  end
end