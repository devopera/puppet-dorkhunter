class dorkhunter (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',

  # email address for warnings
  $mail_on_warning = 'root@localhost',

  # end of class arguments
  # ----------------------
  # begin class

) {

  case $operatingsystem {
    centos, redhat: {
    }
    ubuntu, debian: {
    }
  }

  # tell rkhunter to use our template
  File <| title == '/etc/rkhunter.conf' |> {
    source => undef,
    content => template('dorkhunter/rkhunter.conf.erb'),
  }

  class { 'rkhunter':
  }

}
