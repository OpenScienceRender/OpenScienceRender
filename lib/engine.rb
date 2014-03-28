require 'sinatra/base'

class OpenScienceRender < Sinatra::Base

  get "/view/:type" do |type|
    "Hello, #{type} at #{request[:url]}!"
  end

end
