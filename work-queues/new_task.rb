#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new(hostname: 'localhost')
connection.start

channel = connection.create_channel

queue = channel.queue('task_queue', durable: true)

# We will slightly modify the send.rb code from our previous example,
# to allow arbitrary messages to be sent from the command line.
message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

queue.publish(message, persistent: true)
puts " [x] Sent #{message}"

connection.close
