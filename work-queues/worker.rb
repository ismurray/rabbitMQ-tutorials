#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

# Our old receive.rb script also requires some changes: it needs to fake a
# second of work for every dot in the message body.
begin
  puts ' [*] Waiting for messages. to exit press CTRL+C'
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] Received #{body}"
    # imitate some work
    sleep body.count('.').to_i
    puts ' [x] Done'
  end
rescue Interrupt => _
  connection.close

  exit(0)
end
