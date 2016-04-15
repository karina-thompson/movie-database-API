require 'sinatra'
require 'sinatra/reloader'
require 'httparty'

require './db_config'
require './models/movie' 


after do
  ActiveRecord::Base.connection.close
end


get '/' do
  erb :index
end


get '/about' do
  movie_input = params[:movie]
  
  if Movie.exists?(title: movie_input)
    movie = Movie.find_by(title: movie_input)
  else
    data = HTTParty.get("http://omdbapi.com/?t=#{ CGI::escape(movie_input) }")
    puts data.inspect
    movie = Movie.create(title: data["Title"], rated: data["Rated"], genre: data["Genre"], writer: data["Writer"], director: data["Director"], year: data["Year"], runtime: data["Runtime"], actors: data["Actors"], poster_url: data["Poster"], plot: data["Plot"], country: data["Country"] )
  end
  
  erb :about, locals: { movie: movie }
end


def get_matches(results)
  titles = []
  results["Search"].each do |entry|
    titles << entry
  end
  titles
end


get '/search_results' do
  movie_input = params[:movie]

  results = HTTParty.get("http://omdbapi.com/?s=#{ movie_input }")
  title_matches = results["Search"]
  
  return erb :not_found if results["Error"]

  redirect to("/about?movie=#{ title_matches[0]["Title"] }") if title_matches.size == 1
  
  all_title_matches = get_matches(results)

  if results["totalResults"].to_i > 10
      results_page_2 = HTTParty.get("http://omdbapi.com/?s=#{ movie_input }&page=2")
      all_title_matches.concat(get_matches(results_page_2))
  end

  erb :search_results, locals: {all_title_matches: all_title_matches}
end










