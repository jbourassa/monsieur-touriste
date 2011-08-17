app_root = File.join(File.dirname(__FILE__))
worker_processes 2
working_directory app_root

timeout 30

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen app_root+"/tmp/unicorn.sock", :backlog => 64

pid app_root+"/tmp/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path app_root+"/tmp/unicorn.stderr.log"
stdout_path app_root+"/tmp/unicorn.stdout.log"
