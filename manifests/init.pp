class dorkhunter (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',

  # email address for warnings (not very meaningful); null to disable
  # $mail_on_warning = 'root@localhost',
  $mail_on_warning = 'null',

  # much fuller emails
  $mail_dailyrun = 'root@localhost',
  $package_manager = $::dorkhunter::params::package_manager,

  # end of class arguments
  # ----------------------
  # begin class

) inherits dorkhunter::params {

  # tell rkhunter to use our template (using class variables)
  if defined(File['/etc/rkhunter.conf']) {
    File <| title == '/etc/rkhunter.conf' |> {
      source => undef,
      content => template('dorkhunter/rkhunter.conf.erb'),
    }
  } else {
    file { '/etc/rkhunter.conf' :
      owner => 'root',
      group => 'root', 
      mode => 0640,
      content => template('dorkhunter/rkhunter.conf.erb'),
    }
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

  # tweak path for rkhunter config (CentOS only)
  File <| title == '/etc/sysconfig/rkhunter' |> {
    source => undef,
    content => template('dorkhunter/rkhunter.sysconfig.erb'),
  }
  # @todo Ubuntu, set $REPORT_EMAIL variable in /etc/default/rkhunter

  class { 'rkhunter':
  }

}
