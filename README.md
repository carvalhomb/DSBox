# Vagrant Data Science 2018

Files to set up Vagrant/Virtual box instance of Ubuntu/Bionic64 18.04 for Data Science

## Quick Start

1. Download the free [VirtualBox](https://www.virtualbox.org/) virtual machine player.

2. [download and install the appropriate Vagrant package for your OS](https://www.vagrantup.com/downloads.html).

3.  Clone or unzip this repository somewhere.  In this example, I assume you are on Windows and have put the files (including the Vagrantfile) in:

```
D:\DSBox
```

4. Open a command-line (recommended: Terminal on Mac, PowerShell or Git Bash on Windows, your favorite terminal on Linux)

5. cd into this project's root folder; In this example, if using Git Bash, you would type:

```
cd /d/DSBox
```

6. Check everything is gonna be alright so far by listing the directory.  In Git Bash, that would be:

```
ls -AF
```

and you should see something like:

```
$ ls -AF
.git/ bootstrap.sh*  howtos/  LICENSE  README.md  Vagrantfile
```

It is important that bootstrap.sh and Vagrantfile be there, as well as the howtos directory (or at least the README.md)

7. (Optional) If you are behind a proxy, install the [Proxy Configuration Plugin for Vagrant](https://github.com/tmatilai/vagrant-proxyconf):

```
vagrant plugin install vagrant-proxyconf
```

You might need to export http_proxy and https_proxy environment variables **in the host** to be able to install the plugin from the command line. If you have problems connecting, try:

```
set http_proxy=http://127.0.0.1:8080
set https_proxy=http://127.0.0.1:8080
```

You will need to set up the following environment variables **in the host** (examples) for Vagrant to do the proper configuration of the proxy in your guest box:

```
set MY_PROXY_SERVER=127.0.0.1
set MY_PROXY_PORT=8080
set MY_PROXY_USERNAME=DOMAIN\username  # Domain is optional
set MY_PROXY_PASSWORD=123456
```

8. (Optional) If your proxy requires installing an additional trusted certificate, you can do so by copying the certificate in text format (plain text file that contains the certificate between -----BEGIN CERTIFICATE------ and -----END CERTIFICATE----- markers; you only need the contents between the two markers) and with extension .crt to the vagrant directory, so that it is accessible in the guest box:

```
cp ~/my_certificate.crt /d/DSBox/
```

Then, set up the environment variable MY_SSL_CERT **in the host** with the name of the certificate to be installed:

```
set MY_SSL_CERT='my_certificate.crt' 
```	

9. Run 

```
vagrant up
```
    
in the terminal.  This will take some time, a lot gets installed.

10. If all goes well, you will see the howtos scroll by, and you can go to the machine by typing:

```
vagrant ssh
```
    
11. It is recommended you type, **at the guest command prompt** you now see, /vagrant/vagrant_test.sh to do a quick sanity-test:

```
chmod u+x /vagrant/vagrant_test.sh
/vagrant/vagrant_test.sh
```

If all goes well, there will be no lines printed beginning with "error:".  If not, brief instructions are given on the error lines to attempt to fix the issues.  If this fails, please generate an [Issue in the original project](https://github.com/Deplorable-Mountaineer/VagrantDataScience2018/issues).

## Setting Up a Few Things

In your guest OS that you just ssh'd into using "vagrant ssh", you can find the howtos in the directory:

```
/vagrant/howtos
```

These give you quick instructions for accessing the guest's RStudio Server and Jupyter notebook via your Host OS's web browser.

The howtos are reproduced here for convenience:


## Jupyter Notebook HOWTO

For Jupyter nootebooks, on guest, type:

```
jupyter notebook --generate-config
jupyter notebook password
```

Choose a password, it can't be blank. Then:

```
jupyter notebook --ip 0.0.0.0
```

open browser on host, browse to [localhost:8888](http://localhost:8888), type in the password you set, if asked.

## RStudio HOWTO

For RStudio, simply open browser on host, browse to [localhost:8787](http://localhost:8787).

- username: vagrant
- password: vagrant



## What's Included

* Tools: figlet and toilet: for printing banners to the terminal

* Build Tools: build-essential gfortran gcc-multilib g++-multilib libffi-dev libffi6 libffi6-dbg python-crypto python-mox3 python-pil python-ply libssl-dev zlib1g-dev libbz2-dev libexpat1-dev libbluetooth-dev libgdbm-dev dpkg-dev quilt autotools-dev libreadline-dev libtinfo-dev libncursesw5-dev tk-dev blt-dev libssl-dev zlib1g-dev libbz2-dev libexpat1-dev libbluetooth-dev libsqlite3-dev libgpm2 mime-support netbase net-tools bzip2 p7zip unrar-free gcc libxml2-dev libcurl4-openssl-dev unixodbc-dev alien libaio1 git

* R and R Studio: r-base r-base-dev gdebi-core rstudio-server: a statistics and data science scripting language

* Java: openjdk-11-doc openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre openjdk-11-jre-headless r-cran-rjava

* Oracle Instant Client (oracle-instantclient18.3) and ROracle (ROracle_1.3-1)

* Python: python3-pip python3-all python3-all-dev python-all python-all-dev python-pip ipython python3-tk ipython3 graphviz

* Python packages: csvkit numpy scipy skll numexpr tables openpyxl xlsxwriter xlrd feedparser beautifulsoup4 plotly statsmodels dataset nltk networkx deap pydot rpy2 jug nose pandas matplotlib seaborn sklearn mrjob lightgbm astropy glob2 graphviz gsl humanize markdown more-itertools natsort ply pyreadline scikit-image sympy gensim pm4py gitpython spyder-kernels 

* Jupyter: jupyter-core jupyter-notebook jupyter_contrib_nbextensions: Python web-based data-science notebook

----

**Based on the box created by [Deplorable Mountaineer](https://www.deplorablemountaineer.com).**
