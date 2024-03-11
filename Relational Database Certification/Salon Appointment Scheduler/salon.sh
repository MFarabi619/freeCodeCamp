#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~ Salon Appointment Scheduler ~~~~"

MAIN_MENU() {
	if [[ $1 ]]; then
		echo -e "\n$1"
	fi

	echo -e "\nWelcome to My Salon, how can I help you?\n"
	SERVICES_OFFERED=$($PSQL "SELECT service_id, name FROM services")
	echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR NAME; do
		echo "$SERVICE_ID) $NAME"
	done
    # echo -e "\n "

	# Enter service choice
	read SERVICE_ID_SELECTED
	case $SERVICE_ID_SELECTED in
	1) ;;
	2) ;;
	3) ;;
	4) ;;
	*) MAIN_MENU "Please enter a valid option" ;;
	esac

	# Enter phone number
    echo -e "\nPlease enter your phone number."
	read CUSTOMER_PHONE

	# If phone number doesn't exist in database, enter name
	CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
	echo $CUSTOMER_NAME
	if [[ -z $CUSTOMER_NAME ]]; then
		echo -e "\nYour phone number was not found in our database, let's create your acccount. Please enter your name."
    read CUSTOMER_NAME

    # Insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")


	fi

	# Get service time
    echo -e "\nPlease enter the time you'd like the service for."
	read SERVICE_TIME
    
    # Insert appointment into database
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    # SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service='$SERVICE_ID_SELECTED'")
	INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

    # Get service name from database
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

    # Output confirmation message
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
