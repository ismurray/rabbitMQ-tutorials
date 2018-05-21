#!/usr/bin/env ruby
require 'bunny'

# Setting up is the same as the producer; we open a connection and a channel,
# and declare the queue from which we're going to consume. Note this matches up
# with the queue that send publishes to.
connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

# Note that we declare the queue here, as well. Because we might start the
# consumer before the producer, we want to make sure the queue exists before we
# try to consume messages from it.

# We're about to tell the server to deliver us the messages from the queue.
# Since it will push us messages asynchronously, we provide a callback that will
# be executed when RabbitMQ pushes messages to our consumer. This is what
# Bunny::Queue#subscribe does.
begin
  puts ' [*] Waiting for messages. to exit press CTRL+C'
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] Received #{body}"
  end
rescue Interrupt => _
  connection.close

  exit(0)
end
# Bunny::Queue#subscribe is used with the :block option that makes it block the
# calling thread (we don't want the script to finish running immediately!).
