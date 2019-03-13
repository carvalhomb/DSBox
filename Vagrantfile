# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"   
  
  config.vm.network "forwarded_port", guest: 8888, host: 8888  #for jupyter notebook
  config.vm.network "forwarded_port", guest: 8787, host: 8787  #for RStudio

  config.vm.synced_folder "data", "/data", create:true # for sharing data with host
  config.vm.synced_folder "git_repos", "/git_repos", create:true # for sharing local git repositories
  
  ###############################################################################################
  # Check if we need to pass on proxy config
  my_proxy = nil
  my_proxy_url = ''
  my_proxy_auth = ''
  
  if ENV['MY_PROXY_SERVER'] and ENV['MY_PROXY_PORT']
	my_proxy_url = ENV['MY_PROXY_SERVER'] + ":" + ENV['MY_PROXY_PORT']	
  end
  
  if ENV['MY_PROXY_USERNAME'] and ENV['MY_PROXY_PASSWORD']
	my_proxy_auth = ENV['MY_PROXY_USERNAME'] + ":" + ENV['MY_PROXY_PASSWORD'] + "@"
  end
	
  if my_proxy_url != ''
	my_proxy = "http://" + my_proxy_auth + my_proxy_url
  end
  
  Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = my_proxy
    config.proxy.https    = my_proxy
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end
  end
  
  ##########################################################################################
  # Pass on an env var with the path to a SSL certificate to add to the trusted certificates
  
  my_ssl_cert = nil
  if ENV['MY_SSL_CERT']
	my_ssl_cert = ENV['MY_SSL_CERT']
  end
  
  ##############################################################################
  # Configure box specs
  config.vm.provider "virtualbox" do |vb|   
    vb.memory = "4000"
    #vb.cpus = "2"
  end
  
  ##############################################################################
  # Run provision script, passing on the environmental variables we need
  
  puts "MY_PROXY: " + my_proxy.to_s + "; MY_SSL_CERT: " + my_ssl_cert.to_s + "."
  
  config.vm.provision :shell, path: "bootstrap.sh", env: {"MY_PROXY" => my_proxy, "MY_SSL_CERT" => my_ssl_cert}

end