# frozen_string_literal: true

require "telegram/bot"

module Tegawa
  class Bot
    def initialize(token, channel_id)
      @token = token
      @channel_id = channel_id
      @queue = Tegawa.queue
      @logger = Tegawa.logger

      @bot = Telegram::Bot::Client.new(@token)
      @logger.info "Ready to forward messages to channel: #{@channel_id}"
    end

    def run
      # FIXME: needs a thread pool to stop flooding
      while (message = @queue.pop)
        @logger.info "Forwarding message to telegram"
        @bot.api.send_message(chat_id: @channel_id, text: message)
      end
    end
  end
end
