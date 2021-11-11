#!/bin/bash

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(paru -Qum 2> /dev/null | wc -l); then
    updates_arch=0
fi

output="$(checkupdates;paru -Qum)"
number="$((updates_arch + updates_aur))"

if [ "$number" -gt 0 ]; then
    text=" $number"
else
    text=""
fi

if (( "$number" > 20 ))
then
    tooltip="$(echo "$output" | head -n 20 | sed -z 's/\n/\\n/g')"
    tooltip+='...'
else
    tooltip="$(echo "$output" | sed -z 's/\n/\\n/g')"
    tooltip=${tooltip::-2}
fi

echo "{\"text\":\""$text"\", \"tooltip\":\""$tooltip"\"}"
exit 0
