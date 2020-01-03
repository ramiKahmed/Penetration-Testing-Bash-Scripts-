#!/bin/bash


##  Global variables ## 

GREEN="\033[32m"
NC="\033[0m"
RED="\033[31m"
CSVFILE=$1 
OUTPUT=hostsPerLine.txt
CREDITS="$REDAuthor$NC:$GREEN'R@mi@hmed'$NC"
BOLD="\e[1m"



_banner() 

{

echo
echo -e " +--------------------------------------+"
echo -e " +  MSFHostsCSVParser                   +"
echo -e " + 		$RED Author $NC:$GREEN R@mi@hmed $NC    +"
echo -e " +--------------------------------------+"
echo

}





_main()

 {


	if [ -f $CSVFILE ] ; 
	then
		echo -e "$GREEN[+]$NC Generating a hosts per line file"
		sleep 3
		cat $CSVFILE | cut -d , -f 1 | awk '{ if (NR !=1 )  {print}}' | sed 's/"//g' > $OUTPUT
		echo -e "$GREEN[+]$NC Done !!"
	else 
		echo -e "$RED[!]$NC Invalid file format"
		echo -e "$RED[!]$NC Exiting"
		echo	
		exit 1 
	fi

}
_banner 
_main


