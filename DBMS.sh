#!/bin/bash

echo "Starting Database Management System ..." #improve readability
	sleep 0.2
	
if [[ -d "./dbs" ]]; then #check if dbs dir exist 
		echo "reading dbs ..."  #read dbs dir
	else
		echo "There is no Databases Directory, Creating dbs Directory ..." #crating dbs dir if not existing 
		mkdir ./dbs
	fi
	
#Main menu functions 
create_db(){
echo "Creating Database"
while : 
do
read -p "Enter Database name (enter back to exit): " INPUT #reading dbs dir, need modiying to filter input if valid or not etc 
#for db in `ls -d ./dbs/`
#do 
if [[ "$INPUT" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break
elif [[ -d "./dbs/$INPUT" ]]; then 
	echo "Database name already existes please choose another name"
	continue
else
	mkdir ./dbs/$INPUT
	echo "Database $INPUT is Created succesfully :)" 
	echo
	break
fi
#done

done
#ls -d ./dbs/$INPUT 2>/dev/null||mkdir yourdir  
#mkdir /dbs/$INPUT

}
list_db(){
echo "Listing DB ..."
sleep 0.1
echo "Databases available are :"
ls "./dbs/"
echo #add clear line for readability
}
connect_to_db(){
echo "You Choosed Connect to DB"
echo "Databases available are :"
ls "./dbs/"
echo #add clear line for readability
while : 
do
read -p "Enter Database name to select (enter back to exit): " INPUT #reading dbs dir, need modiying to filter input if valid or not etc 
if [[ "$INPUT" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break
elif [[ -d "./dbs/$INPUT" ]]; then 
	while : #to do - add back for exit option
	do 
	sleep 0.2 #delaying start for readability
	read -p "Selected Database : $INPUT, Choose your Operation.  
		1- Create Table
		2- List Tables
		3- Drop Table 
		4- Insert into Table
		5- Select from Table
		6- Delete from Table
		7- Update Table 
		
	Operation : " OP
	echo "" #empty line for visual
	sleep 0.2 #delaying output for readability
	case $OP in 
		#&&& to do next $$$$$$$$ ->>
		"1") echo "create_table" 
		;;
		"2") echo "list_table"
		;;
		"3") echo "drop_table" #regular bash
		;;
		"4") echo "insert_into_table" #awk-sed use begins 
		;;
		"5") echo "select_from_table" #awk-sed use begins 
		;;
		"6") echo "delete_from_table" #awk-sed use begins 
		;;
		"7") echo "update_table" #awk-sed use begins 
		;;
		"back") echo "Exiting to List Database Menu" 
		break 
		;;
		*) echo "Please Enter Valid Input (1-7)"
		continue
		;;
	esac
	done
else
	echo "Please Enter a valid Database name" 
	echo
	continue
fi
done

}
drop_db(){
echo "You Choosed Drop DB"
}

#reading user input 
while :
do 
	#checking for databases (dbs) dir is available or create dbs directory
	#ls yourdir 2>/dev/null||mkdir yourdir -> unused another way to create 
	
	#for dirs in `ls -d .`	
	#do 
	#if [[ "$dirs" == "dbs" ]]; then 
	#	break
	#	else
	#	echo ""
	#	mkdir ./dbs
	#fi
	#done
	
	
	sleep 0.5 #delaying start for readability
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


