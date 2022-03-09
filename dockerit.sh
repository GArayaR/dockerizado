#!/bin/bash

ETC_HOSTS=/etc/hosts


#########################
# command line help #
#########################
display_help() {
    echo "Dockerizando w/ DockerIt"
    echo
    echo "Usage: $0 {list|status|info|start|stop} [projectname]" >&2
    echo
    echo " This scripts uses docker and hosts alias to make web apps available on localhost"
    echo 
    echo " Ex."
    echo " $0 list"
    echo " 	List all available projects"
    echo " $0 status"
    echo "	Show status for all projects"
    echo " $0 start bwapp"
    echo " 	Start project and make it available on localhost" 
    echo " $0 info bwapp"
    echo " 	Show information about bwapp project"
    echo
    exit 1
}


############################################
# Check if docker is installed and running #
############################################
if ! [ -x "$(command -v docker)" ]; then
  echo 
  echo "Docker was not found. Please install docker before running this script."
  echo "You can try the script: 	install_docker_kali_x64.sh"
  echo "In the same repo at https://github.com/GArayaR/dockerizado"
  exit
fi

if sudo service docker status | grep inactive > /dev/null
then 
	echo "Docker is not running."
	echo -n "Do you want to start docker now (y/n)?"
	read answer
	if echo "$answer" | grep -iq "^y"; then
		sudo service docker start
	else
		echo "Not starting. Script will not be able to run applications."
	fi
fi


#########################
# List all docker apps #
#########################
list() {
    echo "Available applications:" >&2
    echo "  nginx			- nginx Web Server"
    echo "  dvwa     		- Damn Vulnerable Web Application"
    echo "  vulnerablewordpress	- WPScan Vulnerable Wordpress"
    echo
    exit 1

}


#########################
# Info dispatch         #
#########################
info () {
  case "$1" in 
    nginx)
      project_info_nginx
    ;;
    vulnerablewordpress)
      project_info_vulnerablewordpress
    ;;
    dvwa)
      project_info_dvwa
    ;;
    *) 
      echo "Unknown project name"
      list
      ;;
  esac  
}


#########################
# hosts file util       #
#########################  # Based on https://gist.github.com/irazasyed/a7b0a079e7727a4315b9
function removehost() {
    if [ -n "$(grep $1 /etc/hosts)" ]
    then
        echo "Removing $1 from $ETC_HOSTS";
        sudo sed -i".bak" "/$1/d" $ETC_HOSTS
    else
        echo "$1 was not found in your $ETC_HOSTS";
    fi
}

function addhost() { # ex.   127.5.0.1	bwapp
    HOSTS_LINE="$1\t$2"
    if [ -n "$(grep $2 /etc/hosts)" ]
        then
            echo "$2 already exists in /etc/hosts"
        else
            echo "Adding $2 to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $2 /etc/hosts)" ]
                then
                    echo -e "$HOSTS_LINE was added succesfully to /etc/hosts";
                else
                    echo "Failed to Add $2, Try again!";
            fi
    fi
}


#########################
# PROJECT INFO & STARTUP#
#########################
project_info_nginx() 
{
echo
echo "nginx Web Server"
echo " "
echo
echo "TECH:"
echo "FEATURES:"
}

project_info_dvwa () 
{
echo "The aim of DVWA is to practice some of the most common web vulnerabilities, with various"
echo "levels of difficulty, with a simple straightforward interface. Please note, there are"
echo "both documented and undocumented vulnerabilities with this software. This is intentional."
echo " You are encouraged to try and discover as many issues as possible."
echo "	Ryan Dewhurst"
echo "TECH: 	PHP / MySQL"
echo "FEATURES: DIFFERENT SKILL LEVELS"

project_startinfo_dvwa () 
{
  echo "Damn Vulnerable Web Application now available at http://dvwa"
  echo "Default username/password:   admin/password"
  echo "Remember to click on the CREATE DATABASE Button before you start"
}

project_info_vulnerablewordpress () 
{
echo "https://github.com/wpscanteam/VulnerableWordpress"
echo "Vulnerable Wordpress Application"
echo "TECH: PHP / MySQL"
echo "FEATURES: "
}

project_startinfo_vulnerablewordpress () 
{
  echo "WPScan Vulnerable Wordpress site now awailable at localhost on http://vulnerablewordpress"
}


#########################
# Common start          #
#########################
project_start ()
{
  fullname=$1		# ex. WebGoat 7.1
  projectname=$2     	# ex. webgoat7
  dockername=$3  	# ex. raesene/bwapp
  ip=$4   		# ex. 127.5.0.1
  port=$5		# ex. 80
  port2=$6		# optional second port binding
  
  echo "Starting $fullname"
  addhost "$ip" "$projectname"


  if [ "$(sudo docker ps -aq -f name=$projectname)" ]; 
  then
    echo "Running command: docker start $projectname"
    sudo docker start $projectname
  else
    if [ -n "${6+set}" ]; then
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername
    else echo "not set";
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port $dockername
    fi
  fi
  echo "DONE!"
  echo
  echo "Docker mapped to http://$projectname or http://$ip"
  echo
}


#########################
# Common stop           #
#########################
project_stop ()
{
  fullname=$1	# ex. WebGoat 7.1
  projectname=$2     # ex. webgoat7

  echo "Stopping... $fullname"
  echo "Running command: docker stop $projectname"
  sudo docker stop $projectname
  removehost "$projectname"
}


project_status()
{
  if [ "$(sudo docker ps -q -f name=nginx)" ]; then
    echo "nginx				running at http://nginx"
  else 
    echo "nginx				not running"
  fi
  if [ "$(sudo docker ps -q -f name=dvwa)" ]; then
    echo "DVWA				running at http://dvwa"
  else 
    echo "DVWA				not running"  
  fi
    if [ "$(sudo docker ps -q -f name=vulnerablewordpress)" ]; then
    echo "WPScan Vulnerable Wordpress 	running at http://vulnerablewordpress"
  else 
    echo "WPScan Vulnerable Wordpress	not running"  
  fi
}


project_start_dispatch()
{
  case "$1" in
    dvwa)
      project_start "Damn Vulnerable Web Appliaction" "dvwa" "vulnerables/web-dvwa" "127.9.0.1" "80"
      project_startinfo_dvwa
    ;;    
    nginx)
      project_start "nginx WS" "nginx" "nginx" "127.10.0.1" "80"
      project_startinfo_mutillidae
    ;;
    vulnerablewordpress)
      project_start "WPScan Vulnerable Wordpress" "vulnerablewordpress" "l505/vulnerablewordpress" "127.13.0.1" "80" "3306"
      project_startinfo_vulnerablewordpress
    ;;
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}

project_stop_dispatch()
{
  case "$1" in
    nginx)
      project_stop "nginx" "nginx"
    ;;
    project_stop "Damn Vulnerable Web Appliaction" "dvwa"
    ;;
    vulnerablewordpress)
      project_stop "WPScan Vulnerable Wordpress" "vulnerablewordpress"
    ;;
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}


#########################
# Main switch case      #
#########################
case "$1" in
  start)
    if [ -z "$2" ]
    then
      echo "ERROR: Option start needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    project_start_dispatch $2
    ;;
  stop)
    if [ -z "$2" ]
    then
      echo "ERROR: Option stop needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    project_stop_dispatch $2
    ;;
  list)
    list # call list ()
    ;;
  status)
    project_status # call project_status ()
    ;;
  info)
    if [ -z "$2" ]
    then
      echo "ERROR: Option info needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    info $2
    ;;
  *)
    display_help
;;
esac