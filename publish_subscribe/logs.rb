#!/usr/bin/env ruby
require 'bunny'

exchange = channel.fanout('logs')
exchange.publish(message)

queue = channel.queue('', exclusive: true)
queue.bind('logs')
