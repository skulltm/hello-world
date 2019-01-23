#!/bin/bash

# A quick explanation what this script is meant for:
# The user has 3 ways to proceed in this script:
# 1. Create a story, whose title corresponds on the file name of the story, after which the user is asked if he would like to start writing a story right away.
# 2. Check if a unix service is running or not. If it is not, the script will automatically try to start it up (if the service exists), and if the script is not able to bring it up error log will be saved under /etc/<NAMEOFSERVICE>log.
# By the way, this script is 16+ - no end user under that age can access it (and do not try if you are over 150 as well).

# Script's entry point starts from the very bottom of this file.
# Author: Martin



# Variables:

op1="Submit 1 to create a story and save it into a file."
op2="Submit 2 to check whether a certain service is currently running or not."
op3="Submit 3 to terminate."
fifteen=15
sixteen=16
crazyage=150



# Functions to be executed after an option has been chosen:

optionOne() {
read $* -p "Title of the story: " title
if [[ ! "${title}" ]]; then
        echo You cannot create a story without giving it a name.
        optionOne;
fi
if [[ ! -f /etc/stories/"${title}" ]]; then
        if touch /etc/stories/"${title}" >/dev/null 2>&1; then
                read -p "The story has been saved, would you like to open it in a text editor (y/n): " openit
                if [[ $openit = "y" ]]; then
                        nano /etc/stories/"${title}"
                        echo Great! So, here we are:
                        echo Story name: "${title}"
                        echo Story created on: $(date)
                        echo Last edited on: $(date)
                        echo Saved in: /etc/stories/"${title}"
                        echo Owner of "${title}" is: "${USER}" who is "${old}" years old
                        greetings;
                elif [[ $openit = "n" ]]; then
                        echo "You can open and start writing your story anytime, it is saved under /etc/stories/${title}."
                        greetings;
                else
                        echo "Unknown answer, next time please use y OR n only. You can find your empty story in /etc/stories/${title}."
                        greetings;
                fi
        else
                echo "An unknown error occured, please try again."
                greetings;
        fi
else
        echo "Unable to create ${title} under /etc/stories/, perhaps a story with the same name already exists?"
        greetings;
fi
}

optionTwo() {
read $* -p "Which service do you want to check: " nameofservice
echo Checking..
isRunningService;
if isRunningService; then
        echo Service "${nameofservice}" is up and running!
        greetings;
else
        echo Could not find "${nameofservice}" in the active services list.
        echo Trying to start "${nameofservice}"..
        startAService;
fi
}

optionThree() {
echo "Bye, $USER."
exit 0
}

greetings() {
echo What would you like to do, ${USER}:
echo $op1
echo $op2
echo $op3
read -p "I am choosing: " optionChosen
theChosenOption;
}

theChosenOption() {
if [[ $optionChosen = "1" ]]; then
        optionOne;
elif [[ $optionChosen = "2" ]]; then
        optionTwo;
elif [[ $optionChosen = "3" ]]; then
        optionThree;
else
        echo "Unknown answer."
        optionThree;
fi
}

isRunningService() {
if [[ $(systemctl is-active ${nameofservice}) = "active" ]]; then
        return 0
else
        return 1
fi
}

startAService() {
systemctl start ${nameofservice} >/dev/null 2>&1
sleep 3
isRunningService;
if isRunningService; then
        echo "${nameofservice}" is now up and running!
        greetings;
else
        echo There was a problem while trying to bring up "${nameofservice}". Log file saved in /etc/${nameofservice}log.
        journalctl -xe > /etc/${nameofservice}log
        read -p "Do you want to try again (y/n): " tryagain
                if [[ $tryagain = "y" ]]; then
                        startAService;
                elif [[ $tryagain = "n" ]]; then
                        greetings;
                else
                        echo "Unknown answer, next time please use y OR n only."
                        greetings;
                fi
fi
}

initial() {
read -p "Hello, $USER. I hope you have been doing great today! May I know, how old are you: " old
if [[ $old -ge $crazyage ]]; then
        echo "What the.. ${old} .. ??????"
        echo "Sorry, but my instincts tell me that you are not a human being, but something that I should not talk to. Nobody has ever lived so many years.. Jeez! ${old} ??"
        optionThree;
elif [[ $old -ge $sixteen ]]; then
        greetings;
elif [[ $old -le $fifteen ]]; then
        echo "Sorry, but you are not enough old to go further, ${USER}. Bye, bye."
        optionThree;
else
        echo "${old} is not a known age."
        optionThree;
fi
}



# Script's entry point is here.

if mkdir /etc/stories >/dev/null 2>&1; then
        echo "Stories folder that will be used as default location to save stories inside has been created in /etc/stories"
else
        echo "Stories folder already exists under /etc/stories, so a new folder will not be created."
fi
initial;