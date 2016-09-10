# script for setting/restoring xps13 kbd backlight state
#
# Cf https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1510344
# Cf http://askubuntu.com/questions/689907/dell-xps-13-9343-keyboard-backlight-on-at-boot-ubuntu-15-10
# Copyright: Copyright (c) 2015 r2rien
# License:   GPL-2
#
## Exemple of implementation:
#
# saved as executable in:
# [/usr/local/bin/xps13-kbd-backlight]
#
# using preferences set in ${BL_CONF}
# [/etc/xps13-kbd-backlight]
# (without "#~ " prefix)
#~ ## 0 : off
#~ ## 1 : min
#~ ## 2 : max
#~ default=0
#~ current=1
#~ on_ac=2
#
# usable at login from desktop file:
# [/etc/xdg/autostart/xps13-kbd-backlight.desktop]
# (without "#~ " prefix)
#~ [Desktop Entry]
#~ Version=1.0
#~ Type=Application
#~ Terminal=false
#~ Exec=xps13-kbd-backlight
#~ X-GNOME-Autostart-enabled=true
#~ X-GNOME-Autostart-Phase=Initialization
#~ Icon=keyboard
#~ Name=xps13-kbd-backlight
#~ Comment=set/restore xps13-kbd-backlight
#~ Categories=Utility;
#
# usable at resume|thaw linking it in /etc/pm/sleep.d
# [ln -s  /usr/local/bin/xps13-kbd-backlight /etc/pm/sleep.d/20_xps13-kbd-backlight]
#
# usable at on_battery|on_ac linking it in /etc/pm/power.d
# [ln -s  /usr/local/bin/xps13-kbd-backlight /etc/pm/power.d/20_xps13-kbd-backlight]

BL_CONF=/etc/xps13-kbd-backlight
[ -f ${BL_CONF} ] || exit 0

BL_SYS=/sys/class/leds/dell::kbd_backlight/brightness

BL_SYS_CURRENT=$(cat ${BL_SYS})
BL_CONF_CURRENT=$(awk -F = '/^current/ {print $NF}' ${BL_CONF})
BL_CONF_DEFAULT=$(awk -F = '/^default/ {print $NF}' ${BL_CONF})
BL_CONF_ON_AC=$(awk -F = '/^on_ac/ {print $NF}' ${BL_CONF})

case "${1}" in
    suspend|suspend_hybrid|hibernate)
    # save in conf new current from sys
        sudo sed -i "s/current=${BL_CONF_CURRENT}/current=${BL_SYS_CURRENT}/" ${BL_CONF}
        ;;
    resume|thaw)
    # set from current in conf
        echo ${BL_CONF_CURRENT} |sudo tee ${BL_SYS}
        ;;
    true)
    # on battery power:
    # set from current in conf
        echo ${BL_CONF_CURRENT} |sudo tee ${BL_SYS}
        ;;
    false)
    # on ac power:
    # save in conf new current from sys and set from on_ac in conf
        sudo sed -i "s/current=${BL_CONF_CURRENT}/current=${BL_SYS_CURRENT}/" ${BL_CONF}
        echo ${BL_CONF_ON_AC} |sudo tee ${BL_SYS}
        ;;
    *)
    # set from default in conf
        echo ${BL_CONF_DEFAULT} |sudo tee ${BL_SYS}
        ;;
esac

