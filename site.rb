require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require 'RMagick'
require 'data_mapper'
require 'erb'
require 'yaml'

set :config, YAML.load_file(File.join(settings.root, 'config',
                                      "#{settings.environment}.yml"))
set :height, 540

DataMapper.setup :default, settings.config['db_string']

# Define ORM class for pictures
class Pic
  include DataMapper::Resource
  property :id, Serial
  property :msg, String
  property :created_at, DateTime
end

# Finalize and migrate
DataMapper.finalize
DataMapper::Model.raise_on_save_failure
DataMapper.auto_upgrade!

helpers do
  # Auth
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Beware!")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials \
      && @auth.credentials == credentials
  end

  def credentials
    [settings.config['admin_username'], settings.config['admin_password']]
  end

  def is_admin?
    request.path_info.start_with? '/admin'
  end

  def mini_path(id)
    "/img/pics/#{id.to_s}_#{settings.height.to_s}.jpg"
  end

end


# Restrict admin
before do
  protected! if is_admin?
end

# Home
get '/' do
  erb :index, :locals => { :pics => Pic.all(:order => [:created_at.desc]) }
end


# Resize image and cache the result
get %r{^/img/pics/(\d+)_(\d+).jpg$} do |id, passed_height|
  raise not_found unless passed_height.to_i == settings.height
  orig_img = Magick::ImageList.new("pics/#{id.to_s}.jpg")
  new_img = orig_img.resize_to_fit(settings.height)
  new_img.write("public/img/pics/#{id.to_s}_#{passed_height}.jpg")
  headers = {
    'Content-Type' => 'image/jpeg',
    'Expires' => 'Thu, 15 Apr 2020 20:00:00 GMT'
  }
  [200, headers, new_img.to_blob]
end

# Admin index
get %r{^/admin/?$} do
  erb :admin_index, :locals => {
    :pics => Pic.all(:order => [:created_at.desc])
  }
end

get '/admin/add' do
  erb :admin_edit
end

post '/admin/add' do
  Pic.transaction do |t|
    new_pic = Pic.create(:msg => params[:msg], :created_at => Time.now)
    File.open("pics/#{new_pic.id}.jpg", 'wb') do |f|
      f.write(params[:pic][:tempfile].read)
    end
  end

  redirect '/admin'
end

get '/admin/edit/:id' do |id|
  pic = Pic.get(id)
  throw(:halt, [404, "Not Found"]) unless pic
  erb :admin_edit, :locals => {:pic => pic}
end

post '/admin/edit/:id' do |id|
  pic = Pic.get(id)
  throw(:halt, [404, "Not Found"]) unless pic
  pic.update({:msg => params[:msg]})
  redirect '/admin'
end

post '/admin/delete/:id' do
  Pic.get(params[:id]).destroy
  redirect '/admin'
end
