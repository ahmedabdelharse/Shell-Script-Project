#! /bin/bash

#reading user input 
while :
do 
	read -p "Select your operation from Menu: (1-4), q -> exit 
	1- Create Database
	2- List Database
	3- Connect to Database
	4- Drop Database 
	Operation : " INPUT
	case $INPUT in 
		"1") echo "You Choosed Create DB";;
		"2") echo "You Choosed List DB";;
		"3") echo "You Choosed Connect to DB";;
		"4") echo "You Choosed Drop DB";;
		"q"|"exit") echo "Exiting" break;;
		*) echo "Please Enter Valid Input (1-4),  type q to Exit";;
	esac
done
