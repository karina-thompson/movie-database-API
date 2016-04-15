require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'letsgotothemovies'
}

ActiveRecord::Base.establish_connection(options)