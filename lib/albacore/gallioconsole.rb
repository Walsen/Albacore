require 'albacore/albacoretask'

class GallioConsole

  include Albacore::Task
  include Albacore::RunCommand

  OPTIONS = { 
    :debug             => "/d",
    :reports_directory => "/rd",
    :reports_name      => "/rnf",
    :reports_type      => "/rt",
    :show_reports      => "/sr",
    :filter            => "/f"
  }
   
  RT = {
    :html    => "Html",
    :html_c  => "Html-Condensed",
    :mhtml   => "MHtml",
    :mhtml_c => "MHtml-Condensed",
    :text    => "Text",
    :text_c  => "Text-Condensed",
    :xhtml   => "XHtml",
    :xhtml_c => "XHtml-Condensed",
    :xml     => "Xml",
    :xml_i   => "Xml-Inline"
  }

  attr_accessor :solution, :verbosity, :library_path, :debug, :reports_directory, :reports_name, :reports_type,
                :show_reports, :filter, :gallio_echo_executable
  
  def initialize
    @debug             = false
    @reports_directory = ''
    @reports_name      = ''
    @reports_type      = RT[:html]
    @show_reports      = false
    @filter            = ''
    super()
    update_attributes Albacore.configuration.gallioconsole.to_hash
    get_echo_command
    @command = @gallio_echo_executable
  end

  def build_parameters(library)
    check_library library

    command_parameters = []
    command_parameters << "#{library}"
    command_parameters << "#{OPTIONS[:reports_directory]}:#{@reports_directory}" unless @reports_directory.empty?
    command_parameters << "#{OPTIONS[:reports_type]}:#{@reports_type}" unless @reports_type.empty?
    command_parameters << "#{OPTIONS[:reports_name]}:#{@reports_name}" unless @reports_name.empty?
    command_parameters << "#{OPTIONS[:filter]}:Name:#{@filter}" unless @filter.empty?
    command_parameters << "#{OPTIONS[:debug]}" if @debug
    command_parameters << "#{OPTIONS[:show_reports]}" if @show_reports

    command_parameters
  end

  def execute()
    result = run_command "Gallio.Echo", build_parameters(@library_path).join(" ")

    failure_message = "Gallio Failed. See Build Log For Detail"
    fail_with_message failure_message if !result
  end

  def check_library(file)
    return if file
    msg = 'solution cannot be nil'
    fail_with_message msg
  end 

  def get_echo_command

    if @gallio_echo_executable.nil?
      @gallio_echo_executable = ENV['ProgramFiles'].dup << "/Gallio/bin/Gallio.Echo.exe"

      return if File.exist? @gallio_echo_executable
      msg = "The system cannot find the executable in the default path, you must provide it manually."
      fail_with_message msg
    end

    return if File.exist?(@gallio_echo_executable)
    msg = "The system cannot find the path provided, you must provide a valid path."
    fail_with_message msg
  end
end
