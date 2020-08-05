#!/usr/bin/env bash

APPNAME="IconName"
SCRIPTNAME="$(basename $0)"
SCRIPTDIR="$(dirname "${BASH_SOURCE[0]}")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : install
# @Created     : Mon, Dec 31, 2019, 00:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : installer script for IconName
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

CONF="/usr/local/etc/CasjaysDev"
ICONDIR="/usr/local/share/icons"
HOMEDIR="/usr/local/share/CasjaysDev/iconmgr"
APPDIR="/usr/local/share/CasjaysDev/iconmgr/$APPNAME"
REPO="${ICONMGRREPO:-https://github.com/iconmgr}"

# Version
APPVERSION="$(curl -LSs $REPO/$APPNAME/raw/master/version.txt)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Requires root

sudoreq  # sudo required
#sudorun  # sudo optional

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ensure directories exist

mkd "$HOMEDIR"
mkd "$ICONDIR"
mkd "$CONF/CasjaysDev/iconmgr"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main progam

if [ -d "$APPDIR/.git" ]; then
    execute \
          "cd $APPDIR && \
           git_update" \
          "Updating $APPNAME icons"
else
    if [ -d "$BACKUPDIR/$APPNAME" ]; then
        rm_rf "$BACKUPDIR"/"$APPNAME"
    fi
    execute \
          "mv_f $APPDIR $BACKUPDIR/$APPNAME && \
           git_clone -q $REPO/$APPNAME $APPDIR" \
          "Installing $APPNAME icons"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# run post install scripts

run_postinst() {
    if [ -f "$HOMEDIR/$APPNAME/index.theme" ]; then
      devnull gtk-update-icon-cache -f -q "$HOMEDIR/$APPNAME/"
    fi
    ln_sf "$HOMEDIR/$APPNAME" "$ICONDIR/$APPNAME"
    devnull fc-cache -fv
}

     execute \
          "run_postinst" \
          "Running post install scripts"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# create version file

if [ ! -f "$CONF/CasjaysDev/iconmgr/$APPNAME" ] && [ -f "$APPDIR/version.txt" ]; then
    ln_sf "$APPDIR/version.txt" "$CONF/CasjaysDev/iconmgr/$APPNAME"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# exit
if [ ! -z "$EXIT" ]; then exit "$EXIT"; fi

# end
#/* vi: set expandtab ts=4 noai
