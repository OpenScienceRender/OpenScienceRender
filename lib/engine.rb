require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'yaml'

class OpenScienceRender < Sinatra::Base

  def initialize
    super

    @renderers = load_renderers
  end

  configure do
    set :root, File.join(File.dirname(__FILE__), "..")
  end

  get "/view/:type" do |type|
    renderer = @renderers[type] || @renderers["default"]
    if renderer[:include] == :inline
      content = `#{renderer[:script]} #{request[:url]}`
    else
      content = renderer[:include] % "/render/#{type}?url=#{request[:url]}"
    end

    "<html><body>#{content}</body></html>"
  end

  get "/render/:type" do |type|
    renderer = @renderers[type]

    `#{renderer[:script]} #{request[:url]}`
  end

  private

  def load_renderers
    YAML.load(File.open("renderers.yml", "r"))
  rescue ArgumentError => e
    puts "Could not parse renderers file."
    exit(1)
  end

end
