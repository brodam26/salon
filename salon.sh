#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how may I help you?\n"

AVAILABLE_SERVICES=$($PSQL "SELECT service_id,name FROM services")

MAIN_MENU(){

  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi

  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_TYPE
  do
    echo "$SERVICE_ID) $SERVICE_TYPE"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) SERVICE $SERVICE_ID_SELECTED ;;
  2) SERVICE $SERVICE_ID_SELECTED ;;
  3) SERVICE $SERVICE_ID_SELECTED ;;
  4) SERVICE $SERVICE_ID_SELECTED ;;
  5) SERVICE $SERVICE_ID_SELECTED ;;
  *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

SERVICE(){

#get phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

#see if in database
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#if not, get name
if [[ -z $CUSTOMER_NAME ]]
then
  #get customer name
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  #insert new customer
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi

#get customer ID
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
SERVICE_TYPE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")

echo -e "\nWhat time would you like your$SERVICE_TYPE, $CUSTOMER_NAME?"
read SERVICE_TIME

#add appointment to appointments table
APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

echo -e "\nI have put you down for a$SERVICE_TYPE at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU