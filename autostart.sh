#!/usr/bin/env sh

export RESOLUTION="$(xrandr --current | grep  '*' | uniq | awk '{print $1}')"

# Functions
__kill() { kill -9 $(pidof "$1") >/dev/null 2>&1 ; }
__start() { "$@" >/dev/null 2>&1 & }

# vm
if [ -f "(command -v vmware-user-suid-wrapper 2>/dev/null)" ]; then
    __kill vmware-user-suid-wrapper
    "$(command -v vmware-user-suid-wrapper)"
fi

# Start window compositor
if [ -f "$(command -v picom 2>/dev/null)" ]; then
    __kill picom
    __start "$(command -v picom 2>/dev/null)" -b --config  "$HOME/.config/i3/compton.conf"
elif [ -f "$(command -v compton 2>/dev/null)" ]; then
    __kill compton
    __start "$(command -v compton 2>/dev/null)" -b --config  "$HOME/.config/i3/compton.conf"
fi

if [ -f "$(command -v conky 2>/dev/null)" ]; then
    __kill conky
    __start "$(command -v conky)" -c "$HOME/.config/i3/conky.conf"
fi

# Wallpaper manager
if [ -f "$(command -v nitrogen 2>/dev/null)" ]; then
    __kill nitrogen
    __start "$(command -v nitrogen)" --restore
elif [ -f "$(command -v variety 2>/dev/null)" ]; then
    __kill variety
    __start "$(command -v variety)"
fi

# Network Manager
if [ -f"$(command -v nm-applet 2>/dev/null)" ]; then
    __kill nm-applet
    __start "$(command -v nm-applet)"
fi

# Arch package updater
if [ -f "$(command -v pamac-tray 2>/dev/null)" ]; then
    __kill pamac-tray
    __start "$(command -v pamac-tray)"
fi

# bluetooth
if [ -f "$(command -v blueberry-tray 2>/dev/null)" ]; then
    __kill blueberry-tray
    __start "$(command -v blueberry-tray)"
elif [ -f "$(command -v blueman-applet 2>/dev/null)" ]; then
    __kill blueman-applet
    __start "$(command -v blueman-applet)"
fi

# num lock activated
if [ -f "$(command -v numlockx 2>/dev/null)" ]; then
    __kill numlockx
    __start "$(command -v numlockx)" on
fi

# volume
if [ -f "$(command -v volumeicon 2>/dev/null)" ]; then
    __kill volumeicon
    __start "$(command -v volumeicon)"
fi

# clipman
if [ -f "$(command -v xfce4-clipman 2>/dev/null)" ]; then
    __kill xfce4-clipman
    __start "$(command -v xfce4-clipman)"
fi

# PowerManagement
if [ -f "$(command -v xfce4-power-manager 2>/dev/null)" ]; then
    __kill xfce4-power-manager
    __start "$(command -v xfce4-power-manager)"
fi

# Session
if [ -f "$(command -v xfce4-session 2>/dev/null)" ]; then
    __kill xfce4-session
    __start "$(command -v xfce4-session)"
fi

# Authentication dialog
# ubuntu
if [ -f /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]; then
    __kill polkit-gnome-authentication-agent-1
    __start /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
# Fedora
elif [ -f /usr/libexec/polkit-gnome-authentication-agent-1 ]; then
    __kill polkit-gnome-authentication-agent-1
    __start /libexec/polkit-gnome-authentication-agent-1
# Arch
elif [ -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    __kill polkit-gnome-authentication-agent-1
    __start /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
fi

# Notification daemon
# Arch
if [ -f /usr/lib/xfce4/notifyd/xfce4-notifyd ]; then
    __kill xfce4-notifyd
    __start /usr/lib/xfce4/notifyd/xfce4-notifyd
# Debian/Fedora/Redhat
elif [ -f /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd ]; then
    __kill xfce4-notifyd
    __start /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd
fi

# Send welcome message
sleep 60 && notify-send --app-name=$DESKTOP_SESSION \
  "Welcome $USER to $DESKTOP_SESSION Desktop" &

unset __kill
## End ##
