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
# @Description : installer script for DFAPPNAME
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

#printf_red "\t\t$SCRIPTNAME\n"
#printf_red "\t\t$SCRIPTDIR\n"

execute \
    "sudo bash -c $(curl -LSs https://github.com/casjay-dotfiles/scripts/raw/master/install.sh) && \ 
     sudo bash -c $(curl -LSs https://github.com/casjay-dotfiles/scripts/raw/master/install.sh)" \
    "Executing installer"
    
execute \
    "sudo pkmgr makecache && sudo pkmgr update" \
    "updating packages"
    
printf_green "\t\tcontinuing with the debugging\n"

bash -cx "./install.sh"
