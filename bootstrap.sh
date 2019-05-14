#!/usr/bin/env bash

########################################################################
# Convert root certificate to pem and add to certificate store
########################################################################

if [ -n "$MY_SSL_CERT" ]; then

	echo "There is a certificate to be installed at $MY_SSL_CERT."

	FILE=/vagrant/$MY_SSL_CERT

	if [ -f "$FILE" ]; then
		openssl x509 -inform der -in $FILE -text -out new-cert.txt
		sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' new-cert.txt > new-cert.crt
		sudo cp -f new-cert.crt /usr/local/share/ca-certificates/
		sudo update-ca-certificates --fresh
		rm new-cert.txt
		rm new-cert.crt
	fi

fi

########################################################################
# Export proxy
########################################################################

if [ -n "$MY_PROXY" ]; then

	echo "There is a proxy to be set: $MY_PROXY."

	if [[ -z "${http_proxy}" ]]; then
		sudo echo "export http_proxy=$MY_PROXY" >> /etc/environment
		export http_proxy=$MY_PROXY
	else
		echo "Variable http_proxy already set (to $http_proxy), moving on..."
	fi
	
	if [[ -z "${https_proxy}" ]]; then
		sudo echo "export https_proxy=$MY_PROXY" >> /etc/environment
		export https_proxy=$MY_PROXY
	else
		echo "Variable https_proxy already set (to $https_proxy), moving on..."
	fi
    
	if [[ -z "${no_proxy}" ]]; then
		sudo echo "export no_proxy=$NO_PROXY" >> /etc/environment
		export no_proxy=$NO_PROXY
	else
		echo "Variable no_proxy already set (to $no_proxy), moving on..."
	fi
	
	# Escape backslash, if any
	my_proxy_escaped=$(echo "$MY_PROXY" | sed 's#\\#\\\\#g')
	echo "Escaped proxy info: $my_proxy_escaped"
	
	# Check if proxy info is already set in file Rprofile.site
	rprofile=/usr/lib/R/etc/Rprofile.site
	if grep -q http_proxy "$rprofile"; then
		echo "File $rprofile already has http_proxy set, moving on..."
	else
		echo "Adding proxy info to file $rprofile..."
		sudo printf '\nSys.setenv(http_proxy = "%s")' "$my_proxy_escaped" >> $rprofile
		sudo printf '\nSys.setenv(https_proxy = "%s")' "$my_proxy_escaped" >> $rprofile
        sudo printf '\nSys.setenv(no_proxy = "%s")' "$no_proxy" >> $rprofile
	fi
	
fi

########################################################################
# Update package cache and install some banner utilities
########################################################################

sudo apt-get update
sudo apt-get install -y figlet 
sudo apt-get install -y toilet

########################################################################
# Install Build Tools
########################################################################


toilet -f standard -k  Install Build Tools
for x in build-essential gfortran gcc-multilib g++-multilib libffi-dev libffi6 libffi6-dbg python-crypto python-mox3 python-pil python-ply libssl-dev zlib1g-dev libbz2-dev libexpat1-dev libbluetooth-dev libgdbm-dev dpkg-dev quilt autotools-dev libreadline-dev libtinfo-dev libncursesw5-dev tk-dev blt-dev libssl-dev zlib1g-dev libbz2-dev libexpat1-dev libbluetooth-dev libsqlite3-dev libgpm2 mime-support netbase net-tools bzip2 p7zip unrar-free gcc libxml2-dev libcurl4-openssl-dev unixodbc-dev alien libaio1 git; do
    echo -e '\e[32m########################################################################\e[0m'
    echo -e "\e[32m# sudo apt-get -y install $x\e[0m"
    echo -e '\e[32m########################################################################\e[0m'
    sudo apt-get -y install $x
done

