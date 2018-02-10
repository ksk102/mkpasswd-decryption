# LIST is the list of characters to try
LIST="q w e r t y u i o p a s d f g h j k l z x c v b n m Q W E R T Y U I O P A S D F G H J K L Z X C V B N M 1 2 3 4 5 6 7 8 9 0"

encr1=`cat hackpair.pwd | cut -d"$" -f4` # get the encrypted code
salt1=`cat hackpair.pwd | cut -d"$" -f3` # get the salt

encr2=`cat hackpair.pwd | cut -d"$" -f8` # get the encrypted code for 2nd hashed value
salt2=`cat hackpair.pwd | cut -d"$" -f7` # get the salt for 2nd hashed value

password1=''
password2=''

# loop each of the alphanumeric one by one
for i in $LIST; do
	for j in $LIST; do
		for k in $LIST; do
			echo -n "$i$j$k "

			# encrypt the alphanumeric to hash value, and compare with the hashed values in hackpair.pwd
			test1=`mkpasswd -m sha-256 $i$j$k -s $salt1 | cut -d"$" -f4`
			test2=`mkpasswd -m sha-512 $i$j$k -s $salt2 | cut -d"$" -f4`

			if [ $test1 == $encr1 ]; then
				$password1 = $i$j$k
			fi

			if [ $test2 == $encr2 ]; then
				$password2 = $i$j$k
			fi

			# print both password together only when both are found
			if [ -n "$password1" ] && [ -n "$password2" ]; then
				printf "\n\nPassword1 is: $password1\n"
				printf "Password1 is: $password2\n"
				exit
			fi
		done
	done
done