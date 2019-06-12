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
        @post = current_user.posts.create(:title => params[:title], :content => params[:content])
        binding.pry
        redirect to "/posts/#{@post.id}"
      end
    else
      redirect to '/users/login'
    end
  end

  get '/posts/:id' do #works
    if logged_in?
      @post = Post.find(params[:id])
      erb :'posts/show.html' #needs fix
    else
      redirect to '/users/login'
    end
  end

  get '/posts/:id/edit' do #works
    if logged_in?
      @post = Post.find_by_id(params[:id])
      if @post && @post.user == current_user
        erb :'posts/show.html'
      else
        redirect to '/posts/index'
      end
    else
      redirect to '/users/login'
    end
  end

  patch '/posts/:id' do #works
    if logged_in?
      if params[:title] == "" || params[:content] == ""
        redirect to "/posts/#{params[:id]}/edit"
      else
        @post = Post.find_by_id(params[:id])
        if @post && @post.user == current_user
          if @post.update(title: params[:title]) || @post.update(content: params[:content])
            redirect to "/posts/#{@post.id}"
          else
            redirect to "/posts/#{@post.id/edit}"
          end
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
      @post = Post.find_by_id(params[:id])
      if @post && @post.user == current_user
        @post.delete
        redirect to '/users/show'
      else
        redirect to '/posts/index'
      end
    else
      redirect to '/users/login'
    end
  end

end
