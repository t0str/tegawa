# frozen_string_literal: true

require "logger"

require "tegawa/version"
require "tegawa/core"
require "tegawa/mail_server"
require "tegawa/watcher"
require "tegawa/bot"

module Tegawa
  class Error < StandardError; end
  # Your code goes here...
  # try to gracefully shutdown on Ctrl-C
  trap("INT") do
    puts "#{Time.now}: Interrupted, exit now..."
    exit 0
  end

  # setup exit code
  at_exit do
    Tegawa.mail_server&.stop
    # puts "#{Time.now}: TeGaWa down!\n"
  end
end
