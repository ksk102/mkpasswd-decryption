#!/bin/bash

# function to find the first hashing type
function find_hash_type1(){

	# get the first index, to check if it is start with '$' sign
	HASH_TYPE_NO1=`cat hackpair.pwd | cut -c1-1`

	if [ $HASH_TYPE_NO1 != "\$" ]; then # if first hash is not start with '$' sign
		HASH_TYPE_NO1=0

		# get the values from 3 to last of the first segment for encrypted key
		ENCR1=`cat hackpair.pwd | cut -d"$" -f1 | cut -c3-13`
		# get the first two values for salt
		SALT1=`cat hackpair.pwd | cut -c1-2`

		# declare the variable
		HASH_TYPE_NO2=''
		ENCR2=''
		SALT2=''

		find_hash_type2 2 HASH_TYPE_NO2 ENCR2 SALT2 # function to find the second hash hashing type

	else # if first hash is start with '$' sign
		HASH_TYPE_NO1=`cat hackpair.pwd | cut -d"$" -f2` # get the value after first '$' sign

		# get the values between third and fourth '$' for encrypted key
		ENCR1=`cat hackpair.pwd | cut -d"$" -f4`
		# get the values between second and third '$' for salt
		SALT1=`cat hackpair.pwd | cut -d"$" -f3`

		# declare the variable
		HASH_TYPE_NO2=''
		ENCR2=''
		SALT2=''

		find_hash_type2 5 HASH_TYPE_NO2 ENCR2 SALT2 # function to find the second hash hashing type
	fi

	# return the values
	eval $1=$HASH_TYPE_NO1 
	eval $2=$HASH_TYPE_NO2
	eval $3=$ENCR1
	eval $4=$SALT1
	eval $5=$ENCR2
	eval $6=$SALT2
}

# function to find the second hashing type
function find_hash_type2(){

	PARA=$1 # get the parameter

	# get the first index of the second fragment of the hashed code
	HASH_TYPE_NO2=`cat hackpair.pwd | cut -d"$" -f$PARA | cut -c1-1`

	if [ -z $HASH_TYPE_NO2 ]; then # if the first index is empty
		HASH_TYPE_NO2=`cat hackpair.pwd | cut -d"$" -f$((PARA+1))` # get the value after the first '$' sign of second fragment

		# get the values between third and fourth '$' for encrypted key
		ENCR2=`cat hackpair.pwd | cut -d"$" -f$((PARA+3))`
		# get the first two values as salt
		SALT2=`cat hackpair.pwd | cut -d"$" -f$((PARA+2))`
	
	else # if the first index is not empty
		HASH_TYPE_NO2=0

		# get the values from 3 to last of the first segment for encrypted key
		ENCR2=`cat hackpair.pwd | cut -d"$" -f$(($PARA)) | cut -c3-13`
		# get the values between second and third '$' as salt
		SALT2=`cat hackpair.pwd | cut -d"$" -f$(($PARA)) | cut -c1-2`
	fi

	eval $2=$HASH_TYPE_NO2
	eval $3=$ENCR2
	eval $4=$SALT2
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
ENCR1=''
SALT1=''
ENCR2=''
SALT2=''

find_hash_type1 HASH_TYPE_NO1 HASH_TYPE_NO2 ENCR1 SALT1 ENCR2 SALT2 # function to find the first hash hashing type

# declare the variable
HASH_TYPE1=''
HASH_TYPE2=''

# function to convert the type number to hashing name
convert_hash_type $HASH_TYPE_NO1 HASH_TYPE1 
convert_hash_type $HASH_TYPE_NO2 HASH_TYPE2

# Since that we know the password is exactly 3 alphanumeric long
# iterate through all possible combinations of plaintext
# password, encrypt it (assign it to the variable test) and
# compare it to the encrypted password that was retrieved as
# the variable ENCR1 and ENCR2.
PASSWORD1=''
PASSWORD2=''

for i in $LIST; do
	for j in $LIST; do
		for k in $LIST; do

	  		echo -n "$i$j$k "

	  		# if the hash type is not DES, then get the values after third '$' sign
	  		if [ $HASH_TYPE_NO1 != 0 ]; then
				TEST1=`mkpasswd -m $HASH_TYPE1 $i$j$k -s $SALT1 | cut -d"$" -f4`
			# if the hash type is DES, then get the values before third to thirteenth
			else
				TEST1=`mkpasswd -m $HASH_TYPE1 $i$j$k -s $SALT1 | cut -c3-13`
			fi

			# if the hash type is not DES, then get the values after third '$' sign 
			if [ $HASH_TYPE_NO2 != 0 ]; then
				TEST2=`mkpasswd -m $HASH_TYPE2 $i$j$k -s $SALT2 | cut -d"$" -f4`
			# if the hash type is DES, then get the values before third to thirteenth
			else
				TEST2=`mkpasswd -m $HASH_TYPE2 $i$j$k -s $SALT1 | cut -c3-13`
			fi

			# if the password is a match, then store the password first, if another password also found, print both password together, and exit the system
			if [ $TEST1 == $ENCR1 ]; then
				PASSWORD1=$i$j$k

				if [ -n "$PASSWORD2" ]; then
					echo "Password1 is: $PASSWORD1"
					echo "Password2 is: $PASSWORD2"
					exit
				fi
			fi

			if [ $TEST2 == $ENCR2 ]; then
				PASSWORD2=$i$j$k
				
				if [ -n "$PASSWORD1" ]; then
					echo "Password1 is: $PASSWORD1"
					echo "Password2 is: $PASSWORD2"
					exit
				fi
			fi
		done
	done
done