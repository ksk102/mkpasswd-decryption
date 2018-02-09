#!/bin/bash

# function to find the first hashing type
function find_hash_type1(){

	# get the first index, to check if it is start with '$' sign
	HASH_TYPE_NO1=`cat hackpair.pwd | cut -c1-1`

	if [ $HASH_TYPE_NO1 != "\$" ]; then # if first hash is not start with '$' sign
		HASH_TYPE_NO1=0

		find_hash_type2 2 # function to find the second hash hashing type
		HASH_TYPE_NO2=$? # get the return value from function

	else # if first hash is start with '$' sign
		HASH_TYPE_NO1=`cat hackpair.pwd | cut -d"$" -f2` # get the value after first '$' sign

		find_hash_type2 5 # function to find the second hash hashing type
		HASH_TYPE_NO2=$? # get the return value from function
	fi

	# return the values
	eval $1=$HASH_TYPE_NO1 
	eval $2=$HASH_TYPE_NO2
}

# function to find the second hashing type
function find_hash_type2(){

	PARA=$1 # get the parameter

	# get the first index of the second fragment of the hashed code
	HASH_TYPE_NO2=`cat hackpair.pwd | cut -d"$" -f$PARA | cut -c1-1`

	if [ -z $HASH_TYPE_NO2 ]; then # if the first index is empty
		HASH_TYPE_NO2=`cat hackpair.pwd | cut -d"$" -f$((PARA+1))` # get the value after the first '$' sign of second fragment
	
	else # if the first index is not empty
		HASH_TYPE_NO2=0
	fi

	return $HASH_TYPE_NO2
}

# function to convert the type number to hashing name
function convert_hash_type(){
	case $1 in
		0)
			HASH_TYPE="DES"
			;;
		1)
			HASH_TYPE="MD5"
			;;
		5)
			HASH_TYPE="SHA-256"
			;;
		6)
			HASH_TYPE="SHA-512"
			;;
	esac

	eval $2=$HASH_TYPE # return the hashing type
}

# LIST is the list of alphanumeric to try
LIST="q w e r t y u i o p a s d f g h j k l z x c v b n m Q W E R T Y U I O P A S D F G H J K L Z X C V B N M 1 2 3 4 5 6 7 8 9 0"

# declare the variable
HASH_TYPE_NO1=''
HASH_TYPE_NO2=''

find_hash_type1 HASH_TYPE_NO1 HASH_TYPE_NO2 # function to find the first hash hashing type

# declare the variable
HASH_TYPE1=''
HASH_TYPE2=''

# function to convert the type number to hashing name
convert_hash_type $HASH_TYPE_NO1 HASH_TYPE1 
convert_hash_type $HASH_TYPE_NO2 HASH_TYPE2

# # Assign to the variable encr the encrypted password from the
# # hijacked shadow file
# encr=`cat hackpair.pwd | cut -d"$" -f4`
# # Assign to the variable salt the salt used to generate the
# # encrypted password
# salt=`cat hackpair.pwd | cut -d"$" -f3`

# # Assuming we know that the password is 3 alphanumeric long,
# # iterate through all possible combinations of plaintext
# # password, encrypt it (assign it to the variable test) and
# # compare it to the encrypted password that was retrieved as
# # the variable encr.
# for i in $LIST
#   do
#    for j in $LIST
#     do
# 	for k in $LIST
# 	 do
# 	  	echo -n "$i$j$k "
	   
#   		test=`mkpasswd -m sha-512 $i$j$k -s $salt | cut -d"$" -f4`

# 		if [ $test == $encr ] ; then
# 			echo "Password is: $i$j$k"
# 			exit
# 		fi
# 	  done
# 	done
# done