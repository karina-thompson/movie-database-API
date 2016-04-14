require 'sinatra'
require 'sinatra/reloader'
require 'httparty'




get '/' do
  erb :index
end

get '/about' do
  movie_input = params[:movie]
  result = HTTParty.get("http://omdbapi.com/?t=#{ CGI::escape(movie_input) }")

  movie = {}
  %w(Title Rated Genre Writer Director Year Runtime Actors Awards Poster Plot Country).each do |key|
    movie[key.downcase.to_sym] = result[key]
  end
    erb :about, locals: { movie: movie }
end


def get_titles(result)
  titles = []
  result["Search"].each do |entry|
    titles << entry["Title"]
  end
  titles
end


get '/landing_page' do
  movie_input = params[:movie]
  search_result = HTTParty.get("http://omdbapi.com/?s=#{ movie_input }")
  
  return erb :not_found if search_result["Error"]

  redirect to("/about?movie=#{ search_result["Search"][0]["Title"] }") if search_result["Search"].size == 1
  
  title_matches = get_titles(search_result)

  if search_result["totalResults"].to_i > 10
      result_page2 = HTTParty.get("http://omdbapi.com/?s=#{ movie_input }&page=2")
      title_matches.concat(get_titles(result_page2))
  end

  erb :landing_page, locals: {title_matches: title_matches}
end










