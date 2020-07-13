# frozen_string_literal: true

require "optparse"

require "tegawa"
require "tegawa/bot"
require "tegawa/mail_server"
require "tegawa/watcher"

module Tegawa
  module Cli
    class Application
      attr_reader :mail_server

      class << self
        def start
          args = {
            port: 2525,
            addr: "127.0.0.1",
            # watch_dir: nil,
            log_file: STDOUT,
            channel: nil,
            token: nil
          }

          # opt_parser = OptionParser.new do |opts|
          opt_parser = OptionParser.new { |opts|
            opts.banner = <<-EOF
Usage: tegawa [options]

TeGaWa stands for Telegram GateWay. This tool is supposed to be run
as a daemon and accept local mail as well as watch a directory for
text files. It then forwards these mails and files to a Telegram
channel so you can easily stay informed about what is happening on
your systems.

It expects $TEGAWA_TOKEN to contain your telegram bot token and it
needs the channel_id to which it forwards the information.

            EOF

            opts.on("-cCHANNEL", "--channel=CHANNEL", "The id of the telegram channel that should get the forwarded messages. Make sure your bot is a member first.") do |v|
              args[:channel] = v
            end
            opts.on("-pPORT", "--port=PORT", "Port on which the mailserver should listen. Default 2525.") do |v|
              args[:port] = v.to_i
            end
            opts.on("-aADDR", "--addr=ADDR", "IP on which to listen for connections. Default 127.0.0.1.") do |v|
              args[:addr] = v
            end
            opts.on("-lLOG", "--logfile=LOG", "Where to write logging output. Default is STDOUT.") do |v|
              args[:log_file] = make_log_file(v)
            end
            opts.on("-wWATCH", "--watch=WATCH", "Which directory to watch for files to forward") do |v|
              unless File.directory?(v)
                puts "Watch dir not a directory."
                exit
              end
              args[:watch_dir] = v
            end
            opts.on("-h", "--help", "Prints this help") do
              puts opts
              exit
            end
            opts.on("--version", "Show version") do
              puts "Telegram GateWay Version #{Tegawa::VERSION}"
              exit
            end
          }
          opt_parser.parse!(ARGV)

          args[:token] = ENV["TEGAWA_TOKEN"]

          if args[:token].nil? || args[:channel].nil?
            puts "Please set $TEGAWA_TOKEN to your telegram bot token and provide a --channel argument."
            exit
          end

          setup(args)
        end

        private

        def make_log_file(log_file)
          return log_file if File.file?(log_file)
          return log_file if File.directory?(File.dirname(log_file))

          puts "Log file directory does not exist: #{File.dirname(log_file)}"
          exit 1
        end

        def setup(args)
          Tegawa.logger = Logger.new(args[:log_file])
          @logger = Tegawa.logger
          @queue = Tegawa.queue

          @logger.info "Starting TeGaWa..."

          @mail_server = Tegawa::MailServer.new(args[:addr], args[:port])
          Tegawa.mail_server = @mail_server
          @mail_server.start

          unless args[:watch_dir].nil?
            @watcher = Tegawa::Watcher.new(args[:watch_dir])
          end

          # the bot contains the main loop
          @bot = Tegawa::Bot.new(args[:token], args[:channel])
          @bot.run
        end
      end
    end
  end
end
