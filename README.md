# dockerizado #dockerit
Prueba de módulo
Dockerizado Script

Bash script to manage web apps using docker and hosts aliases. You can define your IP address.
Made for Kali linux, but should work it pretty fine with any debian-like linux distro.
Current available apps:

    nginx Web Server
    Damn Vulnerable Web App
    WPScan Vulnerable Wordpress

Installation

You can download dockerit.sh just by cloning this git repository:

git clone https://github.com/GArayaR/dockerizado/dockerit.git
cd dockerizado

    # Then run
    ./dockerit.sh start nginx
    # ... to download bwapp docker image and map it onto localhost at http://nginx

    # Print a complete list of available projects use the list command
    ./dockerit.sh list

    # Running just the script will print help info
    ./dockerit.sh

Get Started

 dockerit.sh has minimal requirements. As stated you don't have to install or build anything.
 You can just run it from the pulled/cloned directory.

Usage

 ./dockerit.sh {list|status|info|start|stop} [projectname]
 
 This scripts uses docker and hosts alias to make web apps available on localhost

Examples
       
    ./dockerit.sh list
    List all available projects  
   
    ./dockerit.sh status
    Show status for all projects  
   
    ./dockerit.sh start nginx
    Start docker container with nginx and make it available on localhost  
    
    ./dockerit.sh stop nginx
    Stop docker container

    ./dockerit.sh info nginx
    Show information about nginx 
