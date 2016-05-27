#!/bin/bash
#set -nv
null=$(:)
log() {
    # + log [argument]
    # + argument is any string or number you want to output
    printf "%s\n" "$@"
}
################CUT A STRING####################
substr() {
    # + substr start end str
    # + get the position of a word in a string
    # + start is where to start searching from 
    # + end is where to stop the search
    # + str is the string to work on
    # + str can either be a string or an integer
    # + if an error occured substr_usage will be called
    # + on error return status 1
    # + usage: substr 1 2 "bash" >>>> as

    
    local start=$1 end=$2
    local str=$3
    local substrResult;
    
    substr_usage() {
	setColor fg red
	log "Usage: - substr start end str" >&2;
	setColor fg reset
    }
    
    [ "${#@}" != "3" ] && substr_usage && return 1;
    
    {
	[[ ! ${start} == +([0-9]) ]] || \
	    [[ ! ${end} == +([0-9]) ]]
	
    } && substr_usage && return 1;
    
    substrResult="${str: ${start}:${end}}"
    log "${substrResult}"
    return 0;
}
inArray() {
    # + inArray value array
    # + check if a value is in an array
    # + where value is the string or number to find in array
    # + array will be checked if value is in it
    # + on error return value is 1
    # + if match is not found the return status 2
    # + array=( csh zsh tcsh bash dash ksh )
    # + usage: inArray "bash"  "${array[@]}" >>>> "bash"

    
    local value=$1
    declare -a inArrayResult;
    inArray_usage() {
	setColor fg red
	log  "Usage: inArray value array" >&2;
	setColor fg reset
    }
    [ -z "${#@}" ] && inArray_usage && return 1;
    # shift >> don't read the first paremeter in the for valueInArray loop
    shift
    for valueInArray;do
	if [[ ${value} == "${valueInArray}" ]];then
	    inArrayResult+=( "${value}" ) 
	fi
    done
    [[ ! "${inArrayResult[@]}" ]] && log "No match Found" && return 2;
    log "${inArrayResult[@]}"
    return 0;
}
len() {
    # + len value
    # + get the length of a value
    # + where value is the string, number or array to get it's length
    # + usage: len "bash" >>>> "4"

    
    local value=$1
    len_usage() {
	setColor fg red
	log "Usage: len value" >&2;
	setColor fg reset
    }
    [[ ! "${value}" ]] && len_usage && return 1;
    declare -i i=0;
    while [ -n "${value}" ];do
	i+=1
	value=${value#*?}
    done
    log "${i}"
    return 0;
}
lenOfArray() {
    # + lenOfArray array
    # + get the length of an array
    # + where array is the array to get it's length
    # + usage: len "bash" >>>> "4"

    
    local array=$1
    lenOfArray_usage() {
	setColor fg red
	log "Usage: len value" >&2;
	setColor fg reset
    }
    [[ ! "${array}" ]] && lenOfArray_usage && return 1;
    declare -i i=0
    shift
    for count;do
	i+=1
    done
    log "${i}"
    return 0;
}

rev_chars() {
    # + rev_chars revChars
    # + reverse revChars
    # + where revChars is either an array, string or number
    # + usage: rev_chars "bash" >>>> "hsab"

    
    local revChars;
    rev_charsUsage() {
	setColor fg red
	log "Usage: rev_chars revChars" >&2;
	setColor fg reset
    }
    [ -z "${1}" ] && rev_charsUsage && return 1;
    
    for revChars
    do local word
       while (( ${#revChars} ))
       do
	   echo -n "${revChars:(-1)}"
	   revChars="${revChars:0:(-1)}"
       done
       (( ++word == ${#1} )) && \
	   log || \
	       log "${IFS:0:1}"
    done
    return 0;
}
indexOf() {
    # + indexOf indexOfValue str
    # + find the location of indexOfValue(string) in str
    # + where indexOfValue is the string to get its location
    # + str is the string to search for indexOfValue
    # + usage: indexOf 2 "bash" >>>> "a"

    
    local indexOfValue=$1
    local str=$2
    local printFirstCharacter;
    indexOf_usage() {
	setColor fg red
	log "Usage: indexOf indexOfValue str" >&2
	setColor fg reset
    }
    [ "${#@}" != "2" ] && indexOf_usage && return 1;
    [[ ! ${indexOfValue} == +([a-zA-Z]) ]] && indexOf_usage && return 1;
    declare -i i=0;
    while (( ${#str} ));do
	i+=1;
	printFirstCharacter=$( printf "%c" "$str" )
	[[ ${printFirstCharacter} == "${indexOfValue}" ]] && \
	    log "${i}" \
	    && return 0;
	str=${str#*?}
    done
    
    {
	setColor fg yellow
	log "Index of \"${indexOfValue}\" not found"
	setColor fg reset
    }
    
    return 1;
}
<<'EOF'
link() {
    [ -o expand_aliases ] || shopt -s expand_aliases
    local value=$1
    comm=$2
    link_usage() {
	setColor fg red
	log "Usage: link value alias" >&2
	setColor fg reset
    }
    [ "${#@}" != "2" ] && link_usage && return 1;
    
    alias ${value}=${comm}
    return 0;
}
EOF
###################THIS FUNCTION SET'S A PROXY
setProxy() {
    # + setProxy protocol host port username password
    # + where protocol is any valid protocol in /etc/services
    # + host is any valid host
    # + port is any integer from 0 to infinity
    # + username and password is the login information of the proxy
    # + username and password is optional
    # + on error return status is 1
    # + usage: setProxy http 127.0.0.1 8080 user pass
    

    local protocol="$1" host="$2"  port="$3"  username="$4" password="$5"
    setProxy_usage() {
	setColor fg red
	log "Usage: setProxy protocol host port username passwod" >&2;
	setColor fg reset
    }
    
    #####RUNNING CHECKS TO SEE IF ANY OF THE ARGUMENT PASSED TO SETPROXY IS NULL OR IT DOES NOT MATCH THE SPECIFIED
    #####REGULAR EXPRESSIONS
    {
	
	[ "${protocol}" == "${null}" ] || \
	    ###########################IF J VARIABLE DOES NOT EQUAL TO ANY OF THE PROTCOLS IN  /ETC/SERVICES CONTINUE THE LOOP
	    ##########################IF J VARIABLE IS EQUAL TO THE VALUE IN PROTOCOL BREAK FROM THE LOOP AND SET CHECK TO TRUE
	    #########################RUN A TEST TO SEE IF CHECK IS TRUE , IF TEST IS FALSE EXIT THE FUNCTION WITH AN ERROR
	    {
		for j in $( awk -F" " '{ print $1}' /etc/services);do
		    
		    [[ $j =~ ^[0-9A-Za-z] ]] || continue
		    [[ $j == "${protocol}" ]] && check=true && break || { check=false ;}
		
		done
		unset j
		[[ ${check} == "false" ]] && \
		    setColor fg red && \
		    log "${protocol} is not a valid protocol" >&2 && \
		    setColor fg reset && \
		    return 1;
	    } && { setProxy_usage && return 1;}
    } || \
	
	{
	    [ "${host}" == "${null}" ] || \
		############IF THE BELLOW REGULAR EXPRESSION DOES NOT MATCH THE VALUE IN HOST
		############RETURN FROM THIS FUNCTION WITH AN ERROR
		{
		    if ! (egrep "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}" >/dev/null) < <({ echo "${host}" ;})
		    then
			setColor fg red
			log "Host Addres is not Valid"
			setColor fg reset
			return 1
			
		    fi
		} || { setProxy_usage && return 1;}
		    
	} || \
	: echo ""
	    {
		[ "$port" == "${null}" ] || \
		    ############IF THE VALUE IN PORT IS NOT A DIGIT RETURN FROM THIS FUNCTION WITH AN ERROR MESSAGE
		    {
			[[ ! $port == +([0-9]) ]] && \
			    {
				setColor fg red
				log "${port} number is not valid"
				setColor fg reset
				return 1
			    }
		    } && { setProxy_usage && return 1;}

	    }
	    
	    ########IF USERNAME IS NULL OR UNSET SET THE VALUE OF NULL TO IT
	    ########IF PASSWORD IS NULL OR UNSET SET THE VALUE OF NULL TO IT
	    uname=${username:=$(${null})}
	    pass=${password:=$(${null})}
	    ########IF PASSWORD IS SET BUT USERNAME IS NULL RETURN FROM THIS FUNCTION
	    [ "${password}" != "${null}" ] && [ "${username}" == "${null}" ] && {
		setColor fg yellow
		log "Password is ${password//?/*} but no Username was specified"
		setColor fg reset
		return 1;
	    }
	    
	    export "${protocol}_proxy=${protocol}://${host}:${port}/"
	    return 0;

}
###########
setColor() {
    # + setColor setColorType color
    # + where setColorType can either be fg for foreground or bg for background
    # + usage: setColorType fg red
    # + setColorType fg reset ... resets the color of a text back to default

    
    local setColorType="$1" color="$2"
    if [ "${#@}" != "2" ];then
	setColor fg red
	log "Insufficient Number of argument"
	setColor fg reset
	return 1
    fi
    if [ "${setColorType}" = "bg" ];then
	case $color in
	    "red")
		#red
		tput setab 1
		;;
	    "green")
		#green
		tput setab 2
		;;
	    "yellow")
		#yellow
		tput setab 3
		;;
	    "blue")
		tput setab 4
		;;
	    "magneta")
		tput setab 5
		;;
	    "cyan")
		tput setab 6
		;;
	    "white")
		tput setab 7
		;;
	    "black")
		
		tput setab 0
		;;
	    "reset")
		tput setab 9
		;;
	    
	    *)
		setColor fg red
		log "Invalid Color Code"
		setColor fg reset
		return 1;
		;;
	esac
	
    elif [ "${setColorType}" = "fg" ];then
	case $color in
	    "red")
		#red
		tput setaf 1
		;;
	    "green")
		#green
		tput setaf 2
		;;
	    "yellow")
		#yellow
		tput setaf 3
		;;
	    "blue")
		tput setaf 4
		;;
	    "magneta")
		tput setaf 5
		;;
	    "cyan")
		tput setab 6
		;;
	    "white")
		tput setaf 7
		;;
	    "black")
		
		tput setaf 0
		;;
	    "reset")
		tput setaf 9
		;;
	    
	    *)
		setColor fg red
		log "Invalid Color Code"
		setColor fg reset
		return 1;
		;;
	esac
    else
	return 1;
    fi
    
    return 0;
}
 
