#!/bin/bash

usage() {
	echo "usage: put period as yyyymmdd-yyyymmdd (or yyyy.mm.dd , yyyy/mm/dd)";
	exit 0
}

validate() {
	[[ $1 == [0-9][0-9][0-9][0-9][/.[[:blank:]]][0-1][0-9][/.[[:blank:]]][0-3][0-9] ]] && 
	return 1 || 
	return 0;
}

date_diff() {
	end_date=$(date -d "$1 UTC" +%s)
	begin_date=$(date -d "$2 UTC" +%s)	
	[[ $begin_date > $end_date ]] && usage || echo $(((end_date-begin_date)/(60*60*24)+1))
}

days_abroad_for_last_365_days=0;

date_year_ago=$(date  +'%Y-%m-%d' -d '1 year ago')

# get periods number
arraylength=$#
[[ $arraylength == 0 ]] && usage

# put current date as yyyymmdd (or yyyy.mm.dd , yyyy/mm/dd)
for (( i=0; i<arraylength; i++ )); do
	current_dates=${1}
	shift
	readarray -d "-" -t dates_array <<< "$current_dates";
	
  	gone=$(echo "${dates_array[0]}" | tr -d . | tr -d /)
	validate "$gone" || usage
	gone=$(date -d "$gone" +'%Y-%m-%d')
	
  	arrived=$(echo "${dates_array[1]}" | tr -d . | tr -d /)
	validate "$arrived" || usage
	[[ $i == $((arraylength-1)) ]] && [[ $arrived == "now" ]] && 
	arrived=$(date  +'%Y-%m-%d') || 
	arrived=$(date -d "$arrived" +'%Y-%m-%d')
	
	days_abroad=$(date_diff "$arrived" "$gone")
    echo "Gone at: $gone";
	echo "Arrived at: $arrived";
	echo "Days abroad for the period: $days_abroad"
    echo "~~~~~~~~";
	
	if [[ $arrived < $date_year_ago ]]; then		
		days_abroad_for_last_365_days=$((days_abroad_for_last_365_days));
	elif [[ $gone < $date_year_ago ]]; then
		date_year_ago_to_arrived=$(date_diff "$arrived" "$date_year_ago")
		days_abroad_for_last_365_days=$((days_abroad_for_last_365_days + date_year_ago_to_arrived));
	else
		days_abroad_for_last_365_days=$((days_abroad_for_last_365_days + days_abroad));
	fi
done

days_in_russia_for_last_365_days=$((365 - days_abroad_for_last_365_days));
echo "Days abroad for last 365 days: $days_abroad_for_last_365_days"
echo "Days in Russia for last 365 days: $days_in_russia_for_last_365_days"
