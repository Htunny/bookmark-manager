ENV['RACK_ENV'] ||= "development"
require 'sinatra/base'
require 'sinatra/flash'
require_relative 'data_mapper_setup'
require 'byebug'

class Bookmark < Sinatra::Base
  use Rack::MethodOverride

  enable :sessions
  register Sinatra::Flash

  set :session_secret, 'super secret'

  get '/session/new' do
    erb :'session/new'
  end

  post '/session' do
    user = User.first(email: params[:email])
    if user.password == params[:password]
      session[:user_id] = user.id
      redirect '/links'
    else
      redirect '/session/new'
    end
  end

  get '/session/end' do
    erb :'/session/end'
  end

  delete '/session' do
    flash[:goodbye] = "Goodbye, #{user_name.email}"
    session[:user_id] = nil
    redirect '/links'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect '/links'
    else
      flash[:error] = user.errors.full_messages.join('. ')
      flash[:email] = params[:email]
      redirect '/users/new'
    end
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/add' do
    erb :'links/add'
  end

  post '/links' do
    link = Link.create(url: params[:url], title: params[:title])
    params[:tags].split.each do |tag|
      link.tags << Tag.create(tags: tag)
    end
    link.save
    redirect '/links'
  end

  get '/tags/:tags' do
    tag = Tag.all(tags: params[:tags])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  helpers do
    def user_name
      @user_name ||= User.get(session[:user_id])
    end
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
