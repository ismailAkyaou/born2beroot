## Definitions

**Virtual Machine:**

A virtual machine is a software that is capable of running operating systems (aka guest machines) by using virtual hardware. That is made possible because the entire thing is hosted on a physical machine (aka host machine) that provides hardware resources for the VM. The software responsible for creating VMs is called **the hypervisor**. **The hypervisor** is responsible for isolating and managing (a middleware between the virtual and the physical world) the VM’s resources from the system hardware alas providing a closed sandbox for the VM that can mess with it without affecting the rest of the system, this is pretty convenient for testing malicious and or unstable softwares.

**LVM (Logical Volume Manager):**

LVM is an abstraction layer between a storage device and a file system. LVM provides a flexible experience while managing partitions (aka Logical Volume).

**Physical Volume (PV):** physical storage device.

**Volume Group (VG):** Partition group.

**Logical volume (LV):** Volume Group’s partitions.

**AppArmor (Application Armor):**

AppArmor provides a Mandatory Access System. MAS gives the system administration the ability to restrict the behavior that processes can perform.

**APT (Advanced Packaging Tool) vs Aptitude:**

APT is a CLI (Command Line Tool) tool that helps installing packages along with their dependencies. Aptitude on the other hand offers a GUI (Graphical User Interface) along with even more control over the package's dependencies.

**SSH (Secure Shell):**

SSH is a remote administration protocol that allows users to remotely control their machines over the internet.

**UFW (Uncomplicated Firewall):**

Provides to the system administration a simple way to manage the firewall without compromising security.

**Cron:**

A Linux task manager that allows scheduling running commands.

**Wall:**

A command that allows the system administration to send alerts to all the connected users.

**Port:**

A port is a gateway where connection can pass through for a specific service.

**Firewall:**

In computing, a firewall is a network security system that monitors and controls incoming and outgoing network traffic based on predetermined security rules.

## Installation

