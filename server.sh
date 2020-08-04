#!/bin/bash

BOLD='\e[1m'
DIM='\e\[2m'
UNDER='\e[4m'
BLINK='\e[5m'
REVERSE='\e[7m'
HIDDEN='\e[8m'

RESET='\e[0m'

FDEF='\e[39m'
FBLACK='\e[30m'
FRED='\e[31m'
FGREEN='\e[32m'
FYELLOW='\e[33m'
FBLUE='\e[34m'
FMAGENTA='\e[35m'
FCYAN='\e[36m'
FLGRAY='\e[37m'
FDGRAY='\e[90m'
FLRED='\e[91m'
FLGREEN='\e[92m'
FLYELLOW='\e[93m'
FLBLUE='\e[94m'
FLMAGENTA='\e[95m'
FLCYAN='\e[96m'
FWHITE='\e[97m'

BDEF='\e[49m'
BBLACK='\e[40m'
BRED='\e[41m'
BGREEN='\e[42m'
BYELLOW='\e[43m'
BBLUE='\e[44m'
BMAGENTA='\e[45m'
BCYAN='\e[46m'
BLGRAY='\e[47m'
BDGRAY='\e[100m'
BLRED='\e[101m'
BLGREEN='\e[102m'
BLYELLOW='\e[103m'
BLBLUE='\e[104m'
BLMAGENTA='\e[105m'
BLCYAN='\e[106m'
BWHITE='\e[107m'

FAULT=$BRED$FGREEN
SUCCESS=$BGREEN$FRED
MENU=$BYELLOW$FBLACK

add_server () {
	set name
	set host_name
	set user
	set port
	set ssh_dir
	set ssh_file

	echo "Server name ?"
	read name
	echo "host name ? address"
	read host_name
	echo "user name ?"
	read user
	echo "port ssh server"
	read port

	echo -e "$BLINK$BRED$FGREEN GENERATION KEYS PLEASE WAIT....$RESET"

	ssh-keygen -t rsa -b 4096 -C $host_name -f ~/.ssh/$name
	if [ $? -gt 0 ]
	then 
		echo -e "$FAULT KEYGEN FAILED !"
		echo -e "PLEASE RUN SSH CONFIG CHECK!"
		echo -e "OR CONTACT YOUR ADMINISTRATOR ;)$RESET"
		return 1
	fi

	echo "" >> ~/.ssh/config
	echo "Host					$name" >> ~/.ssh/config
	echo "	HostName			$host_name" >> ~/.ssh/config
	echo "	User				$user" >> ~/.ssh/config
	echo "	Port				$port" >> ~/.ssh/config
	echo "	IdentityFile			~/.ssh/$name" >> ~/.ssh/config

	echo "Add key into server :"
	ssh-copy-id -i ~/.ssh/$name.pub -p $port $user@$host_name
	if [ $? -gt 0 ]
	then 
		echo -e "$FAULT COPY KEY FAILED !"
		echo -e "CHECK SERVER INFORMATIONS"
		echo -e "AND YOUR CONNECTION.$RESET"
		return 1
	fi

	echo "try ssh $name"
	echo "try sshfs $name:[dir] [local dir]"
	echo "try scp [-r] $name:[dir] [local dir]"
	echo "try scp [-r] [local dir] $name:[dir]"

	unset name
	unset host_name
	unset user
	unset port
	unset ssh_dir
	unset ssh_file
}

display_cofig_files () {
	echo "list files in ~/.ssh/"
	ls ~/.ssh
}

display_config_ssh () {
	cat ~/.ssh/config
}

menu () {
	echo -e "$MENU Server script installation $RESET"
	echo " 1 : Add ssh keys, to connect without password."
	echo " 2 : Display ssh config file."
	echo " 3 : Check ssh configuration."
	echo " 9 : VIM This file."
	echo ""
	echo -e "$MENU 0 : QUIT$RESET"
}

check_ssh_config (){
	fault=0
	ls_result=$(ls -ld ~/.ssh);
	echo $ls_result
	right=$(echo $ls_result | cut -d ' ' -f 1)
	USR=$(echo $ls_result | cut -d ' ' -f 3)
	GRP=$(echo $ls_result | cut -d ' ' -f 4)

	if [ $right == "drwx------" ]
	then
		echo -e "$SUCCESS Rights of .ssh directory is ok$RESET"
	else
		echo -e "$FAULT Rights of .ssh directory is not OK$RESET"
		fault=1
	fi
	if [ $USR == $(whoami) ]
	then
		echo -e "$SUCCESS User owner of .ssh directory is ok$RESET"
	else
		echo -e "$FAULT User owner of .ssh directory is not OK$RESET"
		fault=$(( $fault + 2 ))
	fi
	if [ $GRP == $(whoami) ]
	then
		echo -e "$SUCCESS Group owner of .ssh directory is ok$RESET"
	else
		echo -e "$FAULT Group owner of .ssh directory is not OK$RESET"
		fault=$(( $fault + 2 ))
	fi

	if [ $fault -gt 1 ]
	then
		fault=$((fault-2))
		echo -e "$FAULT User or group fault on .ssh folder$RESET"
		echo -e "Do you want i try to correct that ?$RESET"
		echo -e "Y/N$RESET"
		read -n1 ans
		echo -e $ans
		if [[ ans =~ 'Y'* ]]
		then
			sudo chown $(whoami):$(whoami) ~/.ssh
			echo "chown"
		fi
	else
		echo ""
	fi
	if [ $fault -gt 0 ]
	then
		echo -e "$FAULT Right fault on .ssh folder$RESET"
		echo -e "Do you want i try to correct that ?$RESET"
		echo -e "Y/N$RESET"
		read -n1 ans
		echo -e $ans
		if [[ $ans =~ 'Y'* ]]
		then
			sudo chmod 700 ~/.ssh
			echo "chown"
		fi
	else
		echo ""
	fi
}

main (){

	cd
	rep=10
	while [ $rep -gt 0 ]
	do
		clear
		menu
		read -s -n1 rep;

		echo ""
		if [ $rep -eq 1 ]
		then
			clear
			echo -e "$MENU Start to generate new keyssh :$RESET"
			add_server
		fi
		if [ $rep -eq 2 ]
		then
			clear
			echo -e "$MENU Display config ssh :$RESET"
			display_config_ssh
		fi
		if [ $rep -eq 3 ]
		then
			clear
			echo -e "$MENU Check ssh configuration :$RESET"
			check_ssh_config
		fi
		if [ $rep -eq 9 ]
		then
			clear
			vim ${0}
			bash ${0}
			exit
		fi

		if [ $rep -gt 0 ]
		then
			echo -e "$MENU Press ENTER to continue$RESET"
			read Wait
		fi
	done
	echo -e "$MENU See you !$RESET"
}

main
