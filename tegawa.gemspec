require_relative "lib/tegawa/version"

Gem::Specification.new do |spec|
  spec.name = "tegawa"
  spec.version = Tegawa::VERSION
  spec.authors = ["Otto Strassen"]
  spec.email = ["otto@tostr.io"]

  spec.summary = "Small daemon that takes information from various places and relays them over telegram."
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage = "https://github.com/to-str/tegawa"
  spec.license = "MIT"
  # minimum version required by 'listen' gem
  spec.required_ruby_version = Gem::Requirement.new(">= 1.9.3")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/to-str/tegawa"
  spec.metadata["changelog_uri"] = "https://github.com/to-str/tegawa"

  spec.add_runtime_dependency "telegram-bot-ruby", ["~> 0.12.0"]
  spec.add_runtime_dependency "midi-smtp-server", ["~> 2.1.0"]
  spec.add_runtime_dependency "mail", ["~> 2.7"]
  spec.add_runtime_dependency "faraday", ["~> 0.17.3"]
  spec.add_runtime_dependency "ffi", ["~> 1.10.0"]
  spec.add_runtime_dependency "listen", ["~> 3.0.0"]
  spec.add_runtime_dependency "rb-inotify", ["~> 0.9.0"]

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
