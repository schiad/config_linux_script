# config_linux_script
A script helps to configure a linux systems
That help for the time begin to configure ssh keys and can checks the ssh configuration.

## Download and execute

git clone https://github.com/schiad/config_linux_script.git
cd config_linux_script
chmod u+x server.sh
./server.sh

## List of functions

### SSH keys generator

When the script is started select this function
press 1.

Server name :
	Type the name of the ssh server.

host name :
	Type the host name or adress of the ssh server.

user name :
	Type the username to connect to the ssh server.

port ssh server :
	Type the port to connect to ssh server.

Now it's generating the keys it's can take a moment.

You can enter a passphrase if it's needed
Keep it blank just enter if not need.

The server configuration is intalled in the ~/.ssh/config file
and ssh-copy need your server user password to end
the configuration.

To exit from this fuction press ENTER.
To exit script press 0.

now to use it type ssh [name server].

Enjoy.

### ssh config file display

When the script is started select this function
press 2.

This function execute cat ~/.ssh/config to see your cofiguration.

To exit from this fuction press ENTER.
To exit script press 0.

Enjoy.

### Check ssh rights cofiguration

When the script is started select this function
press 3.

This function checks your ssh cofiguration and can repair
if some errors a detected.

To exit from this fuction press ENTER.
To exit script press 0.

Enjoy.

Some fonctions are coming.

SCHIAD F4IFB
