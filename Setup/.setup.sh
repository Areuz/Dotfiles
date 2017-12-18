USER="areuz";
CONF="/.config";
BAK="$CONF/Backup/Bak_$(date +"%d.%m.%y_%H.%M.%S")";

OLDIFS="$IFS";
IFS=$(echo -en "\n\b");

function ln_replace() {
  if [ -a "$1" ] || [ -d "$1" ] || [ -h "$1" ]; then 
    mkdir -p "$BAK";
    mv "$1" "$BAK/"; rm -f "$1";
  elif [ ! -d "$(dirname "$1")" ]; then mkdir -p "$(dirname "$1")";
  fi;

  if [ -a "$2" ] || [ -d "$2" ] || [ -h "$2" ]; then
    ln -s "$2" "$1";
  else
    echo -e "File '$2' doesn't exist, or isn't valid\n";
  fi;
}

#Install dependencies
if [ "$1" == "deps" ]; then
  sudo -u "$USER" yaourt -S "$CONF/Setup/.dependencies.pac" --noconfirm;
fi;
if [ "$1" == "full" ]; then
  for PAC in $(find "$CONF" -name ".*.pac"); do
    sudo -u "$USER" yaourt -S "$PAC" ;#--noconfirm;
  done;
fi

#Choose VARIANT
SEL="NULL";
while [ ! -d "$CONF/.VARIANT/$SEL" ]; do
  tput reset;

  echo -e "Choose environment variant:";
  for V in $CONF/.VARIANT/*; do
    echo -e "  $(basename $V)";
  done;
  echo -en "\n>";

  read SEL;
done;

echo -n "" > "$CONF/.git/info/exclude";
echo -e "#Autogenerated personal excludes:\n" >> "$CONF/.git/info/exclude";

for File in $(find "$CONF/.VARIANT/$SEL" -type f -o -type l); do
  ln_replace "$CONF/$(echo "$File" | cut -d '/' -f 5-)" "$File";
  echo "/$(echo "$File" | cut -d '/' -f 5-)" >> "$CONF/.git/info/exclude";
done;

#System Essentials
ln_replace "/home/$USER/.xinitrc" "$CONF/System/.xinitrc";
ln_replace "/home/$USER/.config/i3/config" "$CONF/System/i3/config";
ln_replace "/home/$USER/.bash_profile" "$CONF/System/.bash_profile";
ln_replace "/home/$USER/.bashrc" "$CONF/System/.bashrc";
ln_replace "/home/$USER/.fonts" "$CONF/System/fonts/";
ln_replace "/etc/environment" "$CONF/System/environment";
ln_replace "/etc/systemd/logind.conf" "$CONF/System/logind.conf";
ln_replace "/etc/modprobe.d/alsa-base.conf" "$CONF/System/alsa-base.conf";
ln_replace "/etc/vconsole.conf" "$CONF/System/vconsole.conf";
ln_replace "/etc/udev/rules.d" "$CONF/System/rules.d";
ln_replace "/home/$USER/.config/env_config" "$CONF/System/env_config";


#Xorg
ln_replace "/home/$USER/.Xdefaults" "$CONF/System/.Xdefaults";
ln_replace "/home/$USER/.Xresources" "$CONF/System/.Xresources";
ln_replace "/etc/X11/xorg.conf.d/20-nvidia.conf" "$CONF/System/Xorg/20-nvidia.conf";
ln_replace "/etc/X11/xorg.conf.d/20-intel.conf" "$CONF/System/Xorg/20-intel.conf";
ln_replace "/etc/X11/xorg.conf.d/30-touchpad.conf" "$CONF/System/Xorg/30-touchpad.conf";

#Themes
ln_replace "/home/$USER/.config/Trolltech.conf" "$CONF/Trolltech.conf";
ln_replace "/usr/share/icons/Flat_Remix" "$CONF/Themes/Flat-Remix/Flat Remix";

#Tor
ln_replace "/etc/tor/torrc" "$CONF/System/torrc";

#SSH
ln_replace "/etc/ssh" "$CONF/System/ssh";
ln_replace "/home/$USER/.ssh/known_hosts" "$CONF/System/ssh/known_hosts";

#Services
ln_replace "/etc/systemd/system/net-resume.service" "$CONF/System/service/net-resume.service";

ln_replace "/etc/systemd/system/tor.service" "$CONF/System/service/tor.service";
#ln_replace "/etc/systemd/system/multi-user.target.wants/tor.service" "$CONF/System/tor/tor.service";
ln_replace "/usr/lib/systemd/system/tor.service" "$CONF/System/service/tor.service";

ln_replace "/etc/systemd/system/sockets.target.wants/sshd.socket" "$CONF/System/ssh/sshd.socket";
ln_replace "/usr/lib/systemd/system/sshd.socket" "$CONF/System/ssh/sshd.socket";

ln_replace "/etc/systemd/system/lock-on_resume.service" "$CONF/System/service/lock-on_resume.service";

#LAMP
ln_replace "/etc/httpd" "$CONF/LAMP/httpd";
ln_replace "/srv/http" "$CONF/LAMP/http";
ln_replace "/etc/php" "$CONF/LAMP/php";
ln_replace "/etc/webapps/phpmyadmin" "$CONF/LAMP/phpmyadmin";

#Vim
ln_replace "/etc/vimrc" "$CONF/vim/vimrc";
ln_replace "/home/$USER/.vim/colors" "$CONF/vim/colors";
ln_replace "/root/.vim/colors" "$CONF/vim/colors";

#Tools
ln_replace "/usr/bin/chromium_" "$CONF/Apps/Chromium_Select/chromium_select.sh";
ln_replace "/home/$USER/.config/ranger" "$CONF/ranger/";
ln_replace "/usr/bin/win_kvm" "$CONF/Apps/windows_kvm.sh";
ln_replace "/usr/bin/pidlock" "$CONF/scripts/pidlock.sh";

#Other
ln_replace "/home/$USER/.ncmpcpp" "$CONF/MPD/ncmpcpp/config";
ln_replace "/home/$USER/eagle" "$CONF/eagle";
ln_replace "/home/$USER/.local/share/rofi/themes/default.rasi" "$CONF/rofi/default.rasi";

cd "$CONF";

git submodule init;
git submodule update;

chmod 755 -R "$CONF/";
chown areuz:areuz -R "$CONF/";

cat "$CONF/Setup/.extra.txt";

IFS="$OLDIFS";
