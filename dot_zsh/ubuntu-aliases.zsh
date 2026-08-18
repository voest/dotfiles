# Ubuntu specific aliases

alias PKG='command dpkg -l | G'
alias PKGI='command dpkg --get-selections | command grep -v deinstall | command cut -f1 | G'
alias PKGL='command dpkg -L'
alias aar='command sudo apt autoremove'
alias ai='command sudo apt install'
alias au='command sudo apt update'
alias aug='command sudo apt upgrade'
alias aul='command apt list --upgradable'
alias bat='command batcat'
alias fd='command /usr/lib/cargo/bin/fd'
