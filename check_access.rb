require 'json'
require 'sinatra/base'

class CheckAccess < Sinatra::Base
  configure do
    set :server, :thin
    set :port, 3000
  end
  
  before do
    puts "\tip:#{request.ip}, #{params['username']}:#{params['password']};\n\tline: #{request.url}"
    halt(404) unless request.ip == '127.0.0.1'
    if params['username'] == 'mainuser' &&
      ( request.path_info =~ /vh|rs/ ||
      ( params.key?('password') && params['password'] == 'valid_password' )) then
      answer = "allow#{' administrator' if request.path_info =~ /in/}"
      # answer = "allow administrator monitoring management policymaker\n"
      # answer = 'deny'
      puts "\t\tmy answer is '#{answer}'"
      halt 200, answer
    end
  end

# username = email, password = sessiontoken
  get '/check_access/in', provides: ['text'] do
    'allow'
  end

# username = email, vhost = virtual_host
  get '/check_access/vh', provides: ['text'] do
    'allow'
  end

# username = email, vhost, resource (exchange|queue), name, permission(configure|write|read)
  get '/check_access/rs', provides: ['text'] do
    'allow'
  end
  run! if app_file == $0
end
