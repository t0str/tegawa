# frozen_string_literal: true

module Tegawa
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.queue
    @queue ||= Queue.new
  end

  # mail server accessor for exiting cleanly with Ctrl-C
  def self.mail_server
    @mail_server
  end

  def self.mail_server=(mail_server)
    @mail_server = mail_server
  end
end