toilet -f standard -k  Dynamic swap
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install swapspace\e[0m'
sudo apt-get install -y swapspace 

########################################################################
# Install R and R Studio
########################################################################


toilet -f standard -k  Install R \& RStudio
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install r-base\e[0m'
echo -e '\e[32m########################################################################\e[0m'
sudo apt-get install -y r-base 
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install r-base-dev\e[0m'
echo -e '\e[32m########################################################################\e[0m'
sudo apt-get install -y r-base-dev
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install gdebi-core\e[0m'
echo -e '\e[32m########################################################################\e[0m'
sudo apt-get install -y gdebi-core


PKG_OK=$(dpkg-query -W --showformat='${Status}\n' rstudio-server|grep "install ok installed")
echo Checking for rstudio-server: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No rstudio-server. Installing rstudio-server."
    pushd /tmp
    wget --quiet https://download2.rstudio.org/rstudio-server-1.1.463-amd64.deb
    echo -e '\e[32m########################################################################\e[0m'
    echo -e '\e[32m# yes|gdebi rstudio-server-1.1.463-amd64.deb\e[0m'
    echo -e '\e[32m########################################################################\e[0m'
    sudo yes|gdebi rstudio-server-1.1.463-amd64.deb
    popd
fi


########################################################################
# Install Java, configure rJava
########################################################################


toilet -f standard -k  Install Java
for x in openjdk-11-doc openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre openjdk-11-jre-headless  r-cran-rjava; do
    echo -e '\e[32m########################################################################\e[0m'
    echo -e "\e[32m# sudo apt-get -y install $x\e[0m"
    echo -e '\e[32m########################################################################\e[0m'
    sudo apt-get install -y $x
done
echo -e '\e[32msudo R CMD javareconf\e[0m'
sudo R CMD javareconf

########################################################################
# Install Python2 and Python3
########################################################################

toilet -f standard -k  Install Python
for x in python3-pip python3-all python3-all-dev python-all python-all-dev python-pip ipython python3-tk ipython3; do
    echo -e '\e[32m########################################################################\e[0m'
    echo -e "\e[32m# sudo apt-get -y install $x\e[0m"
    echo -e '\e[32m########################################################################\e[0m'
    sudo apt-get install -y $x
done

########################################################################
# Install Graphviz
########################################################################


toilet -f standard -k  Install Graphviz
for x in graphviz; do
    echo -e '\e[32m########################################################################\e[0m'
    echo -e "\e[32m# sudo apt-get -y install $x\e[0m"
    echo -e '\e[32m########################################################################\e[0m'
    sudo apt-get install -y $x
done

########################################################################
# Install Oracle Instant Client 
########################################################################

toilet -f standard -k  Install OIC
echo -e '\e[32m########################################################################\e[0m'

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' oracle-instantclient*|grep "install ok installed")
echo Checking for oracle-instantclient: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No oracle-instantclient. Installing oracle-instantclient."
    wget --quiet http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient18.3-basic-18.3.0.0.0-3.x86_64.rpm
    wget --quiet http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient18.3-devel-18.3.0.0.0-3.x86_64.rpm
    wget --quiet http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient18.3-sqlplus-18.3.0.0.0-3.x86_64.rpm
    wget --quiet http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient18.3-odbc-18.3.0.0.0-3.x86_64.rpm
    wget --quiet http://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient18.3-jdbc-18.3.0.0.0-3.x86_64.rpm
    sudo alien -i oracle-instantclient18.3-basic-18.3.0.0.0-3.x86_64.rpm
    sudo alien -i oracle-instantclient18.3-devel-18.3.0.0.0-3.x86_64.rpm
    sudo alien -i oracle-instantclient18.3-jdbc-18.3.0.0.0-3.x86_64.rpm
    sudo alien -i oracle-instantclient18.3-odbc-18.3.0.0.0-3.x86_64.rpm
    sudo alien -i oracle-instantclient18.3-sqlplus-18.3.0.0.0-3.x86_64.rpm
    export LD_LIBRARY_PATH=/usr/lib/oracle/18.3/client64/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    export ORACLE_HOME=/usr/lib/oracle/18.3/client64
    export PATH=$PATH:$ORACLE_HOME/bin
    echo "/usr/lib/oracle/18.3/client64/lib" | sudo tee /etc/ld.so.conf.d/oracle.conf
    sudo ldconfig -v
    echo $LD_LIBRARY_PATH
    echo $ORACLE_HOME
    echo $PATH
    echo -e '\e[32m########################################################################\e[0m'
    rm oracle-instantclient18.3-basic-18.3.0.0.0-3.x86_64.rpm
    rm oracle-instantclient18.3-devel-18.3.0.0.0-3.x86_64.rpm
    rm oracle-instantclient18.3-sqlplus-18.3.0.0.0-3.x86_64.rpm
    rm oracle-instantclient18.3-odbc-18.3.0.0.0-3.x86_64.rpm
    rm oracle-instantclient18.3-jdbc-18.3.0.0.0-3.x86_64.rpm
fi





########################################################################
# Add Packages to Python3
########################################################################

toilet -f standard -k  Add Py3 pkgs
#sudo pip3 install --upgrade pip #Latest pip is broken, so comment out the upgrade

for x in  csvkit numpy scipy skll numexpr tables openpyxl xlsxwriter xlrd feedparser beautifulsoup4 plotly statsmodels dataset nltk networkx deap pydot rpy2 jug nose pandas matplotlib seaborn sklearn mrjob lightgbm astropy glob2 graphviz gsl humanize markdown more-itertools natsort ply pyreadline scikit-image sympy gensim pm4py gitpython spyder-kernels ; do
    echo -e '\e[32m########################################################################\e[0m'
    echo -e "\e[32m# sudo pip3 install  $x\e[0m"
    echo -e '\e[32m########################################################################\e[0m'
    sudo pip3 install  $x
done

sudo pip3 install  pandas

########################################################################
# Install Jupyter
########################################################################

toilet -f standard -k  Install Jupyter
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install jupyter-core\e[0m'
echo -e '\e[32m########################################################################\e[0m'
sudo apt-get install -y jupyter-core 
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install jupyter-notebook\e[0m'
echo -e '\e[32m########################################################################\e[0m'
sudo apt-get install -y jupyter-notebook
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install jupyter_contrib_nbextensions\e[0m'
echo -e '\e[32m########################################################################\e[0m'
sudo apt-get install -y jupyter_contrib_nbextensions
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt-get -y install jupyterlab\e[0m'
echo -e '\e[32m########################################################################\e[0m'
sudo apt-get install -y jupyterlab

########################################################################
# Cleaning up
########################################################################

toilet -f standard -k  Clean up
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo apt autoremove -y\e[0m'
echo -e '\e[32m########################################################################\e[0m'

sudo apt-get autoremove -y


########################################################################
# Install R packages
########################################################################

toilet -f standard -k  Install R pkgs
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m# sudo Rscript /vagrant/install-packages.R\e[0m'
echo -e '\e[32m########################################################################\e[0m'

sudo Rscript /vagrant/install-packages.R
wget --quiet https://cran.r-project.org/src/contrib/ROracle_1.3-1.tar.gz
sudo R CMD INSTALL --configure-args='--with-oci-lib=/usr/lib/oracle/18.3/client64/lib --with-oci-inc=/usr/include/oracle/18.3/client64' ROracle_1.3-1.tar.gz
rm ROracle_1.3-1.tar.gz

########################################################################
# Modify .bashrc
########################################################################


toilet -f standard -k Updt .bashrc
echo -e 'PATH=${PATH}:.' >> /home/vagrant/.bashrc
echo -e "alias ls='ls -AF --color=auto'" >> /home/vagrant/.bashrc

########################################################################
# Display some HOWTOs and finish
########################################################################
echo
echo
echo
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m########################################################################\e[0m'
echo
echo
echo

toilet -f standard -k  Finished!

echo
echo
echo
echo -e '\e[32m########################################################################\e[0m'
echo -e '\e[32m########################################################################\e[0m'
echo
echo
echo

toilet -f standard -k HOWTOs:

echo
echo
echo

echo vagrant ssh   '<---' type this on a terminal in your host to log in to the guest
echo  
echo  
tail -n +1 /vagrant/howtos/*

echo
echo
echo Now run /vagrant/vagrant_test.sh on the guest command line for a quick sanity-test of the installation.
echo Scroll up a little for some howtos

