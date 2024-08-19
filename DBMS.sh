#!/bin/bash

#Main menu functions 
create_db(){
echo "Creating Database"
read -p "Enter Database name: " INPUT
}
list_db(){
echo "You Choosed List DB"
}
connect_to_db(){
echo "You Choosed Connect to DB"
}
drop_db(){
echo "You Choosed Drop DB"
}

#reading user input 
while :
do 
	sleep 0.5 #delaying start for readability
	echo ""
	read -p "Select your operation from Menu: (1-4), q -> exit 
		1- Create Database
		2- List Database
		3- Connect to Database
		4- Drop Database 
		
	Operation : " INPUT
	echo "" #empty line for visual
	sleep 0.2 #delaying output for readability
	case $INPUT in 
		"1") create_db
		;;
		"2") list_db
		;;
		"3") connect_to_db
		;;
		"4") drop_db
		;;
		"q"|"exit") echo "Exiting" 
		break
		;;
		*) echo "Please Enter Valid Input (1-4),  type q to Exit"
		;;
	esac
done


