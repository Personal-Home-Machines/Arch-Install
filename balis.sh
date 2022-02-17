#!/bin/bash
#----------------------------------------------------------------
#      ____        ___     
#     / __ )____ _/ (_)____
#    / __  / __ `/ / / ___/
#   / /_/ / /_/ / / (__  ) 
#  /_____/\__,_/_/_/____/  
#
#----------------------------------------------------------------
#  License : MIT
#  Author  : Nikolay Bushilo 
#  URL     : COMING SOON 
#  Info    : The basic arch linux install script for PHM
#----------------------------------------------------------------
#  Index:
#   1. Functions................................................
#   2. Initial User Prompts.....................................
#   3. Sanity Check.............................................
#   4. Mirrors..................................................
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

# Below is a list of all of the things you may want to modify
REGION='EUROPE' 
CITY='PARIS'
LANG='en_GB.UTF-8' # Set your locale here
LANG2='fr_FR.UTF-8' # Used to specify monetary value
efi_path='/boot/efi'

# Creating variables
root_password='' # Do not enter your information here they will be overwritten
user_password='' # Do not enter your information here they will be overwritten
country_iso=$(curl -s4 ifconfig.co/country-iso)
proc_type=$(lscpu)
gpu_type=$(lspci)

# A function that deals with the password prompt, takes in argument the variable that it assignes the output to
# For example, the password was 'safepassword' :
# >>> ARG=''
# >>> echo "$ARG"
# >>>
# >>> Password_double_check ARG
# >>> echo "$ARG"
# >>> safepassword
Password_double_check() 
{
	while true; 
  
		do 
  
			# Prompt for the password and save into 'password'
			read -s -p "Password: " password 
			echo
			
			# Prompt for the password and save into 'password2'
			read -s -p "Password (again): " password2 
			echo 
			
			# this line does a few things: 
			   # (1) Check if the 2 passwords match
			   # (2) IF TRUE: assign the first argument ($1) the 'password' and break the loop
			   # (3) ELSE   : print out 'Please try again!'
			   
			[ "$password" = "$password2" ] && eval "$1=$password" && break || echo "Please try again!"
   
		done
}


# Installs packages from the *pkgs.txt* file
Installing_pkgs()
{
	cat /PHM/pkgs.txt | while read line 
	
	do
	
		pacman -S --noconfirm --needed --noprogressbar --quiet ${line}
		
	done
}


# Installs fonts from the *fonts.txt* file
Installing_fonts()
{
	cat /PHM/fonts.txt | while read line 
	
	do
	
   		pacman -S --noconfirm --needed --noprogressbar --quiet ${line}
		
	done
}


Installing_Microcode()
{

	if grep -E "GenuineIntel" <<< ${proc_type}; then
	
	    	echo "Installing Intel microcode"
	    	pacman -S --noprogressbar --noconfirm intel-ucode
	    	proc_ucode=intel-ucode.img
	    
	elif grep -E "AuthenticAMD" <<< ${proc_type}; then
	
	    	echo "Installing AMD microcode"
	    	pacman -S --noprogressbar --noconfirm amd-ucode
	    	proc_ucode=amd-ucode.img
	    
	fi

}


Installing_Graphics_Drivers()
{

	if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
	
    		pacman -S nvidia --noconfirm --needed --noprogressbar
		nvidia-xconfig
	
	elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
	
		pacman -S xf86-video-amdgpu --noconfirm --needed --noprogressbar
	    
	elif grep -E "Integrated Graphics Controller" <<< ${gpu_type}; then
	
	    pacman -S --noprogressbar libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa --needed --noconfirm
	    
	elif grep -E "Intel Corporation UHD" <<< ${gpu_type}; then
	
	    pacman -S --noprogressbar libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa --needed --noconfirm
	    
	fi

}


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


Create_keymap()
{
	
	if [[ "$1" == "--nokeymap" ]]; then

		echo "Skipping custom keymap creation"
		
	else
	 
		echo "Creating custom keymap to swap Caps with Esc"
		cp /PHM/swap-capslock-with-escape.map /usr/share/kbd/keymaps/
		echo "KEYMAP=swap-capslock-with-escape.map" >> /etc/vconsole.conf

	fi

}


#----------------------------------------------------------------
# 2. Initial User Prompts
#----------------------------------------------------------------

# Print out the banner
echo -e "\n\n\033[1;33m				 ___   ____    ___ \n				 _  |   |  |      |\n				  __|      |  | | | \n			       __|    __|__| _|_|_|   \n\n\n\n		(P)ersonal (H)ome (M)achines 2022.01.27 - ver.1\033[0m\n-------------------------------------------------------------------------------\n	An Arch install script for Personal use.\n	WARNING: *I* do not guarantee the delivery of this product and strongly\n	recommend to change the config file to suit your needs.\n-------------------------------------------------------------------------------\n\n\n\n\n"

# Root password prompt
echo -e "\033[0;35mConfigure root password\033[0m"
Password_double_check root_password
echo "Done..!"

# User prompt
echo -e "\033[0;35mConfigure user\033[0m"
read -p "Enter new user: " user
Password_double_check user_password
echo "Done..!"

# Hostname prompt
echo -e "\033[0;35mConfigure hostname\033[0m"
read -p "hostname: " hostname
echo "Done..!"


# STARTING SETUP
echo -e "\n\033[0;35mStarting setup...\033[0m\n"

#----------------------------------------------------------------
# 3. Sanity Check
#----------------------------------------------------------------
echo -e "\n\033[1;32mRunning sanity check...\033[0m"

