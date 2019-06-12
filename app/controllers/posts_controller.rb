class PostsController < ApplicationController

  get '/posts/index' do #works
    if logged_in?
      @posts = Post.all
      erb :'posts/index.html'
    else
      redirect to '/users/login'  #don't need this, must guard edit buttons
    end
  end

  get '/posts/new' do #works
    if logged_in?
      erb :'posts/new.html'
    else
      redirect to '/users/login'
    end
  end

  post '/posts' do #works
    if logged_in?
      if params[:title] == "" || params[:content] == ""
        redirect to '/posts/new'
        #add error message
      else
        @post = Post.create(:title => params[:title], :content => params[:content])
        @post.user = current_user
        @post.save
        redirect to "/posts/#{@post.id}"
      end
    else
      redirect to '/users/login'
    end
  end

  get '/posts/:id' do #works
    if logged_in?
      @post = Post.find(params[:id])
      erb :'posts/show.html'
    else
      redirect to '/users/login'
    end
  end

  get '/posts/:id/edit' do #works
    if logged_in?
      @post = Post.find_by_id(params[:id])
      if @post && @post.user == current_user
        erb :'posts/:id/edit.html'
      else
        redirect to '/posts/index'
      end
    else
      redirect to '/users/login'
    end
  end

  patch '/posts/:id' do #works
    if logged_in?
      if params[:content] == ""
        redirect to "/posts/#{params[:id]}/edit"
      else
        @post = Post.find_by_id(params[:id])
        if @post && @post.user == current_user
          @post.update(content: params[:content])
          redirect to "/posts/#{@post.id}"
        else
          redirect to '/posts/index'
        end
      end
    else
      redirect to '/users/login'
    end
  end

  delete '/posts/:id' do #works
    if logged_in?
      @post = Post.find(params[:id])
      if @post && @post.user == current_user
        @post.destroy
        redirect to '/posts/index'
      else
        redirect to '/posts/index'
      end
    else
      redirect to '/users/login'
    end
  end

end
