# Create retina versions of images
# inspired by https://github.com/jhnvz/carrierwave_retina/blob/master/lib/carrierwave_retina/optimizer.rb
module CarrierWave::Storm
  module Processors
    def retina!
      extend Retina
    end

    module Retina
      def version(name, options={}, &block)
        super
        retina_versions(name, options) unless options[:retina] == false
      end

      def retina_versions(name, options={})
        # make sure we don't recursively add retina versions!
        options[:retina] = false

        # Grab the version we're dealing with
        v = versions[name.to_sym]

        # Check if there's a resize processor
        resize_processor = nil
        v[:uploader].processors.each do |p|
          # processor look like eg. [:resize_to_fit, [250, 150], nil]
          resize_processor = p if p[0].to_s.scan(/resize_to_fill|resize_to_limit|resize_to_fit|resize_and_pad/).any?
        end

        # Define a retina version if we found a processor doing resizing
        if resize_processor
          # processor look like eg. [:resize_to_fit, [250, 150], nil]
          proc_name = resize_processor[0]
          proc_options = resize_processor[1]

          (2..3).each do |multiplier|
            width  = proc_options[0] * multiplier
            height = proc_options[1] * multiplier

            # create our retina version
            version "#{name}_retina#{multiplier}", options do
              process proc_name => [width, height]

              # clone the other processors from the version we're retinaizing
              v[:uploader].processors.each do |other_proc|
                next if other_proc[0] == proc_name # skip the resize one
                process other_proc[0], other_proc[1] unless other_proc[1].empty?
                process other_proc[0] if other_proc[1].empty?
              end

              # mash the file name to include @2/@3 ting
              def full_filename(for_file)
                file_name = super for_file

                multiplier = 2 if file_name.gsub!("_retina2", '')
                multiplier = 3 if file_name.gsub!("_retina3", '')
                file_name.gsub!(/\.+[a-zAZ]{3,4}$/){ "@#{multiplier}x#{$&}" }
                file_name
              end

            end # version
          end # (2..3).each
        end # if resize_processor
      end # retina_versions()

    end
  end
end