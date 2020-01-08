#!/bin/bash

set -o errexit

MY_YESNO_PROMPT='[Y/n] $ '

# version of the software
MAJOR_VERSION=1
MINOR_VERSION=7
RELEASE_TYPE=0
RELEASE_BUILD=6
INFORMATIONAL_VERSION=1.7.0.6
RELEASE_TYPE_TEXT=Release

# Web page links
REGISTER_PAGE='http://www.ptgrey.com/support/softwarereg.asp?text=ProductName+Linux+Spinnaker+$MAJOR_VERSION%2E$MINOR_VERSION+$RELEASE_TYPE_TEXT+$RELEASE_BUILD+%0D%0AProductVersion+$MAJOR_VERSION%2E$MINOR_VERSION%2E$RELEASE_TYPE%2E$RELEASE_BUILD%0D%0A'
FEEDBACK_PAGE='https://www.flir.com/spinnaker/survey'

echo "This is a script to assist with installation of the Spinnaker SDK."
echo "Would you like to continue and install all the Spinnaker SDK packages?"
echo -n "$MY_YESNO_PROMPT"
read confirm
if ! ( [ "$confirm" = "y" ] || [ "$confirm" = "Y" ] || [ "$confirm" = "yes" ] || [ "$confirm" = "Yes" ] || [ "$confirm" = "" ] )
then
    exit 0
fi

echo
echo "Installing Spinnaker packages..."

sudo dpkg -i libspinnaker-*.deb
sudo dpkg -i libspinvideo-*.deb
sudo dpkg -i spinview-qt-*.deb
sudo dpkg -i spinupdate-*.deb
sudo dpkg -i spinnaker-*.deb

echo
echo "Would you like to add a udev entry to allow access to USB hardware?"
echo "If this is not ran then your cameras may be only accessible by running Spinnaker as sudo."
echo -n "$MY_YESNO_PROMPT"
read confirm
if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ] || [ "$confirm" = "yes" ] || [ "$confirm" = "Yes" ] || [ "$confirm" = "" ]
then
    echo "Launching udev configuration script..."
    sudo sh configure_spinnaker.sh
fi

echo
echo "Installation complete."
echo "Would you like to register the installed software?"
echo -n "$MY_YESNO_PROMPT"
read confirm
if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ] || [ "$confirm" = "yes" ] || [ "$confirm" = "Yes" ] || [ "$confirm" = "" ]
then
    # Notify server of a linux installation
    wget -T 10 -q --spider $REGISTER_PAGE &
fi

# Prepare for launching web browser
set +o errexit
has_display=$(xterm -iconic -e echo test 2> /dev/null && echo "ok")
if [ -n "$has_display" ]
then
    feedback=true
else
    feedback=false
fi
set -o errexit

# Script could be run as sudo. Find the actual user name.
if [ $(id -u) -eq 0 ]
then
    gpid=$(ps --no-heading -o ppid -p $PPID)
    supid=$(ps --no-heading -o ppid -p $gpid)
    user=$(ps --no-heading -o user -p $supid)
    if [ -z "$user" ] || [ "$user" = "root" ]
    then
        feedback=false
    fi
fi

if [ "$feedback" = true ]
then
    echo "Would you like to make a difference by participating in the Spinnaker feedback program?"
    echo -n "$MY_YESNO_PROMPT"
    read confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ] || [ "$confirm" = "yes" ] || [ "$confirm" = "Yes" ] || [ "$confirm" = "" ]
    then
        if [ $(id -u) -ne 0 ]
        then
            xdg-open $FEEDBACK_PAGE 2> /dev/null
        else
            su $user xdg-open $FEEDBACK_PAGE 2> /dev/null
        fi
    else
        echo "Join the feedback program anytime at \"$FEEDBACK_PAGE\"!"
    fi
else
    echo "Make a difference by participating in the Spinnaker feedback program at \"$FEEDBACK_PAGE\"!"
fi

echo "Thank you for installing Spinnaker SDK."
exit 0
