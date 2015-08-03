require 'pry'
require 'colorize'

task default: %w[usage]

desc 'Print the usage of the Rakefile'
task :usage do
  puts 'If this is a new dotfile installation, please note:'.yellow
  puts '  * You will need to install the dependencies'.yellow
  puts '  * For example: sourcing .bashrc, loading janus, etc...'.yellow
  puts 'To list the dependencies that will be installed, run:'.green
  puts '  rake list'.cyan
  puts 'If you have no dependencies already on your system run:'.green
  puts '  rake install'.cyan
  puts 'If you already have some dependencies installed,'.green
  puts 'you can skip them by including them in the command:'.green
  puts '  rake install[janus:autoenv:...]'.cyan
  puts 'If you only want to source the bash scripts run:'.green
  puts '  rake source'.cyan
  puts 'If only want to source some of the bash scripts,'.green
  puts 'you can use the same format as install:'.green
  puts '  rake source[bashrc:...]'.cyan
end
task help: :usage

desc 'Install dependencies'
task :install, [:skips] do |task, args|
  logger.log task do
    args.with_defaults(skips: '')

    # Parse skips
    skips = args.skips.split(':')

    # Remove deps in skips
    installer = Deps.new
    dep_names = Deps::NAMES.reject do |name|
      skips.include? name
    end

    # Run installation
    installer.install(logger, dep_names)
  end
end

desc 'Source bash file'
task :source, [:skips] do |task, args|
  logger.log task do
    args.with_defaults(skips: '')

    # Parse skips
    skips = args.skips.split(':')

    # Remove deps in skips
    installer = Deps.new
    dep_names = Deps::BASHFILES.reject do |name|
      skips.include? name
    end

    # Run installation
    installer.install(logger, dep_names)
  end
end

desc 'List dependencies'
task :list do |o, args|
  Deps::NAMES.each do |name|
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
        cmd = "source #{path}"
        system cmd
      end
    end
  end
end

class Deps
  BASHFILES = %w[
    bashrc
    bash_profile
  ]

  NAMES = %w[
    gvm
    autoenv
    janus
  ] + BASHFILES

  extend BashFileDeps
  bashfiles *BASHFILES

  def install(logger, deps)
    deps.each do |dep|
      logger.log dep do
        send dep
      end
    end
  end

  def gvm
    cmd = 'curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash'
    system cmd
    cmd = 'source /home/jmcconnell/.gvm/scripts/gvm'
    system cmd
  end

  def autoenv
    cmd = 'git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv'
    system cmd
  end

  def janus
    cmd = 'curl -Lo- https://bit.ly/janus-bootstrap | bash'
    system cmd
  end
end
