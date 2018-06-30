#!/bin/bash

breaker () {
  vpd -i "RW_VPD" -s "check_enrollment"="0" &> /dev/null #Turn on FRE server ping
  vpd -i "RW_VPD" -s "block_devmode"="0" &> /dev/null #Turn off force devmode block
  vpd -d "stable_device_secret_DO_NOT_SHARE" &> /dev/null #Remove ID for FRE server
  dump_vpd_log --force &> /dev/null #Write changes to VPD
  crossystem clear_tpm_owner_request=1 #Clears TPM owner on reboot
}

while true; do

  echo -e "\e[31mBreaking Force Enrollment...\e[0m"
  
  breaker
  
  echo -e "\e[31mDone\e[0m"
  echo ""
  echo -e "\e[31mRebooting\e[0m"
  shutdown -r 0
  exit 0
  
done

