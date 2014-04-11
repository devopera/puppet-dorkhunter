class dorkhunter (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',

  # email address for warnings
  $mail_on_warning = 'root@localhost',
  $package_manager = $::dorkhunter::params::package_manager,

  # end of class arguments
  # ----------------------
  # begin class

) inherits dorkhunter::params {

  # tell rkhunter to use our template (using class variables)
  File <| title == '/etc/rkhunter.conf' |> {
    source => undef,
    content => template('dorkhunter/rkhunter.conf.erb'),
  }

  # make sure the rkhunter log directory exists
  file { '/var/log/rkhunter' :
    ensure => directory,
    owner => 'root',
    group => 'root',
    mode => 0755,
    before => Class['rkhunter'],
  }

  # update the rkhunter database whenever we add packages
  Package <||> ~> Exec <| title == 'init_rkunter_db' |>

  # tweak path for DB update and force to run everytime (not refreshonly)
  Exec <| title == 'init_rkunter_db' |> {
    path => '/usr/bin:/bin',
    creates => undef,
    # refreshonly => true,
  }

  class { 'rkhunter':
  }

}
