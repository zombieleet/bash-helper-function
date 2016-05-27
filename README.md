# bash-helper-function

# + log [argument]
    # + argument is any string or number you want to output
    
# + substr start end str
    # + get the position of a word in a string
    # + start is where to start searching from 
    # + end is where to stop the search
    # + str is the string to work on
    # + str can either be a string or an integer
    # + if an error occured substr_usage will be called
    # + on error return status 1
    # + usage: substr 1 2 "bash" >>>> as

# + inArray value array
    # + check if a value is in an array
    # + where value is the string or number to find in array
    # + array will be checked if value is in it
    # + on error return value is 1
    # + if match is not found the return status 2
    # + array=( csh zsh tcsh bash dash ksh )
    # + usage: inArray "bash"  "${array[@]}" >>>> "bash"

# + len value
    # + get the length of a value
    # + where value is the string, number or array to get it's length
    # + usage: len "bash" >>>> "4"
    # + lenOfArray array
    # + get the length of an array

#++++ bitwise operators +++++
 and [numOne] [numTwo]
 or [numOne] [numTwo]
 xor [numOne] [numTwo]
    # + where array is the array to get it's length
    # + usage: len "bash" >>>> "4"

# + rev_chars revChars
    # + reverse revChars
    # + where revChars is either an array, string or number
    # + usage: rev_chars "bash" >>>> "hsab"
    # + indexOf indexOfValue str
    # + find the location of indexOfValue(string) in str
    # + where indexOfValue is the string to get its location
    # + str is the string to search for indexOfValue
    # + usage: indexOf 2 "bash" >>>> "a"

# + setProxy protocol host port username password
    # + where protocol is any valid protocol in /etc/services
    # + host is any valid host
    # + port is any integer from 0 to infinity
    # + username and password is the login information of the proxy
    # + username and password is optional
    # + on error return status is 1
    # + usage: setProxy http 127.0.0.1 8080 user pass
    
# + setColor setColorType color
    # + where setColorType can either be fg for foreground or bg for background
    # + usage: setColorType fg red
    # + setColorType fg reset ... resets the color of a text back to default

# + toUpperCase toUpper
    # + where toUpper is any string to convert to uppercase
    # + on error return status is 1
    # + if value to convert to uppercase is an integer or an uppercase value, return status is 2
    # + usage: toUpperCase "bash" >> "BASH"
    
# + toLowerCase toLower
    # + where toLower is any string to convert to lowercase
    # + on error return status is 1
    # + if value to convert to lowercase is an integer or a lowercase value, return status is 2
    # + usage: toLowerCase "BASH" >> "bash"

# + split string separator
    # + split a string into an array
    # + the array returned will be newArray
    # + on error return status is 1
    # + usage:- split bash?ksh?zsh?dash ? >>> returns an array of 3 elements bash[0] ksh[1] zsh[2] dash[3]
    
# + match strToMatch regexpToMatchStrWith
  # + where strTomatch is a string to make the match on
  # + regexpToMachStrWith is the regexp to search for in strTomatch
  # + usage: - match "abcd1234" "([:alpha:])"
# + sqrt numToGetSqrt
  # + where numToGetsqrt is an integer
  # + usage: sqrt 5 >>> 2.23607
