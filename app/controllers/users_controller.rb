class UsersController < ApplicationController

  get '/users/my_posts' do
    @user= current_user
    if logged_in?
      erb :'users/my_posts.html'
    else
      redirect to '/users/login'
    end
  end


  # get '/users/:slug' do
  #   user = User.find_by_slug(params[:slug])
  #   #erb :'users/signup.html'
  # end


    get '/users/login' do
      if !logged_in?
        erb :'users/login.html'
      else
        redirect '/posts/index'
      end
    end

    post '/users/login' do
      user = User.find_by(:email => params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/posts/index'
      else
        redirect to '/users/signup'
      end
    end

  get '/users/signup' do
    if !logged_in?
      erb :'users/signup.html'
    else
      redirect to '/posts/index'
    end
  end

  post '/users/signup' do
    if params[:email] == "" || params[:password] == ""
      redirect to '/users/signup.html'
    else
      user = User.find_by(:email => params[:email])
      if user
        redirect to '/users/login'
      else
        user = User.create(:email => params[:email], :password => params[:password])
        session[:user_id] = user.id
        redirect to '/posts/index'
      end
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/users/login'
    else
      redirect to '/posts/index'
    end
  end

end
