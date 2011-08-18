app_root = File.join(File.dirname(__FILE__))
worker_processes 2
working_directory app_root

timeout 30

listen 'unix:' + app_root + '/tmp/unicorn.sock', :backlog => 64

pid app_root+"/tmp/unicorn.pid"

# Set the path of the log files inside the tmp folder
stderr_path app_root+"/tmp/unicorn.stderr.log"
stdout_path app_root+"/tmp/unicorn.stdout.log"
