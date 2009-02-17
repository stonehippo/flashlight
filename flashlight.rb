require "rubygems"
require "sinatra"


before do
  @app_name = "Flashlight"
  @app_tagline = "Lite-weight issue tracking"
end

get "/" do
  haml :index
end

get "/styles.css" do
  content_type "text/css", :charset => "utf-8"
  sass :styles
end