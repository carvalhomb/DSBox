print("Checking if a package exists before installing it")

pkgs <- c("curl", "devtools", "Rcpp11", "reticulate", "remotes", "data.table", "ggplot2", "lubridate", "tidyverse", "DBI", "RODBC", "RJDBC",
            "bupaR", "edeaR", "eventdataR", "processmapR", "processmonitR", "xesreadR", "petrinetR", "here")
mirror <- 'http://cloud.r-project.org/'

# Function to check whether package is installed
is.installed <- function(mypkg){
    is.element(mypkg, installed.packages()[,1])
}

# Function to install package only if it is not already installed
my.install.package <-  function(x) {
    if(is.installed(x)) {
        print(paste0("Package already installed: ", x))
    } else {
        install.packages(x, repos=mirror)        
    }
}

# Check packages, install the ones not available yet
lapply(pkgs, my.install.package)

# Install heuristicsmineR
if (!is.installed("heuristicsmineR")) {
    library("remotes")
    remotes::install_github("fmannhardt/heuristicsmineR")
} else {
    print("Package heuristicsmineR is already installed.")
}

# Install pm4py bridge package
if (!is.installed("pm4py")) {
    library("remotes")
    remotes::install_github("fmannhardt/pm4py")
} else {
    print("Package pm4py is already installed.")
}

