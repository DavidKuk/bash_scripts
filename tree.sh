#!/bin/bash

cat << EOF  
=================================
Simple linux tree.
Author: David Kuk
Version: 0.1.4
================================
EOF

function print_tree(){
    if [ $# -ne 2 ]
    then
        echo "ERROR: Wrong arguments count was given to $FUNCNAME"
        echo "Arguments count must be '1' but '$#' was given."
        exit 1
    fi

    local path=$1
    local dir_or_file=$2
    local old_ifs="$IFS"
    local color=''
    if [[ "${dir_or_file}" == "D" ]] && [[ -x "${path}" ]]
    then
       local symbole="D"
       color='\033[1;94m' 
    elif [[ "${dir_or_file}" == "D" ]]
    then
        color='\033[1;94m'
    elif [[ "${dir_or_file}" == "F" ]] && [[ -L "${path}" ]]
    then
        local symbole="l"
        color='\033[0;36m'
    elif [[ "${dir_or_file}" == "F" ]] && [[ -x "${path}" ]]
    then
        local symbole="F"
        color='\033[0;32m'
    elif [[ "${dir_or_file}" == "F" ]]
    then
        local symbole="F"
        color='\033[0;37m'
    fi

    IFS='/'
    for i in $path
    do
            symbole+=' '
    done
    IFS=$old_ifs
    if grep -q "*" <<< "${path}"; then
        return 0
    fi
    base_name="|__"$(basename $path)
    echo -e "${color}$symbole$base_name"

}

function tree(){
    if [ $# -ne 1 ]
    then
        echo "ERROR: Wrong arguments count was given to $FUNCNAME"
        echo "Arguments count must be '1' but '$#' was given."
        exit 1
    fi
    local path=$1
    for file in $path/*
    do
        if [ -d "${file}" ]
        then
           print_tree "$file" "D"
           tree $file
        else
           print_tree "$file" "F"
        fi
    done
    
}

function main(){
    path="./"    
    tree $path
}

main
