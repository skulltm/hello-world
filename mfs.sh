#!/bin/bash

# VERSION 1.1

# Variables
hi="Hi, this is a test application/script that will be used in the continuous integration pipeline process, so it does nothing more than just an option selection."
so="Please, select an option:"
one="1 You are ugly"
two="2 You are beautiful"
three="3 You are both"

greetings() {
echo $hi
echo $so
echo $one
echo $two
echo $three
read $* -p "Your choice: " ch
if [[ "${ch}" = "1" ]]; then
        echo "Ha Ha!"
        return 0
        second;
elif [[ "${ch}" = "2" ]]; then
        optTwo;
        return 0
        second;
elif [[ "${ch}" = "3" ]]; then
        optThree;
        return 1
        second;
else
        echo "Incorrect choice"
        return 1
        second;
fi
}

optTwo() {
echo "Sorry, only ugly people can start this script and since you are an outsider and beautiful, I have no choice but to kick you off.."
return 0
}

optThree() {
echo "You can't be both?!"
return 1
}

greetings;

second() {
if ! greetings; then
        echo "Error: bye"
        exit 1
else
        echo "Success: bye"
        exit 0
fi
}
