#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('task_queue', durable: true)

# we can use the prefetch method with the value of 1. This tells RabbitMQ not to
# give more than one message to a worker at a time. Or, in other words, don't
# dispatch a new message to a worker until it has processed and acknowledged the
# previous one. Instead, it will dispatch it to the next worker that is not
# still busy.
channel.prefetch(1)

# Our old receive.rb script also requires some changes: it needs to fake a
# second of work for every dot in the message body.
# Message acknowledgments are turned off by default. It's time to turn them on
# using the :manual_ack option and send a proper acknowledgment from the worker,
# once we're done with a task.
begin
  puts ' [*] Waiting for messages. to exit press CTRL+C'
  queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
    puts " [x] Received #{body}"
    # imitate some work
    sleep body.count('.').to_i
    puts ' [x] Done'
    channel.ack(delivery_info.delivery_tag)
    # Using this code we can be sure that even if you kill a worker using CTRL+C
    # while it was processing a message, nothing will be lost. Soon after the
    # worker dies all unacknowledged messages will be redelivered.
  end
rescue Interrupt => _
  connection.close

  exit(0)
end
