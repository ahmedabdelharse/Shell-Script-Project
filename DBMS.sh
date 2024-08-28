#!/bin/bash

#$!!! to do - change space seperation to any character like :, ; or - ###$!@

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
		#foo="Hello"
		#foo="${foo} World"
		#echo "${foo}"
		#> Hello World
	tmpstr="" #temp string
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
				#to do -> edit 1,2 to be s,i
				read -p "Select Feild : $fnum Type (1- String, 2- Integer) :" ftype #feild type
				echo
				if [[ $ftype == 1 ]]; then #string type
					tmpstr="$tmpstr $fname:s"
					#echo -n "$fname(s)-" >> ./dbs/$db_path/$tname.txt
				elif [[ $ftype == 2 ]]; then #integer type
					tmpstr="$tmpstr $fname:i"
					#echo -n "$fname(i)-" >> ./dbs/$db_path/$tname.txt
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
	done
	echo "$tmpstr" >> ./dbs/$db_path/$tname.txt #replaces /n -> add new line after fname, ftype
	break #done entering fname, ftype -> exiting main while loop
fi	
done
}

drop_table(){
db_path=$1	
#Reading table name 
while : 
do
read -p "Enter Table name with no extension (enter back to exit): " tname #reading table-name
# to do -> rethink about tname with or without extension 
if [[ "$tname" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break #not yet tested
elif ! [[ -f "./dbs/$db_path/$tname.txt" ]]; then 
	echo "Table doesn't exist please Enter another Table name"
	echo "Available Tables are :" #can be removed for security if wanted
	ls ./dbs/$db_path/ 	#can be removed for security if wanted
	echo
	continue
else
	rm  ./dbs/$db_path/$tname.txt #to do -> add confirmation message
	echo "Table $tname is Deleted succesfully :)" #important -> to do -> add this message as STRDOUT > and one for Error 2>
	echo
	break
fi
done
}

insert_into_table(){
db_path=$1	
#Reading table name 
while : 
do
read -p "Enter Table name with no extension (enter back to exit): " tname #reading table-name
# to do -> rethink about tname with or without extension 
if [[ "$tname" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break #not yet tested
elif ! [[ -f "./dbs/$db_path/$tname.txt" ]]; then 
	echo "Table doesn't exist please Enter another Table name"
	echo "Available Tables are :" #can be removed for security if wanted
	ls ./dbs/$db_path/ 	#can be removed for security if wanted
	echo
	continue
else
	################ 
	cont="y"
	while [ $cont == "y" ]; #loop to continue adding enteries
	do
	tmpstr="" #temp string
	awk 'NR == 1  {for (i=1;i<=NF;i++) print $i}' ./dbs/$db_path/$tname.txt > ./dbs/$db_path/temp.txt #print 1st line fields into lines and store it in file 
	
	numofl=`sed -n -E '/[a-z].+:[is]$/p' ./dbs/$db_path/temp.txt | wc -l` #count num of lines in temp to use for loop 
	for i in `seq 1 $numofl`
	do
		if [[ `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $2}'` == "i" ]];then #if integer
			# Was used for debugging
			#echo " Line -->  `sed -n '1p' str1 `" 
			#echo " Last character is `sed -n '1p' str1 | awk -F":" '{print $2}'`"
			#echo " Line $i is: Integer"
			
			while :
			do 
			read -p "Please Enter `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $1}'` (must be number): " value
			if ! [[ $value =~ ^[0-9]+$ ]]; then
				echo "wrong type, Please Enter Numbers only"
				continue
			else
				tmpstr="$tmpstr $value"
				break
			fi	
			done

		elif [[ `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $2}'` == "s" ]];then
			#echo " Line -->  `sed -n '1p' str1 `" 
			#echo " Last character is `sed -n '1p' str1 | awk -F":" '{print $2}'`"
			#echo " Line $i is: String"

			while :
			do 
			read -p "Please Enter `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $1}'` (must be String not number): " value
			if [[ $value =~ ^[0-9]+$ ]]; then
				echo "wrong type, Please Enter Numbers only"
				continue
			else
				tmpstr="$tmpstr $value"
				break
			fi
			done
		
		else
			#echo " Line -->  `sed -n '1p' str1 `" 
			#echo " Last character is `sed -n '1p' str1 | awk -F":" '{print $2}'`"
			#echo " Line $i is: niether"
			echo "Error in table fileds "
			break
		fi
		sed -i '1d' ./dbs/$db_path/temp.txt
	done #for loop
	echo "$tmpstr" >> ./dbs/$db_path/$tname.txt
	# column -t -s' ' ./dbs/$db_path/$tname.txt
	rm ./dbs/$db_path/temp.txt
	while :
	do
	read -p "Do you want to add another Entery ? (y, n): " cont
	if [[ $cont == "y" ]];then
	echo "Adding Another Entery to table: $tname.txt"
	break
	elif [[ $cont == "n" ]];then
	echo "Exiting insert into table and going back to menu ... "
	break
	else 
	echo "wrong input, please enter y to continue, n to exit "
	continue
	fi
	done
	done #while loop 
	#echo "Table $tname is succesfully :)" #important -> to do -> add this message as STRDOUT > and one for Error 2>
	echo
	break
fi
done
}

select_from_table(){
db_path=$1	
#Reading table name 
echo "Selecting from table ... "
while : 
do
read -p "Enter Table name with no extension (enter back to exit): " tname #reading table-name
# to do -> rethink about tname with or without extension 
if [[ "$tname" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break #not yet tested
elif ! [[ -f "./dbs/$db_path/$tname.txt" ]]; then 
	echo "Table doesn't exist please Enter another Table name"
	echo "Available Tables are :" #can be removed for security if wanted
	ls ./dbs/$db_path/ 	#can be removed for security if wanted
	echo
	continue
else
	cont="y"
	while [ $cont == "y" ]; #loop to continue viewing enteries
	do
	#tmpstr="" #temp string
	read -p "Choose Select Method (enter 1,2,3): 
	  1-All Table   2-by Row   3-by Search ->  " smthd
	if [[ $smthd == 1 ]]; then
		awk '{print}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g' > ./dbs/$db_path/temp.txt

		column -t -s' ' ./dbs/$db_path/temp.txt
		rm ./dbs/$db_path/temp.txt
	elif [[ $smthd == 2 ]]; then
		while :
		do
		read -p "Enter Row number " rnum
		if [[ $rnum =~ ^[0-9]+$ ]];then
			awk 'NR == 1 {print}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g' > ./dbs/$db_path/temp.txt
			rnum=$(($rnum+1))
			awk 'NR == '$rnum' {print}' ./dbs/$db_path/$tname.txt >> ./dbs/$db_path/temp.txt
			column -t -s' ' ./dbs/$db_path/temp.txt
			rm ./dbs/$db_path/temp.txt
			break
		else
			echo "wrong input, please enter number only"
			continue
		fi
		done
	elif [[ $smthd == 3 ]]; then #fix search requires absolute match 
		echo "Table Columns are : "
		awk 'NR == 1 {print}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g'
		awk 'NR == 1 {for (i=1;i<=NF;i++) print $i}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g' > ./dbs/$db_path/cl_list.txt
		echo
		while : 
		do
		read -p "Enter Your search column " scl

		#ls | grep servername$

		if [[ `awk '/^'$scl'$/' ./dbs/$db_path/cl_list.txt` ]];then #if column is present or not
			cl_num=`wc -l < ./dbs/$db_path/cl_list.txt`
			for i in `seq 1 $cl_num`
			do
			if [[ $scl == `awk 'NR == '$i' {print}' ./dbs/$db_path/cl_list.txt` ]]; then
				read -p "Search Cloumn: $scl  for value ->  " sval
				awk 'NR ==1 {print}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g' > ./dbs/$db_path/temp.txt
				awk '{if($'$i' == "'$sval'") print $0}' ./dbs/$db_path/$tname.txt >> ./dbs/$db_path/temp.txt
				column -t -s' ' ./dbs/$db_path/temp.txt
				rm ./dbs/$db_path/temp.txt
				break
			fi
			done	
		else
			echo "NO column with value: $scl"
		fi
		break
		done #while
		rm ./dbs/$db_path/cl_list.txt
	else 
	echo "wrong input, please enter of numbers {1,2,3}"
	continue
	fi
	
	while :
	do
	read -p "Do you want to search for another Entery ? (y, n): " cont
	if [[ $cont == "y" ]];then
	#echo "Adding Another Entery to table: $tname.txt"
	break
	elif [[ $cont == "n" ]];then
	#echo "Exiting insert into table and going back to menu ... "
	break
	else 
	echo "wrong input, please enter y to continue, n to exit "
	continue
	fi
	done
	done #while loop 
	#echo "Table $tname is succesfully :)" #important -> to do -> add this message as STRDOUT > and one for Error 2>
	echo
	break
fi
done
}

delete_from_table(){
db_path=$1	
#Reading table name 
echo "Selecting from table ... "
while : 
do
read -p "Enter Table name with no extension (enter back to exit): " tname #reading table-name
# to do -> rethink about tname with or without extension 
if [[ "$tname" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break #not yet tested
elif ! [[ -f "./dbs/$db_path/$tname.txt" ]]; then 
	echo "Table doesn't exist please Enter another Table name"
	echo "Available Tables are :" #can be removed for security if wanted
	ls ./dbs/$db_path/ 	#can be removed for security if wanted
	echo
	continue
else
	cont="y"
	while [ $cont == "y" ]; #loop to continue viewing enteries
	do
	#tmpstr="" #temp string
	read -p "Enter Row number to delete (enter "view" to view all Table Rows) ->  " dnum
	if [[ $dnum == "view" ]]; then
		echo "Line ->  Table "
		awk 'NR == 1 {print "   ", $0}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g' | column -t -s' '
		sed -e '1d' ./dbs/$db_path/$tname.txt | awk '{print NR," ->", $0}' | column -t -s' '
		#sed -e '1,2d' -e '$d' ./dbs/$db_path/$tname.txt | awk '{print NR," ->", $0}' | column -t -s' '
		echo
		## continue here ## 
		#awk '{print}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g' > ./dbs/$db_path/temp.txt

		#column -t -s' ' ./dbs/$db_path/temp.txt
		#rm ./dbs/$db_path/temp.txt
	elif  [[ $dnum =~ ^[0-9]+$ ]]; then #fix deleting empty lines	
			dnum=$(($dnum+1))
			`sed -i ''$dnum'd' ./dbs/$db_path/$tname.txt` 
			#need to add checks if it'd excuted or error -> 
		#if [[ `sed -i ''$dnum'd' ./dbs/$db_path/$tname.txt` ]]; then 
		#	echo "Succesfully deleted Row: $(($dnum-1)) " 
		#else 
		#	echo "error at attempting to delete row: $(($dnum-1)) " 
		#fi
		  
	else
		echo "wrong input, please enter number only"
		continue
	fi
	
	
		while :
		do
		read -p "Do you still want to delete from table ? (y, n): " cont
		if [[ $cont == "y" ]];then
			#echo "Adding Another Entery to table: $tname.txt"
		break
		elif [[ $cont == "n" ]];then
			#echo "Exiting insert into table and going back to menu ... "
		break
		else 
			echo "wrong input, please enter y to continue, n to exit "
			continue
		fi
		done #while loop 
	done
	#echo "Table $tname is succesfully :)" #important -> to do -> add this message as STRDOUT > and one for Error 2>
	echo
	#break
fi
done
}

update_table(){
db_path=$1
#Reading table name 
echo "Updating Table ... "
while :
do
read -p "Enter Table name with no extension (enter back to exit): " tname #reading table-name
# to do -> rethink about tname with or without extension 
if [[ "$tname" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break #not yet tested
elif ! [[ -f "./dbs/$db_path/$tname.txt" ]]; then 
	echo "Table doesn't exist please Enter another Table name"
	echo "Available Tables are :" #can be removed for security if wanted
	ls ./dbs/$db_path/ 	#can be removed for security if wanted
	echo
	continue
else
	echo "Updating Table $tname.txt ..."
	cont="y"
	while [ $cont == "y" ]; #loop to continue updating table loop
	do
	read -p "Enter Row number to update (enter "view" to view all Table Rows) ->  " unum
	if [[ $unum == "back" ]]; then
		break
	elif [[ $unum == "view" ]]; then
		echo "Line ->  Table "
		awk 'NR == 1 {print "   ", $0}' ./dbs/$db_path/$tname.txt | sed  -E 's/:[is]//g' | column -t -s' '
		sed -e '1d' ./dbs/$db_path/$tname.txt | awk '{print NR," ->", $0}' | column -t -s' '
		echo
		continue
	elif  [[ $unum =~ ^[0-9]+$ ]]; then #fix deleting empty lines	
		unum=$(($unum+1))
		tmpstr="" #temp string
		awk 'NR == 1  {for (i=1;i<=NF;i++) print $i}' ./dbs/$db_path/$tname.txt > ./dbs/$db_path/temp.txt #print 1st line fields into lines and store it in file 
	
		numofl=`sed -n -E '/[a-z].+:[is]$/p' ./dbs/$db_path/temp.txt | wc -l` #count num of lines in temp to use for loop 
		for i in `seq 1 $numofl`
		do
		if [[ `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $2}'` == "i" ]];then #if integer
					
			while :
			do 
			read -p "Please Enter `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $1}'` (must be number): " value
			if ! [[ $value =~ ^[0-9]+$ ]]; then
				echo "wrong type, Please Enter Numbers only"
				continue
			else
				tmpstr="$tmpstr $value"
			break
			fi	
			done
		elif [[ `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $2}'` == "s" ]];then
			while :
			do 
			read -p "Please Enter `sed -n '1p' ./dbs/$db_path/temp.txt | awk -F":" '{print $1}'` (must be String not number): " value
			if [[ $value =~ ^[0-9]+$ ]]; then
				echo "wrong type, Please Enter Numbers only"
			continue
			else
				tmpstr="$tmpstr $value"
			break
			fi
			done
		else
			echo "Error in table fileds "
		#break
		fi
		sed -i '1d' ./dbs/$db_path/temp.txt
		done #for loop
		rm ./dbs/$db_path/temp.txt
		#replacable line: unum
		echo
		echo "replacing row:  `awk 'NR == '$unum' {print}' ./dbs/$db_path/$tname.txt`"
		echo "with row:  $tmpstr"
		echo
		sed -i "s/`awk 'NR == '$unum' {print}' ./dbs/$db_path/$tname.txt`/$tmpstr/" ./dbs/$db_path/$tname.txt
			  
	else
		echo "wrong input, please enter number only"
		continue
	fi	
	
	while :
	do
	read -p "Do you still want to update table ? (y, n): " cont
	if [[ $cont == "y" ]];then
			#echo "Adding Another Entery to table: $tname.txt"
		break
	elif [[ $cont == "n" ]];then
			#echo "Exiting insert into table and going back to menu ... "
		break
	else 
		echo "wrong input, please enter y to continue, n to exit "
		continue
	fi
	done #while cont loop 
	done #else main while
	echo
	#break
fi
done
}




###@@@@ Main menu functions @@@@### 
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
echo #add clear line for readability
while : 
do
echo "Databases available are :"
ls "./dbs/"
echo
read -p "Enter Database name to select (enter back to exit): " INPUT #reading dbs dir, need modiying to filter input if valid or not etc 
if [[ "$INPUT" = "back" ]]; then 
	echo "Back to Main Menu .. "
	sleep 0.1
	break
elif [[ -d "./dbs/$INPUT" ]]; then 
	while : #to do - add back for exit option
	do 
	sleep 0.2 #delaying start for readability
	read -p "Selected Database is: $INPUT, Choose your Operation.
	(enter "back" to exit)  
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
		"2") echo "Available Tables are : "
			 ls "./dbs/$INPUT"
			 echo
		;;
		"3") drop_table $INPUT #regular bash
		;;
		"4") insert_into_table $INPUT #awk-sed use begins 
		;;
		"5") select_from_table $INPUT #awk-sed use begins 
		;;
		"6") delete_from_table $INPUT #awk-sed use begins 
		;;
		"7") update_table $INPUT #awk-sed use begins 
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


