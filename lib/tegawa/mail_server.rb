# frozen_string_literal: true

require "midi-smtp-server"
require "mail"

module Tegawa
  class MailServer < MidiSmtpServer::Smtpd
    def initialize(addr, port)
      super(port, addr)
      @queue = Tegawa.queue
      @logger = Tegawa.logger

      @logger.info "Mailserver running on #{addr}:#{port}"
    end

    def on_message_data_event(ctx)
      # Output for debug
      @logger.debug("mail reveived at: [#{ctx[:server][:local_ip]}:#{ctx[:server][:local_port]}] from: [#{ctx[:envelope][:from]}] for recipient(s): [#{ctx[:envelope][:to]}]...")

      # Just decode message once to make sure, that this message ist readable
      @mail = Mail.read_from_string(ctx[:message][:data])

      # handle incoming mail, just show the message source
      @logger.info "You've got mail! From: #{@mail.from}"

      message = "**Mail-From:** #{@mail.from}\r\n**Subject:** #{@mail.subject}\r\n\r\n#{@mail.body}"
      @queue << message
    end
  end
end
