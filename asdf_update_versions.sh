#!/bin/bash

compare_vsn() {
  first=$(echo $1 | sed 's/^0*//g')
  first=$(($first))

  second=$(echo $2 | sed 's/^0*//g')
  second=$(($second))

  if (( $first > $second ));
  then
    echo "gt"
  elif (( $first < $second ));
  then
    echo "le"
  else
    echo "eq"
  fi
}

handle_version_java_corretto() {
  current_vsn_arr=($(echo $current_vsn | sed 's/^corretto-//g' | tr '.' '\n'))
  for plugin_vsn in $plugin_vsn_all_list
  do
    if [ $(check_if_version_java_corretto $plugin_vsn) == "true" ];
    then
      plugin_vsn_arr=($(echo $plugin_vsn | sed 's/^corretto-//g' | tr '.' '\n'))
      if [ $(compare_vsn ${current_vsn_arr[0]} ${plugin_vsn_arr[0]}) == "eq" ] && [ $(compare_vsn ${current_vsn_arr[1]} ${plugin_vsn_arr[1]}) == "eq" ];
      then
        if [ $(compare_vsn ${current_vsn_arr[2]} ${plugin_vsn_arr[2]}) == "le" ];
        then
          vsn_to_update=$plugin_vsn
        elif [ $(compare_vsn ${current_vsn_arr[2]} ${plugin_vsn_arr[2]}) == "eq" ] && [ $(compare_vsn ${current_vsn_arr[3]} ${plugin_vsn_arr[3]}) == "le" ];
        then
          vsn_to_update=$plugin_vsn
        fi
      fi
    fi
  done
}

handle_version_major_minor_patch_prerel() {
  current_vsn_arr=($(echo $current_vsn | tr '.' '\n'))
  for plugin_vsn in $plugin_vsn_all_list
  do
    if [ $(check_if_version_major_minor_patch_prerel $plugin_vsn) == "true" ];
    then
      plugin_vsn_arr=($(echo $plugin_vsn | tr '.' '\n'))
      if [ $(compare_vsn ${current_vsn_arr[0]} ${plugin_vsn_arr[0]}) == "eq" ] && [ $(compare_vsn ${current_vsn_arr[1]} ${plugin_vsn_arr[1]}) == "eq" ];
      then
        if [ $(compare_vsn ${current_vsn_arr[2]} ${plugin_vsn_arr[2]}) == "le" ];
        then
          vsn_to_update=$plugin_vsn
        elif [ $(compare_vsn ${current_vsn_arr[2]} ${plugin_vsn_arr[2]}) == "eq" ] && [ $(compare_vsn ${current_vsn_arr[3]} ${plugin_vsn_arr[3]}) == "le" ];
        then
          vsn_to_update=$plugin_vsn
        fi
      fi
    fi
  done
}

handle_version_major_minor_patch() {
  current_vsn_arr=($(echo $current_vsn | tr '.' '\n'))
  for plugin_vsn in $plugin_vsn_all_list
  do
    if [ $(check_if_version_major_minor_patch $plugin_vsn) == "true" ];
    then
      plugin_vsn_arr=($(echo $plugin_vsn | tr '.' '\n'))
      if [ $(compare_vsn ${current_vsn_arr[0]} ${plugin_vsn_arr[0]}) == "eq" ] && [ $(compare_vsn ${current_vsn_arr[1]} ${plugin_vsn_arr[1]}) == "eq" ] && [ $(compare_vsn ${current_vsn_arr[2]} ${plugin_vsn_arr[2]}) == "le" ];
      then
        vsn_to_update=$plugin_vsn
      fi
    fi
  done
}

handle_version_major_minor() {
  current_vsn_arr=($(echo $current_vsn | tr '.' '\n'))
  for plugin_vsn in $plugin_vsn_all_list
  do
    if [ $(check_if_version_major_minor $plugin_vsn) == "true" ];
    then
      plugin_vsn_arr=($(echo $plugin_vsn | tr '.' '\n'))
      if [ $(compare_vsn ${current_vsn_arr[0]} ${plugin_vsn_arr[0]}) == "eq" ] && [ $(compare_vsn ${current_vsn_arr[1]} ${plugin_vsn_arr[1]}) == "le" ];
      then
        vsn_to_update=$plugin_vsn
      fi
    fi
  done
}

check_if_version_java_corretto() {
  if [[ $1 =~ ^(corretto)\-[0-9]+.[0-9]+.[0-9]+.[0-9]+$ ]]; then echo true; else echo false; fi
}

check_if_version_major_minor_patch_prerel() {
  if [[ $1 =~ ^[0-9]+.[0-9]+.[0-9]+.[0-9]+$ ]]; then echo true; else echo false; fi
}

check_if_version_major_minor_patch() {
  if [[ $1 =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then echo true; else echo false; fi
}

check_if_version_major_minor() {
  if [[ $1 =~ ^[0-9]+.[0-9]+$ ]]; then echo true; else echo false; fi
}

check_new_version() {
  current_vsn=$(echo $v | sed 's/\*//g')
#  echo "version:::$v" // do not remove
  echo "$p: vsn: $current_vsn"
  check_if_version_major_minor_patch $current_vsn
  if [ $(check_if_version_major_minor_patch $current_vsn) == "true" ];
  then
    vsn_to_update=""
    handle_version_major_minor_patch
    if [ "$vsn_to_update" != "" ];
    then
      echo "Currently installed: $current_vsn, Available: $vsn_to_update ...!!!!!!!!"
      asdf install $p $vsn_to_update
    fi
  elif [ $(check_if_version_major_minor $current_vsn) == "true" ];
  then
    vsn_to_update=""
    handle_version_major_minor
    if [ "$vsn_to_update" != "" ];
    then
      echo "Currently installed: $current_vsn, Available: $vsn_to_update ...!!!!!!!!"
      asdf install $p $vsn_to_update
    fi
  elif [ $(check_if_version_major_minor_patch_prerel $current_vsn) == "true" ];
  then
    vsn_to_update=""
    handle_version_major_minor_patch_prerel
    if [ "$vsn_to_update" != "" ];
    then
      echo "Currently installed: $current_vsn, Available: $vsn_to_update ...!!!!!!!!"
      asdf install $p $vsn_to_update
    fi
  elif [ $(check_if_version_java_corretto $current_vsn) == "true" ];
  then
    vsn_to_update=""
    handle_version_java_corretto
    if [ "$vsn_to_update" != "" ];
    then
      echo "Currently installed: $current_vsn, Available: $vsn_to_update ...!!!!!!!!"
      asdf install $p $vsn_to_update
    fi
  fi
}

declare -A plugin_versions
for p in $(asdf plugin-list)
do
  vsns=$(asdf list $p | tr "\n" " ")
  plugin_versions[$p]=$(echo "$vsns")
#  echo "${p}: vsns::: $vsns"
done

for p in ${!plugin_versions[@]}
do
  plugin_vsn_all_list=$(asdf list all $p)
#  echo $plugin_vsn_all_list
  versions=${plugin_versions[$p]}
  for v in $versions
  do
    check_new_version
  done
done

