require "yaml" unless defined?(YAML)
require_relative "version"

module LVM
  module Attributes
    def load(version, name)
      cwd = __dir__

      # was going to be symlinks, but RubyGems didn't seem to want to package
      # them
      if version == "2.02.28"
        version = "2.02.27"
      elsif version == "2.03.23(2)"
        version = "2.03.24(2)"
      elsif ((31..39).map { |x| "2.02.#{x}" }).include?(version)
        version = "2.02.30"
      end

      file = File.join(cwd, "attributes", version, name)

      begin
        YAML.load_file(file)
      rescue Errno::ENOENT => e
        raise ArgumentError.new("Unable to load lvm attributes [#{name}] for version [#{version}]. " \
          "The version/object may not be supported or you may need to upgrade the chef-ruby-lvm-attrib gem. Error [#{e.message}]")
      end
    end
    module_function :load
  end
end
