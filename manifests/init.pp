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

  # update the rkhunter database whenever we add packages
  Package <||> ~> Exec <| title == 'init_rkunter_db' |>

  # tweak path for DB update and force to run everytime
  Exec <| title == 'init_rkunter_db' |> {
    path => '/usr/bin:/bin',
    creates => undef,
    # refreshonly => true,
  }

  class { 'rkhunter':
  }

}
