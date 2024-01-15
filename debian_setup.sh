#!/bin/bash
# Author : user
# OS : Debian 12 x86_64
# Date : 03-Jan-2024
# Project Name : debian_12_setup

##
##  designed to work on debian 12 x86 Gnome, works on any gnome debian,  
##  to make it works on non gnome debian change this apt install gnome-software-plugin-flatpak -y
##  


if [ $# -ne 1 ]; then
    user_name="root"
    user_home="/root"
else
    user_name=$1
    shift
fi

exist=0
id "$user_name" >/dev/null || exist=1

if [ $exist -eq 0 ] && [[ $user_name != "root" ]];  then
    user_home="/home/$user_name"
elif [[ $user_name != "root" ]]; then
    exit 1
fi




cd $user_home || exit $?
apt update || exit $?
apt upgrade -y || exit $?
echo -e "$user_name\tALL=(ALL:ALL) ALL" >> /etc/sudoers || exit $?
wget raw.githubusercontent.com/ammr01/progtools/main/progtools.sh || exit $?
chmod u+x progtools.sh || exit $?
./progtools.sh $user_name vscode || exit $?
apt install curl sudo -y || exit $?
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg || exit $?
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list || exit $?
apt update || exit $?
apt install brave-browser -fy || exit $?
apt remove firefox-esr -y || exit $?
apt autoremove -y || exit $?
apt install flatpak -y || exit $?
apt install gnome-software-plugin-flatpak -y || exit $? ## change for non gnome
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || exit $?
echo "set completion-ignore-case on" >> /etc/inputrc || exit $?

echo "prompt_command() {
    if [ \$? -ne 0 ]; then
        PS1='\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\[\\033[01;31m\\]▶\\[\\033[00m\\] '
    else
        PS1='\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\[\\033[01;32m\\]▶\\[\\033[00m\\] '
    fi
}

PROMPT_COMMAND=prompt_command 
" >> $user_home/.bashrc 
apt autoremove -y || exit $?