At the time of writing, the latest stable version of [Debian](https://www.debian.org/) is *Debian 10 Buster*. Watch *bonus* installation walkthrough *(no audio)* [here](https://youtu.be/2w-2MX5QrQw).

## *sudo*

### Step 1: Installing *sudo*

Switch to *root* and its environment via `su -`.

```
$ su -
Password:
#
```

Install *sudo* via `apt install sudo`.

```
# apt install sudo
```

Verify whether *sudo* was successfully installed via `dpkg -l | grep sudo`.

```
# dpkg -l | grep sudo
```

### Step 2: Adding User to *sudo* Group

Add user to *sudo* group via `adduser <username> sudo`.

```
# adduser <username> sudo
```

> Alternatively, add user to sudo group via usermod -aG sudo <username>.
> 
> 
> ```
> # usermod -aG sudo <username>
> ```
> 
> Verify whether user was successfully added to *sudo* group via `getent group sudo`.
> 

```
$ getent group sudo
```

`reboot` for changes to take effect, then log in and verify *sudopowers* via `sudo -v`.

```
# reboot
<--->
Debian GNU/Linux 10 <hostname> tty1

<hostname> login: <username>
Password: <password>
<--->
$ sudo -v
[sudo] password for <username>: <password>
```

### Step 3: Running *root*Privileged Commands

From here on out, run *root*-privileged commands via prefix `sudo`. For instance:

```
$ sudo apt update
```

### Step 4: Configuring *sudo*

Configure *sudo* via `sudo vi /etc/sudoers.d/<filename>`. `<filename>` shall not end in `~` or contain `.`.

```
$ sudo vi /etc/sudoers.d/<filename>
```

To limit authentication using *sudo* to 3 attempts *(defaults to 3 anyway)* in the event of an incorrect password, add below line to the file.

```
Defaults        passwd_tries=3
```

To add a custom error message in the event of an incorrect password:

```
Defaults        badpass_message="<custom-error-message>"
```

###
To log all *sudo* commands to `/var/log/sudo/<filename>`:

```
$ sudo mkdir /var/log/sudo
<~~~>
Defaults        logfile="/var/log/sudo/<filename>"
<~~~>
```

To archive all *sudo* inputs & outputs to `/var/log/sudo/`:

```
Defaults        log_input,log_output
Defaults        iolog_dir="/var/log/sudo"
```

To require *TTY*:

```
Defaults        requiretty
```

To set *sudo* paths to `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin`:

```
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
```

## SSH

### Step 1: Installing & Configuring SSH

Install *openssh-server* via `sudo apt install openssh-server`.

```
$ sudo apt install openssh-server
```

Verify whether *openssh-server* was successfully installed via `dpkg -l | grep ssh`.

```
$ dpkg -l | grep ssh
```

Configure SSH via `sudo vi /etc/ssh/sshd_config`.

```
$ sudo vi /etc/ssh/sshd_config
```

To set up SSH using Port 4242, replace below line:

```
13 #Port 22
```

with:

```
13 Port 4242
```

To disable SSH login as *root* irregardless of authentication mechanism, replace below line

```
32 #PermitRootLogin prohibit-password
```

with:

```
32 PermitRootLogin no
```

Check SSH status via `sudo service ssh status`.

```
$ sudo service ssh status
```

> Alternatively, check SSH status via systemctl status ssh.
> 
> 
> ```
> $ systemctl status ssh
> ```
> 

### Step 2: Installing & Configuring UFW

Install *ufw* via `sudo apt install ufw`.

```
$ sudo apt install ufw
```

Verify whether *ufw* was successfully installed via `dpkg -l | grep ufw`.

```
$ dpkg -l | grep ufw
```

Enable Firewall via `sudo ufw enable`.

```
$ sudo ufw enable
```

Allow incoming connections using Port 4242 via `sudo ufw allow 4242`.

```
$ sudo ufw allow 4242
```

Check UFW status via `sudo ufw status`.

```
$ sudo ufw status
```

### Step 3: Connecting to Server via SSH

SSH into your virtual machine using Port 4242 via `ssh <username>@<ip-address> -p 4242`.

```
$ ssh <username>@<ip-address> -p 4242
```

Terminate SSH session at any time via `logout`.

```
$ logout
```

> Alternatively, terminate SSH session via exit.
> 
> 
> ```
> $ exit
> ```
> 

## User Management

### Step 1: Setting Up a Strong Password Policy

### Password Age

Configure password age policy via `sudo vi /etc/login.defs`.

```
$ sudo vi /etc/login.defs
```

To set password to expire every 30 days, replace below line

```
160 PASS_MAX_DAYS   99999
```

with:

```
160 PASS_MAX_DAYS   30
```

To set minimum number of days between password changes to 2 days, replace below line

```
161 PASS_MIN_DAYS   0
```

with:

```
161 PASS_MIN_DAYS   2
```

To send user a warning message 7 days *(defaults to 7 anyway)* before password expiry, keep below line as is.

```
162 PASS_WARN_AGE   7
```

### Password Strength

Secondly, to set up policies in relation to password strength, install the *libpam-pwquality* package.

```
$ sudo apt install libpam-pwquality
```

Verify whether *libpam-pwquality* was successfully installed via `dpkg -l | grep libpam-pwquality`.

```
$ dpkg -l | grep libpam-pwquality
```

Configure password strength policy via `sudo vi /etc/pam.d/common-password`, specifically the below line:

```
$ sudo vi /etc/pam.d/common-password
<~~~>
25 password        requisite                       pam_pwquality.so retry=3
<~~~>
```

To set password minimum length to 10 characters, add below option to the above line.

```
minlen=10
```

To require password to contain at least an uppercase character and a numeric character:

```
ucredit=-1 dcredit=-1
```

To set a maximum of 3 consecutive identical characters:

```
maxrepeat=3
```

To reject the password if it contains `<username>` in some form:

```
reject_username
```

To set the number of changes required in the new password from the old password to 7:

```
difok=7
```

To implement the same policy on *root*:

```
enforce_for_root
```

Finally, it should look like the below:

```
password        requisite                       pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username difok=7 enforce_for_root
```

### Step 2: Creating a New User

Create new user via `sudo adduser <username>`.

```
$ sudo adduser <username>
```

Verify whether user was successfully created via `getent passwd <username>`.

```
$ getent passwd <username>
```

Verify newly-created user's password expiry information via `sudo chage -l <username>`.

```
$ sudo chage -l <username>
Last password change                    : <last-password-change-date>
Password expires                    : <last-password-change-date + PASS_MAX_DAYS>
Password inactive                    : never
Account expires                        : never
Minimum number of days between password change        : <PASS_MIN_DAYS>
Maximum number of days between password change        : <PASS_MAX_DAYS>
Number of days of warning before password expires    : <PASS_WARN_AGE>
```

### Step 3: Creating a New Group

Create new *user42* group via `sudo addgroup user42`.

```
$ sudo addgroup user42
```

Add user to *user42* group via `sudo adduser <username> user42`.

```
$ sudo adduser <username> user42
```

> Alternatively, add user to user42 group via sudo usermod -aG user42 <username>.
> 
> 
> ```
> $ sudo usermod -aG user42 <username>
> ```
> 
> Verify whether user was successfully added to *user42* group via `getent group user42`.
> 

```
$ getent group user42
```

## monitoring.sh

```bash
#/bin/bash
lvmc=$(lsblk | grep "lvm" | wc -l)

wall """
#Architecture: $(uname -a)
#CPU physical : $(cat /proc/cpuinfo | grep '^physical id' | sort | uniq | wc -l)
#vCPU : $(cat /proc/cpuinfo | grep '^processor' | wc -l)
#Memory Usage: $(free | grep "Mem" | awk '{printf "%.f/%.fMb (%.1f%%)", ($3/1024), ($2/1024)MB, ($3/$2)*100"%" }')
#Disk Usage: $(df -h --total | tail -1 | awk '{printf "%s/%sGB (%.3s%%)", $3, $2, ($3/$2)*100"%" }' | sed 's/G//' | sed 's/GG/G/')
#CPU load: $(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
#Last boot: $(uptime -s)
#LVM use: $(if [ $lvmc -eq 0 ]; then echo no; else echo yes; fi)
#Connections TCP : $(netstat -nat | grep "ESTABLISHED" | awk '{print $4}' | wc -l) ESTABLISHED
#User log: $(uptime | awk '{print $5}')
#Network: IP $(hostname -I) ($(ip link show | grep "link/ether" | awk '{print $2}'))
#Sudo : $(cat /var/log/sudo | wc -l | awk '{print $1 / 2}') cmd
"""
```

## *cron*

### Setting Up a *cron* Job

Configure *cron* as *root* via `sudo crontab -u root -e`.

```
$ sudo crontab -u root -e
```

To schedule a shell script to run every 10 minutes, replace below line

```
23 # m h  dom mon dow   command
```

with:

```
23 */10 * * * * sh /path/to/script
```

Check *root*'s scheduled *cron* jobs via `sudo crontab -u root -l`.

```
$ sudo crontab -u root -l
```

## Bonus

### #1: Linux Lighttpd MariaDB PHP *(LLMP)* Stack

### Step 1: Installing Lighttpd

Install *lighttpd* via `sudo apt install lighttpd`.

```
$ sudo apt install lighttpd
```

Verify whether *lighttpd* was successfully installed via `dpkg -l | grep lighttpd`.

```
$ dpkg -l | grep lighttpd
```

Allow incoming connections using Port 80 via `sudo ufw allow 80`.

```
$ sudo ufw allow 80
```

### Step 2: Installing & Configuring MariaDB

Install *mariadb-server* via `sudo apt install mariadb-server`.

```
$ sudo apt install mariadb-server
```

Verify whether *mariadb-server* was successfully installed via `dpkg -l | grep mariadb-server`.

```
$ dpkg -l | grep mariadb-server
```

Start interactive script to remove insecure default settings via `sudo mysql_secure_installation`.

```
$ sudo mysql_secure_installation
Enter current password for root (enter for none): #Just press Enter (do not confuse database root with system root)
Set root password? [Y/n] n
Remove anonymous users? [Y/n] Y
Disallow root login remotely? [Y/n] Y
Remove test database and access to it? [Y/n] Y
Reload privilege tables now? [Y/n] Y
```

Log in to the MariaDB console via `sudo mariadb`.

```
$ sudo mariadb
MariaDB [(none)]>
```

Create new database via `CREATE DATABASE <database-name>;`.

```
MariaDB [(none)]> CREATE DATABASE <database-name>;
```

Create new database user and grant them full privileges on the newly-created database via `GRANT ALL ON <database-name>.* TO '<username-2>'@'localhost' IDENTIFIED BY '<password-2>' WITH GRANT OPTION;`.

```
MariaDB [(none)]> GRANT ALL ON <database-name>.* TO '<username-2>'@'localhost' IDENTIFIED BY '<password-2>' WITH GRANT OPTION;
```

Flush the privileges via `FLUSH PRIVILEGES;`.

```
MariaDB [(none)]> FLUSH PRIVILEGES;
```

Exit the MariaDB shell via `exit`.

```
MariaDB [(none)]> exit
```

Verify whether database user was successfully created by logging in to the MariaDB console via `mariadb -u <username-2> -p`.

```
$ mariadb -u <username-2> -p
Enter password: <password-2>
MariaDB [(none)]>
```

Confirm whether database user has access to the database via `SHOW DATABASES;`.

```
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| <database-name>    |
| information_schema |
+--------------------+
```

Exit the MariaDB shell via `exit`.

```
MariaDB [(none)]> exit
```

### Step 3: Installing PHP

Install *php-cgi* & *php-mysql* via `sudo apt install php-cgi php-mysql`.

```
$ sudo apt install php-cgi php-mysql
```

Verify whether *php-cgi* & *php-mysql* was successfully installed via `dpkg -l | grep php`.

```
$ dpkg -l | grep php
```

### Step 4: Downloading & Configuring WordPress

Install *wget* via `sudo apt install wget`.

```
$ sudo apt install wget
```

Download WordPress to `/var/www/html` via `sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html`.

```
$ sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html
```

Extract downloaded content via `sudo tar -xzvf /var/www/html/latest.tar.gz`.

```
$ sudo tar -xzvf /var/www/html/latest.tar.gz
```

Remove tarball via `sudo rm /var/www/html/latest.tar.gz`.

```
$ sudo rm /var/www/html/latest.tar.gz
```

Copy content of `/var/www/html/wordpress` to `/var/www/html` via `sudo cp -r /var/www/html/wordpress/* /var/www/html`.

```
$ sudo cp -r /var/www/html/wordpress/* /var/www/html
```

Remove `/var/www/html/wordpress` via `sudo rm -rf /var/www/html/wordpress`

```
$ sudo rm -rf /var/www/html/wordpress
```

Create WordPress configuration file from its sample via `sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php`.

```
$ sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
```

Configure WordPress to reference previously-created MariaDB database & user via `sudo vi /var/www/html/wp-config.php`.

```
$ sudo vi /var/www/html/wp-config.php
```

Replace the below

```
23 define( 'DB_NAME', 'database_name_here' );^M
26 define( 'DB_USER', 'username_here' );^M
29 define( 'DB_PASSWORD', 'password_here' );^M
```

with:

```
23 define( 'DB_NAME', '<database-name>' );^M
26 define( 'DB_USER', '<username-2>' );^M
29 define( 'DB_PASSWORD', '<password-2>' );^M
```

### Step 5: Configuring Lighttpd

Enable below modules via `sudo lighty-enable-mod fastcgi; sudo lighty-enable-mod fastcgi-php; sudo service lighttpd force-reload`.

```
$ sudo lighty-enable-mod fastcgi
$ sudo lighty-enable-mod fastcgi-php
$ sudo service lighttpd force-reload
```

### #2: File Transfer Protocol *(FTP)*

### Step 1: Installing & Configuring FTP

Install FTP via `sudo apt install vsftpd`.

```
$ sudo apt install vsftpd
```

Verify whether *vsftpd* was successfully installed via `dpkg -l | grep vsftpd`.

```
$ dpkg -l | grep vsftpd
```

Allow incoming connections using Port 21 via `sudo ufw allow 21`.

```
$ sudo ufw allow 21
```

Configure *vsftpd* via `sudo vi /etc/vsftpd.conf`.

```
$ sudo vi /etc/vsftpd.conf
```

To enable any form of FTP write command, uncomment below line:

```
31 #write_enable=YES
```

To set root folder for FTP-connected user to `/home/<username>/ftp`, add below lines:

```
$ sudo mkdir /home/<username>/ftp
$ sudo mkdir /home/<username>/ftp/files
$ sudo chown nobody:nogroup /home/<username>/ftp
$ sudo chmod a-w /home/<username>/ftp
<~~~>
user_sub_token=$USER
local_root=/home/$USER/ftp
<~~~>
```

To prevent user from accessing files or using commands outside the directory tree, uncomment below line:

```
114 #chroot_local_user=YES
```

To whitelist FTP, add below lines:

```
$ sudo vi /etc/vsftpd.userlist
$ echo <username> | sudo tee -a /etc/vsftpd.userlist
<~~~>
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO
<~~~>
```

### Step 2: Connecting to Server via FTP

FTP into your virtual machine via `ftp <ip-address>`.

```
$ ftp <ip-address>
```

Terminate FTP session at any time via `CTRL + D`.