toUpperCase() {
    # + toUpperCase toUpper
    # + where toUpper is any string to convert to uppercase
    # + on error return status is 1
    # + if value to convert to uppercase is an integer or an uppercase value, return status is 2
    # + usage: toUpperCase "bash" >> "BASH"

    
    local toUpper="${1}"
    toUpperUsage() {
	setColor fg red
	log "Usage: toUpperCase toUpper" >&2
	setColor fg reset
    }
    if (( "${#toUpper}" < "1" ));then
	toUpperUsage;
	return 1;
    fi
    [[ ${toUpper} == +([0-9]) ]] && \
	{
	    setColor fg red;
	    log "expected a string but got an integer"
	    setColor fg reset
	    return 2
	}
    [[ ${toUpper^^} == "${toUpper}" ]] && \
	{
	    setColor fg red
	    log "Error:- cannot convert an uppercase letter to uppercase"
	    setColor fg reset
	    return 2
	}
    
    log "${toUpper^^}"
    return 0
}
 
toLowerCase() {
    # + toLowerCase toLower
    # + where toLower is any string to convert to lowercase
    # + on error return status is 1
    # + if value to convert to lowercase is an integer or a lowercase value, return status is 2
    # + usage: toLowerCase "BASH" >> "bash"

    
    local toLower="${1}"
    toLowerUsage() {
	setColor fg red
	log "Usage: toLowerCase toLower" >&2
	setColor fg reset
    }
    if (( "${#toLower}" < "1" ));then
	toLowerUsage
	return 1;
    fi
    [[ ${toLower} == +([0-9]) ]] && \
	{
	    setColor fg red;
	    log "expected a string but got an integer"
	    setColor fg reset
	    return 2
	}
    [[ ${toLower,,} == "${toLower}" ]] && \
	{
	    setColor fg red
	    log "Error:- cannot convert a lowercase letter to lowercase"
	    setColor fg reset
	    return 2
	}
    log "${toLower,,}"
    return 0
}
split() {
    # + split string separator
    # + split a string into an array
    # + the array returned will be newArray
    # + on error return status is 1
    # + usage:- split bash?ksh?zsh?dash ? >>> returns an array of 3 elements bash[0] ksh[1] zsh[2] dash[3]
    local string="${1}" separator="${2}"
    declare cutOneCharacter;
    declare tempvar
    # appending $sepeartor to the ending of $string
    # bacon?tuna?hamburger ? >>>>> if not appeneded the result will be>>>>>> bacon tuna //o_O where is hamburger ?
    # if appeneded the result will be >>>> bacon tuna harmburger 
    string="$string$separator"
    [[ ${newArray[@]} ]] && unset newArray
    splitUsage() {
	setColor fg red
	log "Usage: split string separator" >&2
	setColor fg reset
    }
    
    (( "${#@}" != "2" )) && splitUsage && return 1;
    while [ -n "${string}" ];do
    	cutOneCharacter=$( printf "%c" "$string" )
    	if [[ "${cutOneCharacter}" == "${separator}" ]];then
    		newArray+=( "${tempvar}" )
    		unset tempvar;
    	else
    		tempvar+="${cutOneCharacter}"
    	fi
    	string=${string#*?}
    done
    log "${newArray[@]}"
   return 0;
}

strict() {
    set -o nounset
    sourceScript=$0
    checkVariable=$(<"${sourceScript}")
    OLDIFS=$IFS
    IFS=
    declare -i i=0
    while read srcScript; do
	: $((i++))
	i="${i}"
	if [[ $srcScript =~ (\$) ]];then
	    if [[ ! $srcScript =~ (\".*\$) ]];then
		setColor fg red
		log "+ quote the variable in this line ${i} to prevent globbing"
		setColor fg reset
	    fi
	fi
        if [[ ! $srcScript =~ (.if \[\[|if \[\[) ]];then
	    #	    echo "$i ---"
	    if [[ $srcScript =~ (.*| )if( )(test|\[).*(\>|\<).*(\]|) ]];then
		echo "$i"
	    fi
	fi
	
	
    done < <( echo "$checkVariable" )
    
    IFS="${OLDIFS}"
    return 0;
}
<<'EOF'
include() {
    local includeFile=$1
    includeUsage() {
	setColor fg red
	log "Usage:- include file-to-include" >&2
	setColor fg reset
    }
    if [ -z "${includeFile}" ];then
	includeUsage;
	exit 1;
    elif [ ! -e "${includeFile}" ];then
	includeUsage;
	exit 1;
    fi

    source "${includeFile}"
    return 0;
}
EOF
match() {
    local strToMatch=$1 regexpToMatchWithStr=$2
    matchUsage() {
	setColor fg red
	log "usage: match strToMatch regexpToMatchWithStr" >&2
	setColor fg reset
    }
    if [ -z "${strToMatch}" ] || [ -z "${regexpToMatchWithStr}" ];then
	matchUsage;
	return 1;
    fi
    
    if [[ $strToMatch =~ $regexpToMatchWithStr ]];then
	log "${strToMatch}"
	return 0;
    else
	return 1;
    fi

}
sqrt() {
    
    local numToGetSqrt=$1
    local finalConversion;
    sqrtUsage() {
	setColor fg red
	log "usage:- sqrt numToGetSqrt"
    }
    if [[ $numToGetSqrt == +([0-9]) ]];then
	awk -v numToGetSqrt="$numToGetSqrt" ' BEGIN { print sqrt(numToGetSqrt) }';
	return 0;
    else
	sqrtUsage;
	return 1;
    fi
    return 0;
}
decimaltobinary() {
    local decimal=$1
    local finalConversion;
    local binary;
    decimaltobinaryUsage() {
	setColor fg red
	log "usage:- decimaltobinary decimal"
	setColor fg reset
    }
    
    if [[ ! ${decimal} == +([0-9]) ]];then
	decimaltobinaryUsage
	return 1;
    fi
  
    if [ "$decimal" -ge "128" ];then
	binary=$(( decimal - 128))
	finalConversion+=1
    elif [ "$decimal" -lt "128" ];then 
	binary=$(( decimal - 0 ))
	finalConversion+=0
    fi
    
    if [ "$binary" -ge "64" ];then
	binary=$(( binary - 64 ))
	finalConversion+=1
    elif [ "$binary" -lt "64" ];then
	binary=$(( binary - 0 ))
	finalConversion+=0
    fi
    
    if [ "$binary" -ge "32" ];then
	binary=$(( binary - 32 ))
	finalConversion+=1
    elif [ "$binary" -lt "32" ];then
	binary=$(( binary - 0 ))
	finalConversion+=0
    fi
    
    if [ "$binary" -ge "16" ];then
	binary=$(( binary - 16 ))
	finalConversion+=1
    elif [ "$binary" -lt "16" ];then
	binary=$(( binary - 0 ))
	finalConversion+=0
    fi
    
    if [ "$binary" -ge "8" ];then
	binary=$(( binary - 8 ))
	finalConversion+=1
    elif [ "$binary" -lt "8" ];then
	binary=$(( binary - 0 ))
	finalConversion+=0
    fi
    
    if [ "$binary" -ge "4" ];then
	binary=$(( binary - 4 ))
	finalConversion+=1
    elif [ "$binary" -lt "4" ];then
	binary=$(( binary - 0 ))
	finalConversion+=0
    fi
    
    if [ "$binary" -ge "2" ];then
	binary=$(( binary - 2 ))
	finalConversion+=1
    elif [ "$binary" -lt "2" ];then
	binary=$(( binary - 0 ))
	finalConversion+=0
    fi
    
    if [ "$binary" -ge "1" ];then
	binary=$(( binary - 1 ))
	finalConversion+=1
    elif [ "$binary" -lt "1" ];then
	binary=$(( binary - 0 ))
	finalConversion+=0
    fi
   
    <<EOF
 # stripping out leading 0
    # for example the result of finalConversion for 23 is 0001011
    # the first three 0's are not needed
    while [ -n "${finalConversion}" ];do
	if [[ "$(printf "%c" "$finalConversion" )" == "0" ]];then
	    finalConversion="${finalConversion#*?}"
	else
	    break
	fi
	
    done
EOF
    log "$finalConversion"
    return 0;
}

reverse() {
    declare -a array;
    declare -a reversedArray;
    reverseUsage() {
	setColor fg red
	log "usage:- reverse array" >&2
	setColor fg reset
    }
    [[ ! "$@" ]] && reverseUsage && return 1;
    for arry;do
	array+=( "${arry}" )
    done
    local i;
    for (( i=${#array[@]} ; i >= 0 ; i-- )) {
	    #log "${array[$i]}"
	    reversedArray+=( "${array[$i]}" )
	}
	log "${reversedArray[@]}"
	unset arry
	return 0;
}


<<EOF
sort() {
    declare -a array=$1
    local i;
    sortUsage() {
	setColor fg red
	log "usage:- sort array" >&2
	setColor fg reset
    }
    
    [ -z "$@" ] && sortUsage && return 1;
    [ "${#array[@]}" = "1" ] && sortUsage && return 1;
    
    for (( i=0; i < ${#array[@]} ; i++ ));do
	
	if [[ ${array[$i]} < ${array[$i+1]} ]];then
	    echo "${array[$i]}"
	elif [[ ${array[$i]} > ${array[$i+1]} ]];then
	    echo "${array[$i]}"
	fi
	
	
    done
#    echo "${newArray[@]}"
}
EOF


and() {
    local numOne=$1 numTwo=$2
    declare binaryBitwiseAnd;
    andUsage() {
	setColor fg red
	log "usage:- and numOne numTwo" >&2
	setColor fg reset
    }
    if [[ ! ${numOne} == +([0-9]) ]] || [[ ! ${numTwo} == +([0-9]) ]];then
	andUsage
	return 1;
    fi
    
    numOne=$( decimaltobinary "${numOne}" ) numTwo=$( decimaltobinary "${numTwo}" )
    
    while [ -n "${numOne}" ] && [ -n "${numTwo}" ];do
	if [ "$( printf "%c" "${numOne}" )" = "1" ] && [ "$( printf "%c" "${numTwo}" )" = "1" ];then
	    binaryBitwiseAnd+=1
	else
	    binaryBitwiseAnd+=0
	fi
	
	numOne=${numOne#*?} numTwo=${numTwo#*?}
    done

    echo  "$((2#$binaryBitwiseAnd))"
    return 0;
}

or() {
    local numOne=$1 numTwo=$2
    declare binaryBitwiseOr;
    orUsage() {
	setColor fg red
	log "usage:- or numOne numTwo" >&2
	setColor fg reset
    }
    if [[ ! ${numOne} == +([0-9]) ]] || [[ ! ${numTwo} == +([0-9]) ]];then
	orUsage
	return 1;
    fi
    
    numOne=$( decimaltobinary "${numOne}" ) numTwo=$( decimaltobinary "${numTwo}" )
    
    while [ -n "${numOne}" ] && [ -n "${numTwo}" ];do
	if [ "$( printf "%c" "${numOne}" )" = "1" ] && [ "$( printf "%c" "${numTwo}" )" = "1" ];then
	    binaryBitwiseOr+=1
	elif [ "$( printf "%c" "${numOne}" )" = "0" ] && [ "$( printf "%c" "${numTwo}" )" = "1" ];then
	    binaryBitwiseOr+=1
	elif [ "$( printf "%c" "${numOne}" )" = "1" ] && [ "$( printf "%c" "${numTwo}" )" = "0" ];then
	    binaryBitwiseOr+=1
	else
	    binaryBitwiseOr+=0
	fi
	
	numOne=${numOne#*?} numTwo=${numTwo#*?}
    done
    
    echo  "$((2#$binaryBitwiseOr))"
    
    return 0;

}

xor() {
    local numOne=$1 numTwo=$2
    declare binaryBitwiseXor
    xorUsage() {
	setColor fg red
	log "usage:- xor numOne numTwo" >&2
	setColor fg reset
    }
    
    if [[ ! ${numOne} == +([0-9]) ]] || [[ ! ${numTwo} == +([0-9]) ]];then
	xorUsage
	return 1;
    fi
    
    numOne=$( decimaltobinary "${numOne}" ) numTwo=$( decimaltobinary "${numTwo}" )
    
     while [ -n "${numOne}" ] && [ -n "${numTwo}" ];do
	if [ "$( printf "%c" "${numOne}" )" = "1" ] && [ "$( printf "%c" "${numTwo}" )" = "0" ];then
	    binaryBitwiseXor+=1
	elif [ "$( printf "%c" "${numOne}" )" = "0" ] && [ "$( printf "%c" "${numTwo}" )" = "1" ];then
	    binaryBitwiseXor+=1
	else
	    binaryBitwiseXor+=0
	fi
	numOne=${numOne#*?} numTwo=${numTwo#*?}
     done
     echo  "$((2#$binaryBitwiseXor))"
     return 0;
     
}
