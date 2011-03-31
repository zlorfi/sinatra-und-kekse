require 'rubygems'
require 'sinatra'
require 'haml'

#enable :sessions
use Rack::Session::Pool
set :port, 8080
set :haml, :format => :html5

get '/' do
  session["user"] ||= nil
  
  haml :index
end

get '/create' do
  haml :create
end

post '/create' do
  session["user"] = params[:name]
  redirect '/'
end

get '/destroy' do
  session["user"] = nil
  
  haml :destroy
end

not_found do
    'doh!'
end
  
__END__

@@ layout
%html
  %head
    %title Sinatra und Kekse
  %body
    %p{:style => "color:red"} #{request.host}
    = yield
  
@@ index
- name = session["user"].nil? ? "Fremder" : session["user"].capitalize
%h1= "I gude, #{name}!"
%p
  - if session["user"].nil?
    %a{:href => '/create'} Wie lautet dein Name, Keks?
  - else
    Long time no see!!! :)
- unless session["user"].nil?
  %p Ok, mach mal den Keks <a href="/destroy">kaputt</a>!
  
@@ create
%h1 Tag,
%form{:method => 'post'}
  mein Name lautet: 
  %input{:type => 'text', :name => 'name'}
  %input{:type => 'submit', :value => 'sich vorstellen'}

@@ destroy
%h1 ...und tschüss!
%p Wir sehen uns ein <a href="/">anderes Mal</a>!
