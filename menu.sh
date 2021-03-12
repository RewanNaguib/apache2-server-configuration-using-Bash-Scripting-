###Module contain the menu driver
###Function display the menu

function displayMenu {
	
	echo "Main Menu"
	echo "----------"
	echo "1-Install apache2"
	echo "2-Remove apache2 "
	echo "3-List all Virtual Host"
	echo "4-Add a Virtual Host"
	echo "5-Delete a Virtual Host"
	echo "6-Enable a Virtual Host"
	echo "7-Disable a Virtual Host"
	echo "8-Enable a Virtual Host authentication"
	echo "9-Disable a Virtual Host authentication"
	echo "10-Quit"

}



###### Function that read virtual host name from user 
function readvirtulhost {
      read -p "Enter Virtual Host Name :" HOSTNAME
}


###### Function that install apache2

function installapache2 {


	if [ $(apache2 -v | grep -v grep | grep 'Server version: Apache' | wc -l) = 0 ]
	then
		  echo "Installing apache2"
		    sudo apt apache2 install
		     else
			      echo "apache2 is already exist"
	fi	        
}



###### Function that remove apache2

#function removeapache2 {

      #sudo apt remove apache2


        # if [ $(apache2 -v | grep -v grep | grep 'Server version: Apache' | wc -l) != 0 ]
		        # then
				                  # echo "removing apache2"
						   # sudo apt remove apache2 -i
	                                           # else
					           # echo "apache2 is not exist"

	# fi

#}	


	        


##### Function display that list all virtual hosts in the system to the std/output

function listallvirtualhost {
	
	ls /etc/apache2/sites-available
}




###### Function to add a virtual host

function addvirtualhost { 

 
 #sudo mkdir /var/websites
 sudo mkdir /var/www/html/${HOSTNAME}.com

 cd /var/www/html/${HOSTNAME}.com/
 echo " ${HOSTNAME}.com " > index.html 
 
 cd  /etc/apache2/sites-available/
 echo "<VirtualHost *:80>
     DocumentRoot /var/www/html/${HOSTNAME}.com
     ServerName ${HOSTNAME}.com
     </VirtualHost>
   <Directory /var/www/html/${HOSTNAME}.com>
     Options ALL
     AllowOverride All
     Require all granted
       </Directory>"  > ${HOSTNAME}.com.conf  
                                                                             
 sudo a2ensite ${HOSTNAME}.com
 cd /mnt/c/Windows/System32/drivers/etc/
 sudo echo "127.0.0.1    ${HOSTNAME}.com" >> hosts
 sudo service apache2 restart  

  
}


##### Function to delete a virtual host

function deletevirtualhost { 
 cd /etc/apache2/sites-available/
 sudo rm  ${HOSTNAME}.com.conf

 cd  

 cd /var/www/html/
 sudo rm ${HOSTNAME}.com/index.html
 } 


####### Function to enable a virtual host

function enablevirtualhost {

     sudo a2ensite ${HOSTNAME}.com.conf
     sudo /etc/init.d/apache2 reload     
}


####### Function to disable a virtual host

function disablevirtualhost { 
	                 
   sudo a2dissite ${HOSTNAME}.com.conf
   sudo /etc/init.d/apache2 reload 
   
}

####### Function to enable authentication of a virtual host

function enablevirtualhostauthentication {
cd
cd /etc/apache2/
if [ $(ls -a | grep '.htpasswd' | wc -l) = 0 ]
  then
     read -p "Enter User Name:" USERNAME
    sudo htpasswd -c /etc/apache2/.htpasswd ${USERNAME}
     echo "creating .hpasswd success"
else
      echo ".htpasswd already exists"
fi

cd
cd /var/www/html
if [ $(ls -a | grep '.htaccess' | wc -l) = 0 ]
   then
    read -p "Enter User Name:" USERNAME
    sudo nano /var/www/html/.htaccess
    echo "creating .htaccess success"
else
    echo ".htpasswd already exists"
fi

cd 
cd /var/www/html
echo " AuthType Basic
 AuthName \"Restricted Content\"
 AuthUserFile /etc/apache2/.htpasswd
 Require valid-user " > .htaccess

 cd
 cd /etc/apache2/sites-available/
       echo "
        

           <VirtualHost *:80>
	   DocumentRoot /var/www/html/${HOSTNAME}.com
           ServerName ${HOSTNAME}.com
           </VirtualHost>
	   <Directory /var/www/html/${HOSTNAME}.com>
	   Options ALL
	   AllowOverride All
	  Require valid-user
          </Directory>     " > ${HOSTNAME}.com.conf
	  
	  cd
	  sudo service apache2 restart






}



#######Function to disable authentication of a virtual host

function disablevirtualhostauthentication {

cd
 cd /etc/apache2/sites-available/
 echo "


   <VirtualHost *:80>
   DocumentRoot /var/www/html/${HOSTNAME}.com
   ServerName ${HOSTNAME}.com
   </VirtualHost>
   <Directory /var/www/html/${HOSTNAME}.com>
   Options ALL
   AllowOverride All
   Require all granted
   </Directory>     " > ${HOSTNAME}.com.conf

 cd
 sudo service apache2 restart
}




##### Function control menu operation
function runMenu {
	local CH 
	local FLAG=1
	while [ ${FLAG} -eq 1 ]
	do 
	       	echo "Enter your choice:"
		read CH 
		case ${CH} in
			"1") 
				
				  installapache2
		 
				;;



		           "2")    removeapache2

				  
                                 ;;


                              
	                  "3")  
				listallvirtualhost 

 	       
				;;




                                    

                            "4")  
				    readvirtulhost
				    addvirtualhost
                                                                 
                                     

				    ;;

                        
	                 "5")      readvirtulhost
                                   deletevirtualhost
                          
                                  ;;				 
       

	                 "6")    readvirtulhost
				 enablevirtualhost
				 
				 ;;

			 "7")    readvirtulhost
				 disablevirtualhost
			     
			       ;;

		        "8")     readvirtulhost
		                 enablevirtualhostauthentication
		                ;;

   		        "9")      readvirtulhost
	 	                 disablevirtualhostauthentication

		                 ;;		




                         "10")
				 FLAG=0
				 ;;

		       *)  
			       echo "Invalid choice, please try again"
			       			

	
	
	
		       ;;     
	esac
   done	
}
                  			       



