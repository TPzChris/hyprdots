#!/usr/bin/env sh


# read control file and initialize variables

export ScrDir=`dirname $(realpath $0)`
waybar_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
export modules_dir="$waybar_dir/modules"
export conf_file="$waybar_dir/config.jsonc"
export conf_ctl="$waybar_dir/config.ctl"

readarray -t read_ctl < $conf_ctl
num_files="${#read_ctl[@]}"
switch=0


# update control file to set next/prev mode

if [ $num_files -gt 1 ]
then
    for (( i=0 ; i<$num_files ; i++ ))
    do
        flag=`echo "${read_ctl[i]}" | cut -d '|' -f 1`
        if [ $flag -eq 1 ] && [ "$1" == "n" ] ; then
            nextIndex=$(( (i + 1) % $num_files ))
            switch=1
            break;

        elif [ $flag -eq 1 ] && [ "$1" == "p" ] ; then
            nextIndex=$(( i - 1 ))
            switch=1
            break;
        fi
    done
fi

if [ $switch -eq 1 ] ; then
    update_ctl="${read_ctl[nextIndex]}"
    export reload_flag=1
    sed -i "s/^1/0/g" $conf_ctl
    awk -F '|' -v cmp="$update_ctl" '{OFS=FS} {if($0==cmp) $1=1; print$0}' $conf_ctl > $waybar_dir/tmp && mv $waybar_dir/tmp $conf_ctl
fi

$ScrDir/wbaroverwriteconfigheader.sh