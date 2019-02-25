class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
      # get all the values for ratings from movie and save the unique
    @all_ratings = Movie.ratings
    @selected_ratings = @all_ratings

   # @movies = Movie.order("#{params[:sort_param]}")
  

    # get the selected ratings
   
   
   
   # @movies = Movie.where(rating: @selected_ratings)
  
   # if the user sorts & refines
    if params[:sort_param] and params[:ratings]
      
     #save the settings
     session[:ratings] = params[:ratings]
     session[:sort_param] = params[:sort_param]
    
     @selected_ratings = params[:ratings].keys
     puts @selected_ratings
     @movies = Movie.where(rating: @selected_ratings).order("#{params[:sort_param]} ASC")

      
  # Add in session params where missing
    elsif params[:sort_param] and not params[:ratings]
      redirect_to :action => "index", sort_param: params[:sort_param], ratings: session[:ratings]

    elsif not params[:sort_param] and params[:ratings]
      puts session[:sort_param]
      redirect_to :action => "index", sort_param: session[:sort_param], ratings: params[:ratings]

  # if both the param values are missing give defaults
    else
       # if sort is balnk, default to sort by title
      if session[:sort_param].blank?
         session[:sort_param] = "title"
       end
      if session[:ratings].blank?
         session[:ratings] = Hash[Movie.ratings.map {|k,v| [k, 1]}]
     end
     puts session[:ratings]
      redirect_to :action => "index", sort_param: session[:sort_param], ratings: session[:ratings]
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
