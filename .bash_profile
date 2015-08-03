# John McConnell .bash_profile

# chruby init
if [[ -f /usr/local/opt/chruby/share/chruby/chruby.sh ]]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh
  source /usr/local/opt/chruby/share/chruby/auto.sh
elif [[ -f /usr/local/share/chruby/chruby.sh ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
else
  echo "Ain't got no chruby"
fi

# gvm setup
[[ -s "/home/vagrant/.gvm/scripts/gvm" ]] && source "/home/vagrant/.gvm/scripts/gvm"

# gopath export
export GOPATH='/Users/jmcconnell1/git/gospace'

# sbt opts for scala, increasing heap memory threshold
export SBT_OPTS="-XX:MaxPermSize=1024M"

# Auto env
source ~/.autoenv/activate.sh

source $HOME/.bashrc

# Git completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Source commands and select
[[ -s ~/.gvm/scripts/gvm ]] && source ~/.gvm/scripts/gvm
gvm use go1.4
