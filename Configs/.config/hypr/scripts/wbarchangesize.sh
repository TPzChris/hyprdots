#!/usr/bin/env sh

# read control file and initialize variables

export ScrDir=`dirname $(realpath $0)`
waybar_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
export modules_dir="$waybar_dir/modules"
export conf_file="$waybar_dir/config.jsonc"
export conf_ctl="$waybar_dir/config.ctl"
switch=0

current_active_size=$(cat $conf_ctl | awk -F '|' '{if($1==1) print $2}' | head -n1)

if [ "$1" == "i" ] ; then
    new_active_size=$(($current_active_size + 1));
    switch=1
elif [ "$1" == "d" ] ; then
    new_active_size=$(($current_active_size - 1));
    switch=1
fi

if [ $switch -eq 1 ] ; then
    awk -F '|' -v new_active_size="$new_active_size" '$1==1 {$2=new_active_size}1' OFS='|' $conf_ctl > $waybar_dir/tmp && mv $waybar_dir/tmp $conf_ctl
    export reload_flag=1
fi

$ScrDir/wbaroverwriteconfigheader.sh
