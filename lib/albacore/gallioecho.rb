require 'albacore/albacoretask'
require 'albacore/config/gallioechoconfig.rb'

class GallioEcho

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
  
  attr_accessor :solution, :verbosity, :library_path, :debug, :reports_directory, :reports_name, :reports_type, :show_reports, :filter
  
  def initialize
    @debug             = false
    @reports_directory = ''
    @reports_name      = ''
    @reports_type      = RT[:html]
    @show_reports      = false
    @filter            = ''
    @params            = []
    super()
    update_attributes Albacore.configuration.gallioecho.to_hash
  end

  def execute
    check_solution :library_path

    result = run_command "gallio.echo", build_parameters.join(" ")

    failure_message = 'Gallio Failed. See Build Log For Detail'
    fail_with_message failure_message if !result
  end

  def build_parameters    
    @params << "#{@library_path}"
    @params << "#{OPTIONS[:reports_directory]}:#{@reports_directory}" unless @reports_directory.empty?
    @params << "#{OPTIONS[:reports_type]}:#{@reports_type}" unless @reports_type.empty?
    @params << "#{OPTIONS[:reports_name]}:#{@reports_name}" unless @reports_name.empty?
    @params << "#{OPTIONS[:filter]}:Name:#{@filter}" unless @filter.empty?
    @params << "#{OPTIONS[:debug]}" if @debug
    @params << "#{OPTIONS[:show_reports]}" if @show_reports

    @params
  end
  
  def check_solution(file)
    return if file
    msg = 'solution cannot be nil'
    fail_with_message msg
  end 
  
end
