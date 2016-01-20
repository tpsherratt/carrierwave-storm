require 'storm'
require 'carrierwave'
require "carrierwave/storm/version"
require "carrierwave/storm/processors/retina"
require "carrierwave/storm/model"
require "carrierwave/storm/manager"
require "carrierwave/storm/base_uploader"

# carrierwave
module CarrierWave::Storm
  module Validations
  end
end

Storm::BaseModel.send(:extend, CarrierWave::Storm::Model)
Storm::BaseManager.send(:extend, CarrierWave::Storm::Manager)
