#!/usr/bin/env bash

APPNAME="$(basename $0)"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : template.sh
# @Created     : Sat, Aug 15, 2020, 22:31 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : Template installer for CentOS
# @Resource    : 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

SCRIPTSFUNCTURL="${SCRIPTSFUNCTURL:-https://github.com/casjay-dotfiles/scripts/raw/master/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSFUNCTFILE:-system-installer.bash}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f "../functions/$SCRIPTSFUNCTFILE" ]; then
    . "../functions/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
    . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
else
    curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
    . "/tmp/$SCRIPTSFUNCTFILE"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

run_post() { local e="$1" ; local m="$(echo $1 | sed 's#devnull ##g')" ; execute "$e" "executing: $m" ; setexitstatus ; set -- ;}
system_service_exists() { if systemctl list-units --full -all | grep -Fq "$1" ; then return 0 ; else return 1 ; fi ; setexitstatus ; set -- ;}
system_service_enable() { if system_service_exists ; then execute "systemctl enable -f $1" "Enabling service: $1" ; fi ; setexitstatus ; set -- ;}
system_service_disable() { if system_service_exists ; then execute "systemctl disable --now $@" "Disabling service: $@" ; fi ; setexitstatus ; set --;}

test_pkg() { devnull rpm -q $pkg $1 && printf_success "$1 is installed" && return 1 || return 0 ; setexitstatus ; set -- ;}
remove_pkg() { if ! test_pkg "$1" ; then execute "yum remove -q -y $1" "Removing: $1" ; fi ; setexitstatus ; set -- ;}
install_pkg() { if test_pkg "$1" ; then execute "yum remove -q -y install $1" "Installing: $1" ; fi ; setexitstatus ; set --  ;}

detect_selinux() { selinuxenabled; if [ $? -ne 0 ]; then return 0; else return 1 ; fi ;}
disable_selinux() { selinuxenabled; setenforce 0 ;}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

[ ! -z "$1" ] && printf_exit 'To many options provided'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

##################################################################################################################
printf_head "Initializing the setup script"
##################################################################################################################

execute "sudo PKMGR"

##################################################################################################################
printf_head "Configuring cores for compiling"
##################################################################################################################

if [ -f /etc/makepkg.conf ]; then
numberofcores=$(grep -c ^processor /proc/cpuinfo)
printf_info "Total cores avaliable: $numberofcores"

if [ $numberofcores -gt 1 ]; then
  sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j'$(($numberofcores+1))'"/g' /etc/makepkg.conf;
  sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T '"$numberofcores"' -z -)/g' /etc/makepkg.conf
fi
fi

##################################################################################################################
printf_head "Installing the packages for TEMPLATE"
##################################################################################################################

install_pkg listofpkgs 

##################################################################################################################
printf_head "Fixing packages"
##################################################################################################################


##################################################################################################################
printf_head "setting up config files"
##################################################################################################################

run_post "cp -rT /etc/skel $HOME"
run_post "dotfilesreq bash"
run_post "dotfilesreq misc"

run_post dotfilesreqadmin samba

##################################################################################################################
printf_head "Enabling services"
##################################################################################################################

system_service_enable lightdm.service
system_service_enable bluetooth.service
system_service_enable smb.service
system_service_enable nmb.service
system_service_enable avahi-daemon.service
system_service_enable tlp.service
system_service_enable org.cups.cupsd.service
system_service_disable mpd

run_post "devnull systemctl set-default multi-user.target"

run_post "devnull grub-mkconfig -o /boot/grub/grub.cfg"

##################################################################################################################
printf_head "Cleaning up"
##################################################################################################################

remove_pkg xfce4-artwork

##################################################################################################################
printf_head "Finished " ; echo""
##################################################################################################################

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set -- 

# end
