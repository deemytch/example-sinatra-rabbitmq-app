Sample app for testing with rabbitmq http_auth_backend.
For *'mainuser'* with password *'valid_password'* it responds with *'allow administrator'*.
For others it responds *'allow'*.
RabbitMQ configuration is prepared for double use: you can add users both
to mnesia rabbitmq database and to that app.

Steps to start
==============

1. install ruby (I use ruby 3.0.5)
2. download sources
3. run `bundle install --path=vendor`
4. to start app run `bundle exec ruby check_access.rb`
5. install rabbitmq and http_auth_backend plugin
6. modify rabbitmq.config like that:
```
[
  {mnesia, 
    [
      {dump_log_write_threshold, 1000}
    ]
  },
  {rabbit,
    [
      {tcp_listeners, [5673]},
      {auth_backends, [rabbit_auth_backend_internal, rabbit_auth_backend_http]}
    ]},
  {rabbitmq_auth_backend_http,
    [{user_path,     "http://127.0.0.1:3000/check_access/in"},
     {vhost_path,    "http://127.0.0.1:3000/check_access/vh"},
     {resource_path, "http://127.0.0.1:3000/check_access/rs"}
    ]
  }
].
```
7. start rabbitmq service
7. now when you direct your browser to http://localhost:15672/
and fill the username and password mentioned above you should be
able to fully manage your rabbitmq server.
