require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module GallioConsole
    include Albacore::Configuration

    def gallioconsole
      @gallioconsoleconfig ||= OpenStruct.new.extend(OpenStructToHash).extend(GallioConsole)
      yield(@gallioconsoleconfig) if block_given?
      @gallioconsoleconfig
    end
  end
end