echo "Checking pkgs file"
[ ! -f pkgs.txt ] && echo -e "\033[0;31mMissing pkgs.txt file\033[0m" && Confirmation_prompt

echo "Checking fonts file"
[ ! -f fonts.txt ] && echo -e "\033[0;31mMissing fonts.txt file\033[0m" && Confirmation_prompt

echo "Checking keymap"
[ ! -f swap-capslock-with-escape.map ] && echo -e "\033[0;31mMissing keymap file\033[0m" && Confirmation_prompt

echo "Checking variables"
[ -z "$country_iso" ] && echo -e "\033[0;31mEmpty country_iso, configure manualy in balis.sh\033[0m" && Confirmation_prompt
[ -z "$LANG" ] && echo -e "\033[0;31mEmpty LANG variable\033[0m" && Confirmation_prompt
[ -z "$LANG2" ] && echo -e "\033[0;31mEmpty LANG2 variable\033[0m" && Confirmation_prompt
[ -z "$efi_path" ] && echo -e "\033[0;31mEmpty efi_path variable\033[0m" && Confirmation_prompt
[ -z "$proc_type" ] && echo -e "\033[0;31mEmpty efi_path variable\033[0m" && Confirmation_prompt
[ -z "$gpu_type" ] && echo -e "\033[0;31mEmpty efi_path variable\033[0m" && Confirmation_prompt
[ -z "$REGION" ] && echo -e "\033[0;31mPlease define a region for locales\033[0m" && Confirmation_prompt
[ -z "$CITY" ] && echo -e "\033[0;31mPlease define a city for locales\033[0m" && Confirmation_prompt
[ -z "$root_password" ] && echo -e "\033[0;31mEmpty root password\033[0m" && Confirmation_prompt 
[ -z "$user" ] && echo -e "\033[0;31mEmpty user\033[0m" && Confirmation_prompt
[ -z "$user_password" ] && echo -e "\033[0;31mEmpty root password\033[0m" && Confirmation_prompt 
[ -z "$hostname" ] && echo -e "\033[0;31mEmpty hostname\033[0m" && Confirmation_prompt

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 4. Optimizing downloads
#----------------------------------------------------------------
echo -e "\n\033[1;32mOptimizing downloads...\033[0m"

echo "Refreshing repos"
pacman -Syy --noprogressbar --noconfirm

echo "Installing utililties"
pacman -S --noprogressbar --noconfirm --needed --quiet reflector rsync curl

echo "Setting parallel downloads"
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

echo "Enabling multilib"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
pacman -Syy --noconfirm

echo "Creating mirrorlist backup"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

echo "Configuring mirrors"
reflector -a 48 -c ${country_iso,,} -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
mkdir /mnt &>/dev/null # Hiding error message if any

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 5. Important stuff
#----------------------------------------------------------------
echo -e "\n\033[1;32mConfiguring important stuff...\033[0m"

echo "Updating the system clock"
timedatectl set-ntp true

echo "Setting the time zone"
ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime

echo "Syncing the clock"
hwclock --systohc

echo "Setting locales"
sed -i 's/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen

echo "Generating locales"
locale-gen

echo "Setting languages"
echo "LANG=$LANG" >> /etc/locale.conf # Setting languages
echo "LC_MONETARY=$LANG2" >> /etc/locale.conf # Setting languages

# Keymap creation (or not)
Create_keymap $1 # '$1' is the script first argument

echo "Checking processor type"
Installing_Microcode

echo "Checking for compatible graphics drivers"
Installing_Graphics_Drivers

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 6. Configuring Network
#----------------------------------------------------------------
echo -e "\n\033[1;32mConfiguring Network...\033[0m"

echo "Setting the hostname" 
echo "$hostname" >> /etc/hostname

echo "Setting local hostname resolution"
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo '127.0.1.1 "$hostname".localdomain "$hostname"' >> /etc/hosts

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 7. Setting user and root
#----------------------------------------------------------------
echo -e "\n\033[1;32mSetting user and root...\033[0m"
echo "Installing necessary packages"
pacman -S --noprogressbar --noconfirm --needed --quiet sudo
echo root:$root_password | chpasswd
echo "Changed root password"

echo "Creating user"
useradd -m "$user"

echo "Setting user password"
echo $user:$user_password | chpasswd

echo "Adding user to wheel group"
usermod -aG wheel,audio,video,optical,storage "$user"

echo "Setting user privileges"
echo "$user ALL=(ALL) ALL" >> /etc/sudoers.d/"$user"

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 8. Installing packages
#----------------------------------------------------------------
echo -e "\n\033[1;32mInstalling packages...\033[0m"

echo "Refreshing repos"
pacman -Syy --quiet --noconfirm --noprogressbar

echo "Grabbing pkgs (this may take a while)"
Installing_pkgs 
# Spinner

echo "Grabbing fonts (this may takea while)"
Installing_fonts 

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 9. Setting up Grub
#----------------------------------------------------------------
echo -e "\n\033[1;32mSetting up Grub...\033[0m"


grub-install --target=x86_64-efi --efi-directory=$efi_path --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Done..!"

sleep 3

#----------------------------------------------------------------
# 10. Services
#----------------------------------------------------------------
echo -e "\n\033[1;32mSetting up Daemons...\033[0m"


systemctl enable NetworkManager
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

echo "Done..!"

sleep 3

echo 'balis=true' >> Executed.txt
echo 'user=$user' >> Executed.txt

arch-chroot /mnt /usr/bin/runuser -u $user -- /root/Arch-Install/balis-plus.sh

echo -e "\n\e[0;31mFinished! Type exit, take out the install device and reboot.\e[0m"


