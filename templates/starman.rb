Eye.application 'starman' do
  working_dir '/'
  stdall '/var/log/eye/starman-stdall.log' # stdout,err logs for processes by default
  trigger :flapping, times: 10, within: 1.minute, retry_in: 3.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

  process :starman do
    pid_file '{{ starman_pid }}'
    start_command 'starman --user={{ starman_user }} --listen :{{ starman_port }} --workers {{ starman_nr_workers }} --daemonize --pid {{ starman_pid }} --error-log {{ starman_log }} {{ starman_app }}'
    stop_command 'kill -QUIT {PID}'
    # restart_command 'kill -HUP {PID}'
    command :'reload', 'kill -HUP {PID}'

    start_timeout 10.seconds
    stop_timeout 5.seconds

  end

end
