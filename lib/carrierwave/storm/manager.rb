module CarrierWave::Storm
  # Module containing code to hook into callbacks
  module Manager

    def mount_uploader(column)

      after_save :"store_#{column}!"
      before_save :"write_#{column}_identifier"

      before_destroy :"remove_#{column}!"

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def remove_#{column}!(obj)
          obj.send(:"remove_#{column}=", true)
          obj.send(:"write_#{column}_identifier")
        end

        def store_#{column}!(obj)
          obj.send(:"store_#{column}!")
        end

        def write_#{column}_identifier(obj)
          obj.send(:"write_#{column}_identifier")
        end
      RUBY

    end
  end
end