source 'http://rubygems.org'
gem 'sinatra'
gem 'data_mapper'
gem 'rmagick', '2.13.1', :require => false

group :development do
	gem 'sinatra-reloader', :require => false
	gem 'dm-sqlite-adapter'
end

group :production do
	gem 'unicorn'
	gem 'dm-mysql-adapter'
end
