#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon Shop ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi
  
  echo -e "\nAvailable Services"
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  
  if [[ -z $AVAILABLE_SERVICES ]] 
  then
    echo -e "\nService not available right now"
  else
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do 
      echo "$SERVICE_ID) $NAME"
    done
    echo -e "\nPick a service?"
    read SERVICE_ID_SELECTED

    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then 
      MAIN_MENU "That is not a valid service number."
    else
      #CUSTOMER_PHONE
      echo -e "\nEnter your phone number:"
      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

      if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nEnter your name"
        read CUSTOMER_NAME

        #insert new customer
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
        echo $INSERT_CUSTOMER_RESULT
      fi

      CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone = '$CUSTOMER_PHONE'")
      echo $CUSTOMER_ID

      #SERVICE_TIME
      echo -e "\nEnter time for service"
      read SERVICE_TIME

      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo $INSERT_APPOINTMENT_RESULT

      SERVICE_NAME=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
      echo $SERVICE_NAME

      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi
}

MAIN_MENU