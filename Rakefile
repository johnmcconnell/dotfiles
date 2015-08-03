require 'pry'

task default: %w[usage]

desc 'Print the usage of the Rakefile'
task :usage do
  puts '==== Welcome ==='
  puts 'If this a new machine you will need to run the install the dependencies'
  puts
  puts 'To list the dependencies that will be installed, run:'
  puts 'rake list'
  puts
  puts 'If you already have some dependencies installed, skip them and run:'
  puts 'rake install[janus:autoenv:...]'
  puts
  puts 'If you have no dependencies already on your system run:'
  puts 'rake install'
  puts
end

desc 'Install dependencies'
task :install, [:skips] do |_, args|
  args.with_defaults(skips: '')

  # Parse skips
  skips = args.skips.split(':')

  # Remove deps in skips
  installer = Deps.new
  dep_names = Deps::NAMES.reject do |name|
    skips.include? name
  end

  # Run installation
  dep_names.each do |name|
    installer.send name
  end
end

desc 'List dependencies'
task :list do |o, args|
  puts Deps::NAMES
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
  extend BashFileDeps
  bashfiles :bashrc, :bash_profile

  NAMES = %w[
    gvm
    autoenv
    janus
    bashrc
    bash_profile
  ]

  def gvm
    cmd = 'bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)'
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
