#!/bin/bash

echo "Starting Database Management System ..." #improve readability
	sleep 0.2
	
if [[ -d "./dbs" ]]; then #check if dbs dir exist 
		echo "reading dbs ..."  #read dbs dir
	else
		echo "There is no Databases Directory, Creating dbs Directory ..." #crating dbs dir if not existing 
		mkdir ./dbs
	fi

#Connect_to_db functions ***@ current working point @***
create_table(){ 
echo "Creating Table"
db_path=$1 #$1 is db dir/name  #selected db -> db dir (./dbs/$db_path)
#Reading table name 
while : 
do
read -p "Enter Table name (enter back to exit): " tname #reading .dbs/$db_path/tname
if [[ "$tname" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break #not yet tested
elif [[ -f "./dbs/$db_path/$tname.txt" ]]; then 
	echo "Table already existes please Enter another Table name"
	echo "Available Tables are :" #can be removed for security if wanted
	ls ./dbs/$db_path/ 	#can be removed for security if wanted
	echo
	continue
else
	touch ./dbs/$db_path/$tname.txt
	echo "Table $tname is Created succesfully :)" 
	echo
	break
fi
done

while : #main while loop
do
read -p "Enter Num of Fields/Columns (enter back to exit): " NUMOFF #reading num of fileds integer filtered 

if [[ "$NUMOFF" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break
elif ! [[ $NUMOFF =~ ^[0-9]+$ && $NUMOFF -gt 0 ]] ; then #add explaination 
	echo "error: Please Enter Numbers only (can't be zero)" 
	continue #not yet tested
else 
	NUMOFF=$(expr $NUMOFF + 0 ) #expr is to evalute NUMOFF -> filters preceding zero digits
	echo "Creating Table with $NUMOFF Fields/Columns"
	#added earlier -> touch ./dbs/$db_path/db_table.txt #creating table file - presist in all code
	#NUMOFF in file maybe can be removed if awk-sed can handle num of fields
	#removed -> echo "$NUMOFF" > ./dbs/$db_path/$tname.txt #marking num of feilds at first line 
	for fnum in `seq 1 $NUMOFF`
	do
		while : #to ensure fname,ftype entered correctly
		do
			read -p "Enter Feild $fnum Name : " fname  #feild name
			if [[ $fname =~ ^[0-9]+$ ]]; then #not tested yet - test for space and 0 and numbers
				echo "error: Please Enter String only (can't be number)" 
				continue #not yet tested
			else
				while :
				do
				read -p "Select Feild : $fnum Type (1- String, 2- Integer) :" ftype #feild type
				echo
				if [[ $ftype == 1 ]]; then #string type
					echo -n "$fname(s)		" >> ./dbs/$db_path/$tname.txt
				elif [[ $ftype == 2 ]]; then #integer type
					echo -n "$fname(i)		" >> ./dbs/$db_path/$tname.txt
				else
					echo " error: Please Enter either 1 or 2" 
				continue
				fi
				break #break to outer while loop
				done
			fi
			echo
			break #breaks/goes to next iteration
		done 
		#Entering data to file 
		#echo -n "this is the text" >> db_table.txt # <-- coding here 
	done
	echo "" >> ./dbs/$db_path/$tname.txt #replaces /n -> add new line after fname, ftype
	break #done entering fname, ftype -> exiting main while loop
fi	
done
}



#Main menu functions 
create_db(){
echo "Creating Database"
while : 
do
read -p "Enter Database name (enter back to exit): " INPUT #reading dbs dir
#to do - need to add filter to ensure INOUT is string if wanted
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
done
#done
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
		#&&& to do next $$$$$$$$ 
		"1") create_table $INPUT #--> i'm here
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


