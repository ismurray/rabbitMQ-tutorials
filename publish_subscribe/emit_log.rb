#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new(hostname: 'localhost')
connection.start

# The producer program, which emits log messages, doesn't look much different
# from the previous tutorial. The most important change is that we now want to
# publish messages to our logs exchange instead of the nameless one.
channel = connection.create_channel
exchange = channel.fanout('logs')
# As you see, after establishing the connection we declared the exchange. This
# step is necessary as publishing to a non-existing exchange is forbidden.

message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

exchange.publish(message, persistent: true)
puts " [x] Sent #{message}"

connection.close
