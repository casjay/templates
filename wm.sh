#!/usr/bin/env bash

SCRIPTNAME="$(basename $0)"
SCRIPTDIR="$(dirname "${BASH_SOURCE[0]}")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : install
# @Created     : Mon, Dec 31, 2019, 00:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : installer script for awesome
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

if [ -f /usr/local/share/CasjaysDev/scripts/functions/app-installer.bash ]; then
    . /usr/local/share/CasjaysDev/scripts/functions/app-installer.bash
elif [ -f "$HOME/.local/share/scripts/functions/app-installer.bash" ]; then
    . "$HOME/.local/share/scripts/functions/app-installer.bash"
else
    mkdir -p "$HOME/.local/share/scripts/functions"
    curl -LSs https://github.com/casjay-dotfiles/scripts/raw/master/functions/app-installer.bash -o "$HOME/.local/share/scripts/functions/app-installer.bash"
    . "$HOME/.local/share/scripts/functions/app-installer.bash"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Defaults

# USER
BIN="$HOME/.local/bin"
CONF="$HOME/.config"
SHARE="$HOME/.local/share"
LOGDIR="$HOME/.local/logs"
BACKUPDIR="$HOME/.local/backups/home"
REPO="${DOTFILESREPO:-https://github.com/casjay-dotfiles}"

# SYSTEM
SYSBIN="/usr/local/bin"
SYSCONF="/usr/local/etc"
SYSSHARE="/usr/local/share"
SYSLOGDIR="$HOME/.local/logs"
SYSBACKUPDIR="$/usr/local/share/backups"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set options

APPNAME="awesome"
PIPNAME=""
PLUGNAME=""
APPDIR="$CONF/$APPNAME"
PLUGDIR="$CONF/$APPNAME/$PLUGNAME"
PIPVERSION="3"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Requires root

#sudoreq  # sudo required
#sudorun  # sudo optional

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# prerequisites

APP=""
PKG=""
PIP=""
MISSING=""
PIPMISSING=""

# - - - - - - - - - - - - - - -

for cmd in awesome xfce4-power-manager volumeicon xscreensaver conky
do
    cmd_exists $cmd || MISSING+="$cmd "
done

# - - - - - - - - - - - - - - -

if [ ! "$(cmd_exists apt)" ]; then PKG="awesome awesome-extra xfce4-power-manager volumeicon-alsa xscreensaver policykit-1-gnome gnome-settings-daemon network-manager-gnome conky polybar tint2"
elif [ ! "$(cmd_exists yum)" ]; then PKG="awesome xfce4-power-manager volumeicon-alsa xscreensaver policykit-1-gnome gnome-settings-daemon network-manager-gnome polybar tint2"
elif [ ! "$(cmd_exists pacman)" ]; then PKG="awesome xfce4-power-manager volumeicon-alsa xscreensaver policykit-1-gnome gnome-settings-daemon network-manager-gnome conky polybar tint2"
fi

# - - - - - - - - - - - - - - -

if [ ! -z "$MISSING" ]; then printf_warning "This requires $MISSING"
  if cmd_exists "pkmgr"; then
  for miss in $PKG
    do execute \
    "requiresudo pkmgr silent $miss" \
    "Attemping install of $miss"
    done
  fi
fi

# - - - - - - - - - - - - - - -

#cmd_exists PIPNAME || PIPMISSING+="PIPNAME "

# - - - - - - - - - - - - - - -

#if [ ! -z "$PIPMISSING" ]; then printf_warning "This requires $PIPMISSING"
#  if cmd_exists "pkmgr"; then
#  for pippkg in $PIPMISSING
#   do execute "requiresudo pkmgr pip $pippkg" \
#   "Attempting to install $pippkg"
#   done
#  fi
#fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ensure directories exist

mkd "$BACKUPDIR"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main progam

if [ -d "$APPDIR/.git" ]; then
    execute \
        "cd $APPDIR && \
        git_update" \
        "Updating $APPNAME configurations"
else
    if [ -d "$BACKUPDIR/$APPNAME" ]; then
        rm_rf "$BACKUPDIR"/"$APPNAME"
    fi
    execute \
        "mv_f $APPDIR $BACKUPDIR/$APPNAME && \
         git_clone -q $REPO/$APPNAME $APPDIR" \
        "Installing $APPNAME configurations"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Plugins

#if [ -d "$PLUGDIR"/.git ]; then
#   execute \
#       "cd $PLUGDIR && git_update" \
#       "Installing NAME for $APPNAME"
#else
#     execute \
#       "git_clone GITREPO $PLUGDIR" \
#       "Plugin NAME has been installed\n"
#fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# run post install scripts

#   execute \
#       "bash $PLUGDIR/install_plugins.sh" \
#       "Running post install scripts"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# exit
if [ ! -z "$EXIT"  ]; then exit "$EXIT" ; fi

# end
#/* vim set expandtab ts=4 noai
