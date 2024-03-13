#!/bin/bash

# this script demonstrates using array variables with command line parameters or arguments

# Variable declarations
declare -a interfaces
verbose=no

# function definitions
function displayhelp {
	echo "You asked for the help. Here you go."
	echo "$(basename $0) [-h] [-v] [interfacename...]"
}

# Command Line Processing
while [ $# -gt 0 ]; do

	case "$1" in
		-h )
			displayhelp
			exit
			;;
		-v )
			verbose=yes
			;;
		* )
			interfaces+=("$1")  # save the parameter in our ips array
			;;
	esac
	shift
done

# Display verbose info about command lines
[ "$verbose" = "yes" ] && echo "You gave ${#interfaces[@]} interfaces to work on"
[ "$verbose" = "yes" ] && echo "They are ${interfaces[@]}"

# test if we have any work to do
if [ ${#interfaces[@]} -eq 0 ]; then
	echo "You didn't give me any interfaces to work on"
	displayhelp
	exit 1
fi

for interface in ${interfaces[@]}; do
	[ "$verbose" = "yes" ] && echo "Working on interface $interface"
	# test if interface name is valid
	ip a s "$interface" >/dev/null
	if [ $? -ne 0 ]; then
		#instead of an ip, tell them why we couldn't give them one
		echo "No such interface '$interface'"
		continue
	fi
	# find the ip address for the interface
	ip="$(ip r|grep $interface|grep -v default|grep -v /|awk '{print $1}')"
	#put an error message where the ip would be if don't have an ip
	if [ "$ip" = "" ]; then
		ip="No address found"
	fi
	# print out the ip address with the name of the interface that address is on
	echo "$interface: $ip"
done

# Tell the user we are done
[ "$verbose" = "yes" ] && echo "Script done"
echo
