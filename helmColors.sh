#!/bin/bash
KUBECONFIG=$1
C_S=$(( COLUMNS - 60 ))
COL_WIDTH=$(( COLUMNS/7 ))
COL_WIDTH=$(( COL_WIDTH - 1 ))
LIST=`helm list --kubeconfig $KUBECONFIG --col-width $COL_WIDTH`
FULL_LIST=`helm list --kubeconfig $KUBECONFIG`
SAVEIFS=$IFS   # Save current IFS
IFS=$'\n'      # Change IFS to new line
list=($LIST) # split to array $names
full_list=($FULL_LIST) #paralell list for full date
IFS=$SAVEIFS   # Restore IFS

echo -e "\e[34m${list[0]}\e[0m"
for (( i=1; i<${#list[@]}; i++ ))
do
    if [[ ${list[$i]} =~ FAILED ]]; then
       echo -e "\e[31m${list[$i]}\e[0m"
    else
       CURR_DATE=$(date '+%s')
       CURR_DATE=$((CURR_DATE-60))
       SAVEIFS=$IFS   # Save current IFS
       IFS=$'\t'      # Change IFS to new line
       read -ra ARR <<< "${full_list[$i]}"
       IFS=$SAVEIFS   # Restore IFS
       HELM_DATE_STRING=${ARR[2]}
       HELM_DATE=$(date -d "${HELM_DATE_STRING}" '+%s')
       if (( $CURR_DATE < $HELM_DATE)); then
         echo -e "\e[32m${list[$i]}\e[0m"
       else
         echo "${list[$i]}"
       fi
    fi
done
