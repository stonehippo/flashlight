require "rubygems"
require "sinatra"
require "lib/models"

enable :sessions

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

# authentication
get "/login" do
  haml :login
end

post "/login" do
  if auth_key = Flashlight::User.authenticate(params["email"], params["password"] )
    session["auth_key"] = auth_key
    redirect "/issues"
  end
  redirect "login"
end

get "/logout" do
  session.clear
  redirect "/login"
end

# users
get "/profile/:id" do
  
end



# issues
get "/issues" do
  protected!
  haml "issue list"
end

post "/issues" do
  protected!
  haml "issue created"
end

get "/issues/:id" do
  protected!
  haml  "issue detail"
end

put "/issues/:id" do
  protected!
  haml "issue updated"
end

delete "/issues/:id" do
  protected!
  haml "issues deleted"
end

helpers do
  def protected!
    redirect "/login" unless authorized?
  end
  
  def authorized? 
    Flashlight::User.valid_auth_key? session["auth_key"]
  end
end