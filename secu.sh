#General Congifuration
TEMP_USER_ANSWER="no"
#ASTPP_SOURCE_DIR=/opt/ASTPP
HOST_DOMAIN_NAME="host.domain.tld"
os_codename=$(lsb_release -cs)

install_postfix ()

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

} #end of install_postfix


#Install Monit for service monitoring
install_monit ()
{


#Monit is not is Buster Backports

apt install -t buster-backports monit -y 

read -p "Enter a Notification email address for sytem monitor: ${EMAIL}"

if [ ."$os_codename" = ."buster" ]; then
apt-get -y install monit
sed -i -e 's/# set mailserver mail.bar.baz,/set mailserver localhost/g' /etc/monit/monitrc
sed -i -e '/# set mail-format { from: monit@foo.bar }/a set alert '$EMAIL/etc/monit/monitrc
sed -i -e 's/##   subject: monit alert on --  $EVENT $SERVICE/   subject: monit alert --  $EVENT $SERVICE/g' /etc/monit/monitrc
sed -i -e 's/##   subject: monit alert --  $EVENT $SERVICE/   subject: monit alert on '${INTF}' --  $EVENT $SERVICE/g' /etc/monit/monitrc
sed -i -e 's/## set mail-format {/set mail-format {/g' /etc/monit/monitrc
sed -i -e 's/## }/ }/g' /etc/monit/monitrc
echo '
#------------MySQL
check process mysqld with pidfile /var/run/mysqld/mysqld.pid
    start program = "/bin/systemctl start mariadb"
    stop program = "/bin/systemctl stop mariadb"
if failed host 127.0.0.1 port 3306 then restart
if 5 restarts within 5 cycles then timeout
#------------Fail2ban
check process fail2ban with pidfile /var/run/fail2ban/fail2ban.pid
    start program = "/bin/systemctl start fail2ban"
    stop program = "/bin/systemctl stop fail2ban"
# ---- FreeSWITCH ----
check process freeswitch with pidfile /var/run/freeswitch/freeswitch.pid
    start program = "/bin/systemctl start freeswitch"
    stop program  = "/bin/systemctl stop freeswitch"
#-------nginx----------------------
check process nginx with pidfile /var/run/nginx.pid
    start program = "/bin/systemctl start nginx" with timeout 30 seconds
    stop program  = "/bin/systemctl stop nginx"
#-------php-fpm----------------------
check process php7.3-fpm with pidfile /var/run/php/php7.3-fpm.pid
    start program = "/bin/systemctl start php7.3-fpm" with timeout 30 seconds
    stop program  = "/bin/systemctl stop php7.3-fpm"
#--------system
check system localhost
    if loadavg (5min) > 8 for 4 cycles then alert
    if loadavg (15min) > 8 for 4 cycles then alert
    if memory usage > 80% for 4 cycles then alert
    if swap usage > 20% for 4 cycles then alert
    if cpu usage (user) > 80% for 4 cycles then alert
    if cpu usage (system) > 20% for 4 cycles then alert
    if cpu usage (wait) > 20% for 4 cycles then alert
check filesystem "root" with path /
    if space usage > 80% for 1 cycles then alert' >> /etc/monit/monitrc

systemctl restart monit
systemctl enable monit


elif [ ."$os_codename" = ."bullseye" ]; then
apt-get -y install monit
sed -i -e 's/# set mailserver mail.bar.baz,/set mailserver localhost/g' /etc/monit/monitrc
sed -i -e '/# set mail-format { from: monit@foo.bar }/a set alert '$EMAIL /etc/monit/monitrc
sed -i -e 's/##   subject: monit alert on --  $EVENT $SERVICE/   subject: monit alert --  $EVENT $SERVICE/g' /etc/monit/monitrc
sed -i -e 's/##   subject: monit alert --  $EVENT $SERVICE/   subject: monit alert on '${INTF}' --  $EVENT $SERVICE/g' /etc/monit/monitrc
sed -i -e 's/## set mail-format {/set mail-format {/g' /etc/monit/monitrc
sed -i -e 's/## }/ }/g' /etc/monit/monitrc
echo '
#------------MySQL
check process mysqld with pidfile /var/run/mysqld/mysqld.pid
    start program = "/bin/systemctl start mariadb"
    stop program = "/bin/systemctl stop mariadb"
if failed host 127.0.0.1 port 3306 then restart
if 5 restarts within 5 cycles then timeout
#------------Fail2ban
check process fail2ban with pidfile /var/run/fail2ban/fail2ban.pid
    start program = "/bin/systemctl start fail2ban"
    stop program = "/bin/systemctl stop fail2ban"
# ---- FreeSWITCH ----
check process freeswitch with pidfile /var/run/freeswitch/freeswitch.pid
    start program = "/bin/systemctl start freeswitch"
    stop program  = "/bin/systemctl stop freeswitch"
#-------nginx----------------------
check process nginx with pidfile /var/run/nginx.pid
    start program = "/bin/systemctl start nginx" with timeout 30 seconds
    stop program  = "/bin/systemctl stop nginx"
#-------php-fpm----------------------
check process php7.4-fpm with pidfile /var/run/php/php7.4-fpm.pid
    start program = "/bin/systemctl start php7.4-fpm" with timeout 30 seconds
    stop program  = "/bin/systemctl stop php7.4-fpm"
#--------system
check system localhost
    if loadavg (5min) > 8 for 4 cycles then alert
    if loadavg (15min) > 8 for 4 cycles then alert
    if memory usage > 80% for 4 cycles then alert
    if swap usage > 20% for 4 cycles then alert
    if cpu usage (user) > 80% for 4 cycles then alert
    if cpu usage (system) > 20% for 4 cycles then alert
    if cpu usage (wait) > 20% for 4 cycles then alert
check filesystem "root" with path /
    if space usage > 80% for 1 cycles then alert' >> /etc/monit/monitrc


systemctl restart monit
systemctl enable monit

fi



} #End of Monit
