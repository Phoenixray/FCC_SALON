#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"



MAIN_MENU(){

if [[ $1 ]]
then
    echo "$1"
fi    

#Show Services
SERVICES_LIST=$($PSQL "Select SERVICE_ID, NAME from services order by service_id")
echo "$SERVICES_LIST" | while read SERVICE_ID BAR SERVICE_NAME
do
    echo "$SERVICE_ID) $SERVICE_NAME"
done

echo -e "Please select a service you need:"
read SERVICE_ID_SELECTED
 SERVICE_NAME=$($PSQL "Select name from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU 
  else  

    #Book Appointment   
    echo "Please enter your phone number"
    read CUSTOMER_PHONE
    #Check Customer exists .
    CUSTOMER_NAME=$($PSQL "Select name from customers where phone='$CUSTOMER_PHONE'")    
    if [[ -z $CUSTOMER_NAME ]]
    then
        #Get Customer name from User
        echo "Enter Customer Name"
        read CUSTOMER_NAME
        #Insert new Customer 
        INSERT_NEW_CUSTOMER=$($PSQL "Insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")        
           
    fi    

    #Get  Customer ID
    CUSTOMER_ID=$($PSQL "Select customer_id from customers where phone='$CUSTOMER_PHONE'") 
    #Get Time for Appointment
    echo "Enter Appoinment Time"
    read SERVICE_TIME
    #Insert Appointment in DB
    INSERT_APPT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo $INSERT_APPT
    #Show Message
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $CUSTOMER_NAME."
 
  fi

}

MAIN_MENU 