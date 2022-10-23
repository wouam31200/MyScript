{

printf "\033c"

echo ""
echo "********************************"
echo "!!!!!!!!!!!!! NOTICE !!!!!!!!!!!"
echo "********************************"
echo ""
echo "This part of the script will give the option to install Postfix instead of Sendmail. "
echo "Postifx is preferred as it produces better logs than Sendmail in case for the need to troubleshoot sending email issues. "
echo "During installation of postfix, it will require some manual configurations, but the defaults will be ready to select."
echo ""
echo "You will only need to press the enter key to continue for the two questions, HOWEVER, it is reccomended you have the server" 
echo "Fully Qualified Domain Name (FQDN)/hosname already set (e.g. server.myserver.com) before continuing beyond this point."
echo ""
echo "If you have not done so, the FQDN/hostname can be easily set, as an example, with the command: "
echo "hostnamectl set-hostname astpp.yourhostname.com"
echo ""
echo "You will have to reboot/relog to make sure changes have been made."
echo ""
echo "As an alternative, you can select 'n' to instead install Sendmail. No additonal configuration is needed for it."
echo ""



read -n 1 -p "Do you wish to continue with installation of Postfix? (y/n/q[uit]) "
                if [ "$REPLY"   = "y" ]; then

			echo ""
			echo "Now installing Postfix"
			echo ""
			apt -y install postfix
		elif [ "$REPLY"   = "n" ]; then
			echo ""
			echo "Now installing Sendmail"
			echo ""
			apt -y install sendmail
		elif [ "$REPLY"   = "q" ]; then
			echo ""
			echo "Exiting"
			echo ""
			exit 0

		fi

} #end of postfix
