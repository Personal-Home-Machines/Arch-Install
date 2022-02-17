#!/bin/bash
#----------------------------------------------------------------
#      ___              __       ____           __        ____   
#     /   |  __________/ /_     /  _/___  _____/ /_____ _/ / /   
#    / /| | / ___/ ___/ __ \    / // __ \/ ___/ __/ __ `/ / /    
#   / ___ |/ /  / /__/ / / /  _/ // / / (__  ) /_/ /_/ / / /     
#  /_/  |_/_/   \___/_/ /_/  /___/_/ /_/____/\__/\__,_/_/_/      
#
#----------------------------------------------------------------
#  License : MIT
#  Author  : Nikolay Bushilo 
#  URL     : COMING SOON 
#  Info    : The main script for PHM
#----------------------------------------------------------------	

                                                              

read -p "Do you wish to you BALIS + in addition to the base install ? [Y/n] : " -n 1 -r
echo  
  
if [[ $REPLY =~ ^[Nn]$ ]]; then
		
    arch-chroot /mnt /root/Arch-Install/balis.sh
		
else
	
    arch-chroot /mnt /root/Arch-Install/balis.sh
    source Executed.txt
    arch-chroot /mnt /usr/bin/runuser -u $user -- /root/Arch-Install/balis-plus.sh
		
fi
