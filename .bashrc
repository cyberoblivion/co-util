# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
#	. /etc/bashrc
#fi


#shopt -s histappend
export PROMT_COMMAND='history -n;history -a'
export HISTSIZE=100000
export HISTFILESIZE=100000

#GIT_PROMPT_THEME=Solarized
#GIT_PROMPT_THEME=Chmike
GIT_PROMPT_THEME=Solarized_UserHost
#GIT_PROMPT_PREFIX="(\h: "

#export HISTSIZE=5000
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/10.2.0.5/client/lib/
#export ORACLE_HOME=/usr/lib/oracle/10.2.0.5/client
export TNS_ADMIN=/home/ben/dev/projects/oracle/tnsadmin
export TWO_TASK=//10.49.12.32:1531/listener

#export MAVEN_HOME=/home/ben/dev/utils/apache-maven-3.6.3
export MAVEN_OPTS="-Xmx1G -XX:MaxPermSize=512M"
#export JAVA_HOME=/usr/java/latest
#export OIDE_JAVA_HOME=/usr/java/jdk1.6.0_33
#export PATH=$PATH:/home/ben/dev/utils/gitutils/ddollar-git-utils-0d3a497:/home/ben/.local/bin:/usr/local/cuda-12.1/bin
export SQLPATH=/home/ben/dev/projects/sql
export GEM_HOME=/home/ben/dev/gems

export USER_MEM_ARGS="-Xmx4G"
#export WL_HOME=/bendev/Oracle/Middleware/wlserver_10.3
#export CLASSPATH=$WL_HOME/server/lib/weblogic.jar
#export GRADLE_OPTS="-Dorg.gradle.daemon=true"
# User specific aliases and functions
#alias keepass='mono /home/ben/dev/utils/keepass/KeePass.exe'
alias gocompass='cd ~/dev/projects/compass/compass'
alias gox='cd ~/dev/projects/compass/compass-next'
alias goplay='cd ~/dev/projects/cim-playbooks'
alias gopro='cd ~/dev/projects'
#alias gouas='cd ~/dev/projects/cim-iteration7'
#alias ireport='/home/ben/dev/utils/iReport-3.7.1/bin/ireport --jdkhome /usr/java/jdk1.7.0_79'
#alias sqlplus='rlwrap sqlplus64'
#alias setupWLSEnv.sh='/bendev/Oracle/Middleware/wlserver_10.3/server/bin/setWLSEnv.sh'
alias jmeter='~/dev/utils/jmeter/apache-jmeter-2.13/bin/jmeter'
source ~/dev/projects/bash-git-prompt/gitprompt.sh
#alias idea='~/dev/utils/idea/idea-IU-221.5591.52/bin/idea.sh'
alias winbox='sudo wine /home/ben/dev/utils/winbox64.exe'
alias myip='dig +short txt ch whoami.cloudflare @1.0.0.1'
umask 0002

# The next line enables bash completion for gcloud.
#source /home/ben/dev/util/google-cloud-sdk/completion.bash.inc


if test -x `which virsh`; then
  export LIBVIRT_DEFAULT_URI=qemu:///system
fi
export MAVEN_OPTS="-Xmx1G"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
