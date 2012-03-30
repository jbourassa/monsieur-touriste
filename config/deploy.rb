require "bundler/capistrano"

set :application, "Monsieur Touriste"
set :repository,  "https://github.com/jbourassa/monsieur-touriste.git"
set :deploy_to, "~/domains/www.monsieurtouriste.com"
set :deploy_via, :remote_cache
set :use_sudo, false
set :user, "monsieurtouriste"
set :shared_children, %w{ tmp config/production.yml pics public/img/pics }
set :keep_releases, 5
set :env, "production"
set :normalize_asset_timestamps, false

set :scm, :git

role :web, "monsieurtouriste.com"
role :app, "monsieurtouriste.com"

namespace :deploy do
  desc "Link all the config files to the shard directory"
  task :link_configs do
    shared_children.each do |shared_child|
      source = File.join(latest_release, shared_child)
      link = File.join(shared_path, shared_child)
      run "rm -rf #{source} && ln -sf #{link} #{source}"
    end
  end

  desc "This is here to overide the original task"
  task :finalize_update, :roles => :app, :except => { :no_release => true } do
    # noop
  end

  desc "Restart the server (unicorn)"
  task :restart do
    stop
    start
  end

  desc "Start the server (unicorn)"
  task :start do
    run "cd #{latest_release} && bundle exec unicorn -D -E #{env} -c config/unicorn.rb"
  end

  desc "Stop the server (unicorn)"
  task :stop do
    run "if [ `cat #{shared_path}/tmp/unicorn.pid` ]; then kill $(cat #{shared_path}/tmp/unicorn.pid); fi"
  end
end



after 'deploy:setup' do
  run "mkdir -p #{shared_path}/config"
end
after "deploy:finalize_update", "deploy:link_configs"
after "deploy", "deploy:cleanup"
