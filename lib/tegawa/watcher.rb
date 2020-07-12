# frozen_string_literal: true

require "listen"

module Tegawa
  class Watcher
    def initialize(watch_dir)
      @queue = Tegawa.queue
      @logger = Tegawa.logger

      @logger.info "Watching #{watch_dir} for files"

      # TODO: maybe allow to specify extension and recursion?
      # listener = Listen.to("watch_dir", only: /.message$/) { |_modified, created, _removed|
      @listener = Listen.to(watch_dir) { |_modified, created, _removed|
        next if created.empty?

        consume_file(created)
      }
      @listener.start # not blocking
    end

    def consume_file(paths)
      paths.each do |path|
        next unless File.exist?(path)

        # FIXME: thread pool
        Thread.new {
          content = File.read(path)[0..4095]
          message = "File: #{path}\r\n\r\n#{content}"
          @queue << message
          File.delete(path)
        }
      end
    end
  end
end
