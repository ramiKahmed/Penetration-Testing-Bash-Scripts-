#!/bin/bash 



### Global variables ### 

arg=$#
API=$1
QUERY=$2
WORKSPACE=$3
PATHTOFILE=/tmp/resource.rc 
CHECK=$(service postgresql status | grep active | cut -d ":" -f 2)
GREEN="\033[32m"
NC="\033[0m"
RED="\033[31m"
YELLOW="\033[33m"



_banner() 

{

echo
echo -e " +--------------------------------------+"
echo -e " +  MSFShodanQuery                      +"
echo -e " + 		$RED Author $NC:$GREEN R@mi@hmed $NC    +"
echo -e " +--------------------------------------+"
echo

}



_CreateResourceFile()

{
	
	echo "

	workspace -a $WORKSPACE
	workspace $WORKSPACE
	use auxiliary/gather/shodan_search 
	set verbose true 
	set database true 
	set shodan_apikey  $API
	set query $QUERY
	run 
	

	" > $PATHTOFILE
}



_CheckPostgresql()

{
	## Enabling regex 
	
	shopt -s extglob

	if [[ ${CHECK} =~ (in)active    ]]  ; 
	then 
		echo -e "$RED[!]$NC service postgresql down  "
		echo -e "$YELLOW[+]$NC starting postgresql "
		service postgresql start 
		if [[ `service postgresql status | grep active | cut -d " " -f 6 | sed 's/(//g' | sed 's/)//g'` =~ exited ]] ;
		then
			echo -e "$GREEN[+]$NC started successfully "
		else
			
			echo -e "$RED[!]$NC couldn't start postgresql , quiting !!"
			exit 1
		fi
		
	fi


}




_StartMetasploit()

{


	msfconsole -x " resource $PATHTOFILE "
}

_banner
#_Input
_CreateResourceFile 
echo -e "$GREEN[+]$NC configurations created successfully ==> /tmp/resource.rc"
_CheckPostgresql
_StartMetasploit






