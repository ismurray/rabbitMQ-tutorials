#!/usr/bin/env ruby

# require the library first
require 'bunny'

# then connect to RabbitMQ server
# The connection abstracts the socket connection, and takes care of protocol
# version negotiation and authentication and so on for us. Here we connect to a
# broker on the local machine with all default settings.
# If we wanted to connect to a broker on a different machine we'd simply specify
# its name or IP address using the :hostname option:
connection = Bunny.new(hostname: 'localhost')
connection.start

# Next we create a channel, which is where most of the API for getting things
# done resides:
channel = connection.create_channel

# To send, we must declare a queue for us to send to; then we can publish a
# message to the queue:
queue = channel.queue('hello')

channel.default_exchange.publish('Hello World!', routing_key: queue.name)
puts " [x] Sent 'Hello World!'"

# Declaring a queue is idempotent - it will only be created if it doesn't exist
# already. The message content is a byte array, so you can encode whatever you
# like there.

# Lastly, we close the connection
connection.close
