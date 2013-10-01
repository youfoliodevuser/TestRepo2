set :application, "test repo"
set :domain, "youfolio-beta.com"
set :repository,  "git@github.com:youfoliodevuser/TestRepo2.git"
set :user, "youfolio"

default_run_options[:pty] = true
set :use_sudo, false

set :scm, :git
set :deploy_via, :remote_cache
set :deploy_to, "/home/youfolio/TestRepo"

set :stages, ["staging", "production"]
set :default_stage, "staging"


role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
set :rvm_ruby_string, '2.0.0'
set :rvm_type, :user  # Don't use system-wide RVM

namespace :deploy do
  task :start do 
    run "sudo /etc/init.d/nginx start" 
  end
  task :stop do 
    run "sudo /etc/init.d/nginx stop"    
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo /etc/init.d/nginx restart"    
  end
  
  desc "Copies database credentials"
  task :copy_db_credentials do
    run "cp #{shared_path}/credentials/database.yml #{release_path}/config/database.yml"
  end
  
  desc "install the necessary prerequisites"
  task :bundle_install do
    run "cd #{release_path} && bundle install"
  end
  
end

#before "deploy:assets:precompile", "deploy:bundle_install"
#before "deploy:assets:precompile", "deploy:copy_db_credentials"
# after "deploy:update_code", "deploy:bundle_install"

#after "deploy", "deploy:migrate", "deploy:cleanup"#, "deploy:refresh_media", "deploy:seed"
