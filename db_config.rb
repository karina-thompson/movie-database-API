require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'movies'
}

ActiveRecord::Base.establish_connection(options)