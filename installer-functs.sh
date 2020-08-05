####APPS
devnull() { "$@" > /dev/null 2>&1 ;  }
rm_rf() { devnull rm -Rf "$@" ; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@" ; fi ; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@" ; fi ; }
ln_rm() { devnull find "$2" -xtype l -delete ; }
ln_sf() { devnull ln -sf "$@" ; ln_rm ; }
mkd() { devnull mkdir -p "$@" ; }
git_clone() { rm_rf "$2" ; devnull git clone -q "$@" ; }
git_update() { devnull git pull -f ; }
printf_color() { printf "%b" "$(tput setaf "$2" 2> /dev/null)" "$1" "$(tput sgr0 2> /dev/null)" ; }
printf_green() { printf_color "$1" 2 ; }
printf_red() { printf_color "$1" 1 ; }
printf_purple() { printf_color "$1" 5 ; }
printf_yellow() { printf_color "$1" 3 ;}
printf_success() { printf_green "\t\t[✔] $1\n" ; }
printf_error() { printf_red "\t\t[✖] $1 $2\n" ; }
printf_warning() { printf_yellow "\n\n\n\t\t[❗] $1\n" ;}
sudorun() { if (sudo -vn && sudo -ln) 2>&1 | devnull grep -v 'may not' ; then sudo -HE "$@" ; else eval "$@" ; fi ;}
sudoreq() { if [[ $UID != 0 ]]; then echo "" && printf_error "Please run this script with sudo\n\n" ; getexitcode ; fi ; }
returnexitcode() { local RETVAL="$EXIT"; if [ "$RETVAL" -eq 0  ]; then BG_EXIT="${BG_GREEN}" ;  else BG_EXIT="${BG_RED}" ; fi ; }
getexitcode() { local RETVAL="$?" ; local ERROR="$APPNAME has failed to install" ; local SUCCES="$1" ; EXIT="$RETVAL" ; \
if [ "$RETVAL" -eq 0  ]; then printf_success "$SUCCES" ; else printf_error "$ERROR" ; exit "$EXIT" ; fi ;}

###SYS
devnull() { "$@" > /dev/null 2>&1 ;  }
rm_rf() { devnull rm -Rf "$@" ; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@" ; fi ; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@" ; fi ; }
ln_rm() { devnull find "$HOME" -xtype l -delete ; }
ln_sf() { devnull ln -sf "$@" ; ln_rm ; }
mkd() { devnull mkdir -p "$@" ; }
git_clone() { rm_rf "$2" ; devnull git clone -q "$@" ; }
git_update() { devnull git pull -f ; }
printf_color() { printf "%b" "$(tput setaf "$2" 2> /dev/null)" "$1" "$(tput sgr0 2> /dev/null)" ; }
printf_green() { printf_color "$1" 2 ; }
printf_red() { printf_color "$1" 1 ; }
printf_purple() { printf_color "$1" 5 ; }
printf_yellow() { printf_color "$1" 3 ;}
printf_success() { printf_green "\t\t *** $1 *** \n" ; }
printf_error() { printf_red "\t\t *** $1 $2 *** \n" ; }
printf_warning() { printf_yellow "\n\n\n\t\t ### $1 ### \n" ;}
sudorun() { if (sudo -vn && sudo -ln) 2>&1 | devnull grep -v 'may not' ; then sudo -HE "$@" ; else eval "$@" ; fi ;}
sudoreq() { if [[ $UID != 0 ]]; then echo "" && printf_error "Please run this script with sudo\n\n" ; getexitcode ; fi ; }
getexitcode() { local RETVAL="$?" ; local ERROR="$APPNAME has failed to install" ; local SUCCES="$1" ; EXIT="$RETVAL" ; \
if [ "$RETVAL" -eq 0  ]; then printf_success "$SUCCES" ; else printf_error "$ERROR" ; exit "$EXIT" ; fi ;}
