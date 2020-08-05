#!/usr/bin/env bash

SCRIPTNAME="$(basename $0)"
SCRIPTDIR="$(dirname "${BASH_SOURCE[0]}")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : travis-ci.init.sh
# @Created     : Mon, Dec 31, 2019, 00:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : init script for travis-ci
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

execute \
  "sudo bash -c $(curl -LSs https://github.com/casjay-dotfiles/scripts/raw/master/install.sh) && \
   sudo pkmgr makecache && \
   sudo bash -c $(curl -LSs https://github.com/casjay-dotfiles/scripts/raw/master/install.sh) && \
   dotfiles admin scripts" \
  "Initializing system"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
