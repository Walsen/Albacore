require 'ostruct'
require 'albacore/support/openstruct'

module Configuration
  module GallioEcho
    include Albacore::Configuration

    def gallioecho
      @gallioechoconfig ||= OpenStruct.new.extend(OpenStructToHash)
      yield(@gallioechoconfig) if block_given?
      @gallioechoconfig
    end
  end
end