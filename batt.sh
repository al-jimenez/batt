#!/usr/bin/env bash

#batt() {

ltrim()  { local char=${1:-[:space:]} ; sed "s%^[${char//%/\\%}]*%%"; }      # Removes all leading whitespace.  i.e: echo " message" | ltrim
rtrim()  { local char=${1:-[:space:]} ; sed "s%[${char//%/\\%}]*$%%"; } 	   # Removes all trailing whitespace. i.e: echo "message " | rtrim
trim()   { ltrim "$1" | rtrim "$1"; }                                        # Removes all leading/trailing whitespace.  i.e: echo " message " | trim
squeeze() { local char=${1:-[[:space:]]}; sed "s%\(${char//%/\\%}\)\+%\1%g" | trim "$char"; }

  batt_install_date=$(date -j -f "%b %d %Y %H:%M:%S" "Jul 11 2020 08:00:00" +%s)        # date arithmatic
  now=$(date +%s)                                                                       # today's date
  days_installed=$(printf '%d days' "$(( (now-batt_install_date)/86400 ))")             # number of days installed since 7/11/2020
  CYCLECOUNT=`system_profiler SPPowerDataType | awk '/Cycle Count:/ { print $0 }' | cut -f 2 -d ":" | squeeze`
  CHARGE=`system_profiler SPPowerDataType | awk '/Charge Remaining/ { print $0 }' | cut -f 2 -d ":" | squeeze`
  FULLYCHARGED=`system_profiler SPPowerDataType | awk '/Fully Charged:/ { print $3 }' | squeeze`
  FULLYCHARGCAP=`system_profiler SPPowerDataType | awk '/Full Charge Capacity/ { print $5 }' | squeeze`
  CONDITION=`system_profiler SPPowerDataType | awk '/Condition/ { print $2 }' | squeeze`
  percent_life=$(printf '%.0f' "$((100*${CYCLECOUNT#0}/1500))")
  echo;
  echo " Battery Information: "
  echo "  Condition: ${CONDITION}"
  echo "  Fully Charged: ${FULLYCHARGED}"
  echo "  Charge Remaining (mAh): ${CHARGE}";
  echo "  Full Charge Capacity (mAh): ${FULLYCHARGCAP}"
  echo "  Cycle Count: ${CYCLECOUNT} (${percent_life}% of life cycle)"
  echo "  Battery replaced ${days_installed} days ago (July 11, 2020)" ;
  echo;
#}
