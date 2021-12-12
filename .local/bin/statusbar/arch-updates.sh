#!/bin/bash

# If more than one bar with arch-updates on wait for first to finish
me="$(basename "$0")";
running=$(ps h -C "$me" | grep -wv $$ | wc -l);
[[ $running -gt 1 ]] && sleep 2;

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(paru -Qum 2> /dev/null | wc -l); then
    updates_aur=0
fi

updates="$(checkupdates;paru -Qum)"
number="$((updates_arch + updates_aur))"

if [ "$number" -gt 0 ]; then
    text=" $number"
else
    text=""
fi

if (( "$number" > 20 ))
then
    tooltip="$(echo "$updates" | head -n 20 | sed -z 's/\n/\\n/g')"
    tooltip+='...'
else
    tooltip="$(echo "$updates" | sed -z 's/\n/\\n/g')"
    tooltip=${tooltip::-2}
fi

echo "{\"text\":\""$text"\", \"tooltip\":\""$tooltip"\"}"
exit 0
