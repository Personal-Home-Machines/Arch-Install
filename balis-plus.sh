#!/bin/bash
#----------------------------------------------------------------
#      ____        ___             
#     / __ )____ _/ (_)____     __ 
#    / __  / __ `/ / / ___/  __/ /_
#   / /_/ / /_/ / / (__  )  /_  __/
#  /_____/\__,_/_/_/____/    /_/   
#
#----------------------------------------------------------------
#  License : MIT
#  Author  : Nikolay Bushilo 
#  URL     : COMING SOON 
#  Info    : An extra script for a complete install for PHM
#----------------------------------------------------------------
#  Index:
#   1. Functions................................................
#   2. Sanity Check.............................................
#   3. Installing AUR helper....................................
#   4. Installing packages......................................
#   5. Important stuff..........................................
#   6. Configuring Network......................................
#   7. Setting user and root....................................
#   8. Installing packages......................................
#   9. Setting up Grub..........................................
#  10. Services.................................................
#----------------------------------------------------------------

#----------------------------------------------------------------
# 1. Functions
#----------------------------------------------------------------

Confirmation_prompt()
{

	read -p "Do you wish to continue? [y/N] : " -n 1 -r
	echo  
	
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		
		echo -e "\n\e[0;31mWarning! things may break if you insist, beware brave soul!\e[0m"
		sleep 3
		
	else
	
		exit
		
	fi
}


# Print out the banner
echo -e "\n\n\033[1;33m				 ___   ____    ___ \n				 _  |   |  |      |\n				  __|      |  | | | \n			       __|    __|__| _|_|_|   \n\n\n\n		(P)ersonal (H)ome (M)achines 2022.01.27 - ver.1\033[0m\n-------------------------------------------------------------------------------\n    An Arch install script for Personal use. You are currently running BALIS+\n    the EXTRA script for a complete install.\n\n    WARNING: *I* do not guarantee the delivery of this product and strongly\n    recommend to change the config file to suit your needs.\n-------------------------------------------------------------------------------\n\n\n\n\n"


# STARTING SETUP
echo -e "\n\033[0;35mStarting setup...\033[0m\n"


#----------------------------------------------------------------
# 2. Sanity Check
#----------------------------------------------------------------
echo -e "\n\033[1;32mRunning sanity check...\033[0m"

echo "Checking BALIS execution"
[ ! -f Executed.txt ] && echo -e "\033[0;31mBALIS.sh was not executed before, please do the base install first !\033[0m" && Confirmation_prompt

echo "Checking pkgs-plus file"
[ ! -f pkgs-plus.txt ] && echo -e "\033[0;31mMissing pkgs-plus.txt file\033[0m" && Confirmation_prompt

echo "Sourcing Executed.txt"
source Executed.txt

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 3. Installing AUR helper
#----------------------------------------------------------------
echo -e "\n\033[1;32mInstalling AUR helper...\033[0m"

cd ~
echo "Installing packages"
pacman -S --needed --noconfirm --noprogressbar --quiet base-devel

echo "Cloning yay into the home directory"
git clone "https://aur.archlinux.org/yay.git"

cd ~/yay

echo "Building yay"
# arch-chroot /mnt /usr/bin/runuser -u $user -- /Arch-Install/build-yay.sh
makepkg -si --noconfirm

cd ~

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 4. Installing packages
#----------------------------------------------------------------
echo -e "\n\033[1;32mInstalling packages...\033[0m"

echo "Grabbing pkgs (this may take a while)"
yay -S --noconfirm --needed --noprogressbar - < /Arch-Install/pkgs-plus.txt

echo "Done..!"

