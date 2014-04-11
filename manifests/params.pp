class dorkhunter::params {

  # setup OS-specific package manager
  case $operatingsystem {
    centos, redhat, fedora: {
      $package_manager = 'RPM'
    }
    ubuntu, debian: {
      $package_manager = 'DPKG'
    }
  }

}
