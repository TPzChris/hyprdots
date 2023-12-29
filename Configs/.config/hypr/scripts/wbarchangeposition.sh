#!/usr/bin/env sh

# read control file and initialize variables

export ScrDir=`dirname $(realpath $0)`
waybar_dir="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
export modules_dir="$waybar_dir/modules"
export conf_file="$waybar_dir/config.jsonc"
export conf_ctl="$waybar_dir/config.ctl"

POSITION_TOP="top";
POSITION_BOTTOM="bottom";
#POSITION_LEFT="left";
#POSITION_RIGHT="right";

positions=($POSITION_TOP $POSITION_BOTTOM);

num_elements=${#positions[@]};

current_position=$(cat $conf_ctl | awk -F '|' '{print $3}' | head -n1)

for (( i=0 ; i<$num_elements ; i++ )) do
    if [ "$current_position" = ${positions[i]} ]; then
        next_position_index=$(( (i + 1) % $num_elements ))
        if [ $next_position_index -gt $num_elements ]; then
            $next_position_index = 1
        fi
        
        awk -F '|' -v current_position="$current_position" -v next_position="${positions[next_position_index]}" '{ sub(current_position, next_position, $3) }1' OFS='|' $conf_ctl > $waybar_dir/tmp && mv $waybar_dir/tmp $conf_ctl
        export reload_flag=1
    fi
done

$ScrDir/wbaroverwriteconfigheader.sh
