#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -X -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){

echo -e "What's your phone number?"
read CUSTOMER_PHONE
PHONE_VALID=$($PSQL "SELECT customer_id,name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $PHONE_VALID ]] #phone number not valid
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT_NAME=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  
  CREATE_APPOINTMENT;
fi

}

CREATE_APPOINTMENT() {
  CUST_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_CHOSEN=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_VALID")
  CUST_NAME_FORMATTED=$(echo $CUST_NAME | sed 's/ //g')
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_CHOSEN | sed 's/ //g')
  echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED,$CUST_NAME_FORMATTED?"
  read SERVICE_TIME
  INSERT_APPT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUST_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUST_NAME_FORMATTED."
}

LIST_SERVICES(){
if [[ $1 ]] 
then
  echo -e "\n$1"
fi
SERVICES=$($PSQL "SELECT service_id,name FROM services;")

echo "$SERVICES" | while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME"
done

read SERVICE_ID_SELECTED
#if input is not number
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
  LIST_SERVICES "I could not find that service. What would you like today?"
  else
  SERVICE_VALID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")  

  if [[ -z $SERVICE_VALID ]]
  then
  LIST_SERVICES "I could not find that service. What would you like today?"
  else
  MAIN_MENU
  fi
fi
}

LIST_SERVICES

