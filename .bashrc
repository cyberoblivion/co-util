# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


export PROMT_COMMAND='history -n;history -a'
export HISTSIZE=100000
export HISTFILESIZE=100000

#GIT_PROMPT_THEME=Solarized
#GIT_PROMPT_THEME=Chmike
GIT_PROMPT_THEME=Solarized_UserHost

export MAVEN_OPTS="-Xmx1G -XX:MaxPermSize=512M"
export USER_MEM_ARGS="-Xmx4G"
alias gopro='cd ~/dev/projects'

source ~/dev/projects/bash-git-prompt/gitprompt.sh
alias winbox='sudo wine /home/ben/dev/utils/winbox64.exe'
alias myip='dig +short txt ch whoami.cloudflare @1.0.0.1'
umask 0002

# The next line enables bash completion for gcloud.
#source /home/ben/dev/util/google-cloud-sdk/completion.bash.inc


if test -x `which virsh`; then
  export LIBVIRT_DEFAULT_URI=qemu:///system
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
