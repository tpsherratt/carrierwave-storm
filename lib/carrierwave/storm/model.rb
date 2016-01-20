module CarrierWave::Storm
  module Model
    include CarrierWave::Mount

    # Called in the domain model
    # See carrier wave for detailed docs...
    # super calls mount_base
    def mount_uploader(column, uploader, options={}, &block)
      super

      alias_method :read_uploader, :attribute
      alias_method :write_uploader, :attribute=
      public :read_uploader
      public :write_uploader

      # left in incase we want to add validations
      # include CarrierWave::Sequel::Validations

      manager = (self.name + "Manager").constantize
      manager.mount_uploader(column)
    end
  end
end