require 'pry'
require 'colorize'

task default: %w[usage]

desc 'Print the usage of the Rakefile'
task :usage do
  puts 'If this is a new dotfile installation, please note:'.yellow
  puts '  * You will need to install the dependencies'.yellow
  puts '  * For example: sourcing .bashrc, loading janus, etc...'.yellow
  puts 'To list the dependencies, run:'.green
  puts '  rake list'.cyan
  puts 'If you have no dependencies already on your system run:'.green
  puts '  rake install:skip'.cyan
  puts 'If you already have some dependencies installed,'.green
  puts 'you can skip them by including them in the command:'.green
  puts '  rake install:skip[janus:autoenv:...]'.cyan
  puts 'If you can also choose a specific dependency with:'.green
  puts '  rake install:only[ruby_install]'.cyan
  puts 'If you only want to source the bash scripts run:'.green
  puts '  . ~/.source'.cyan
  puts 'There is also uninstall commands.'.green
  puts 'In order to uninstall a system, run:'.green
  puts '  rake uninstall:only[ruby_install]'.cyan
  puts 'In order to uninstall all, run:'.green
  puts '  rake uninstall:skip'.cyan
  puts 'If you only want to source the bash scripts run:'.green
  puts '  . ~/.source'.cyan
end
task help: :usage

namespace :install do
  desc 'Install dependencies or only those specified'
  task :only, [:only] do |task, args|
    logger.log task do
      args.with_defaults(only: [])

      # Parse skips
      deps = args.only.split(':')

      executor = Installer.new

      # Run installation
      executor.execute(logger, deps)
    end
  end

  desc 'Install dependencies or all except those specified'
  task :skip, [:skips] do |task, args|
    logger.log task do
      args.with_defaults(skips: '')

      # Parse skips
      skips = args.skips.split(':')

      # Remove deps in skips
      deps = Deps::ALL.reject do |name|
        skips.include? name
      end

      executor = Installer.new

      # Run installation
      executor.execute(logger, deps)
    end
  end
end

namespace :uninstall do
  desc 'Uninstall dependencies or only those specified'
  task :only, [:only] do |task, args|
    logger.log task do
      args.with_defaults(only: [])

      # Parse skips
      deps = args.only.split(':')

      executor = Uninstaller.new

      # Run installation
      executor.execute(logger, deps)
    end
  end

  desc 'Uninstall dependencies or all except those specified'
  task :skip, [:skips] do |task, args|
    logger.log task do
      args.with_defaults(skips: '')

      # Parse skips
      skips = args.skips.split(':')

      # Remove deps in skips
      deps = Deps::ALL.reject do |name|
        skips.include? name
      end

      executor = Uninstaller.new

      # Run installation
      executor.execute(logger, deps)
    end
  end
end

desc 'Source bash file'
task :source, [:skips] do |task, args|
  puts 'Unfortunately ruby cannot source in the current terminal'.yellow
  puts 'Please run:'.yellow
  puts '  . ~/.source'.cyan
  puts 'In order to source the files'.yellow
end

desc 'List dependencies'
task :list do |o, args|
  Deps::ALL.each do |name|
    puts " - #{name}".cyan
  end
end

def logger
  @logger ||= TaskLogger.new
end

### BEGIN LIBRARY ###

class TaskLogger
  def initialize
    @stack_size = 0
  end

  def log(name)
    puts header name
    @stack_size += 1
    yield
    @stack_size -= 1
    puts footer
  end

  def header(name)
    pad + "Start".yellow + "["  + "#{name}".cyan + "]:"
  end

  def footer
     pad + "Finish".green
  end

  def pad
    "  " * @stack_size
  end
end

module BashFileDeps
  def bashfiles(*filenames)
    filenames.each do |filename|
      path = File.expand_path("~/.#{filename}")
      define_method(filename) do
        cmd = "bash #{path}"
        system cmd
      end
    end
  end
end

module Deps
  BASHFILES = %w[
    bashrc
    bash_profile
  ]

  NONBASH = %w[
    gvm
    autoenv
    janus
    ruby_install
    chruby
  ]

  ALL = NONBASH + BASHFILES
end

class Executor
  def execute(logger, deps)
    deps.each do |dep|
      logger.log dep do
        send dep
      end
    end
  end

  def sys(commands)
    commands = Array(commands)
    commands.each do |command|
      system command
    end
  end
end

class Installer < Executor
  extend BashFileDeps
  bashfiles *Deps::BASHFILES

  def gvm
    cmd = 'curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash'
    sys cmd
  end

  def autoenv
    cmd = 'git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv'
    sys cmd
  end

  def janus
    cmd = 'curl -Lo- https://bit.ly/janus-bootstrap | bash'
    sys cmd
  end

  def ruby_install
    cmds = [
      "wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz",
      "tar -xzf ruby-install-0.5.0.tar.gz"
    ]
    sys cmds

    puts "Putting ruby install in #{`pwd`} directory".yellow
    Dir.chdir "ruby-install-0.5.0"

    cmd = "sudo make install"
    sys cmd

    Dir.chdir ".."

    cmd = "rm ruby-install-0.5.0.tar.gz"
    sys cmd
  end

  def chruby
    cmds = [
      "wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz",
      "tar -xzf chruby-0.3.9.tar.gz"
    ]
    sys cmds

    puts "Putting chruby in #{`pwd`} directory".yellow
    Dir.chdir "chruby-0.3.9"

    cmd = "sudo make install"
    sys cmd

    cmd = "sudo ./scripts/setup.sh"
    sys cmd

    Dir.chdir ".."

    cmd = "rm chruby-0.3.9.tar.gz"
    sys cmd
  end
end

class Uninstaller < Executor
  def gvm
    cmd = 'gvm implode'
    sys cmd
  end

  def autoenv
    cmd = 'rm -rf ~/.autoenv'
    sys cmd
  end

  def janus
    cmd = 'rm -rf ~/.vim'
    sys cmd
  end

  def ruby_install
    Dir.chdir "ruby-install-0.5.0"
    cmd = "sudo make uninstall"
    sys cmd
  end

  def chruby
    Dir.chdir "chruby-0.3.9"

    cmd = "sudo make uninstall"
    sys cmd
  end
end
