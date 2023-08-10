#!/bin/bash

# Prompt the user for the name of the IP address object
read -p "Enter the name of the IP address object: " ip_object_name
read -p "Enter the Address Group: " address_group

clear -x 
# Open nano to edit the IP list file
nano ip_list.txt

# Read the contents of the IP list file
ip_list=$(cat ip_list.txt)

# Store the output in a variable
output=""

output+="config firewall address"$'\n'

# Iterate through each IP address in the list
for ip in $ip_list; do
    output+="edit $ip_object_name-$ip"$'\n'
    output+="set subnet $ip/32"$'\n'
    output+="show"$'\n'
    output+="next"$'\n'
done

output+="end"

# Display the generated configuration
echo "$output" | lolcat 

filtered_names=$(echo "$output" | grep -E 'edit ' --color=always | sed 's/edit //' | tr '\n' ' ')



output2=""
output2+="config firewall addrgrp"$'\n'
output2+="edit $address_group"$'\n'
output2+="show"$'\n'
output2+="append member $filtered_names"$'\n'
output2+="show"$'\n'
output2+="end"
echo "$output2" | lolcat