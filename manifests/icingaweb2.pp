# This class manages the installation and initialisation of icingaweb2
#
# @param ensure If to install or remove icingaweb2
# @param auto_prereq If to automatically install all the prerequisites
#                           resources needed to install the runner
# @param template The path to the erb template (as used in template()) to use
#                 to populate the Runner configuration file. Note that if you
#                 use the runners parameter this file is automatically generated
#                 during runners registration
# @param options An open hash of options you may use in your template
#
class psick::icingaweb2 (
  String                $ensure          = 'present',
  Optional[String]      $webserver_class = '::psick::apache::tp',
  Optional[String]      $dbserver_class  = '::psick::mariadb::tp',
  Boolean               $auto_prereq = true,
  Optional[String]      $template        = undef,
  Hash                  $options          = { },
  Optional[Enum['mysql','pgsql']] $db_backend = 'mysql',
  Boolean $fix_php_timezone = true,


) {

  if $webserver_class and $webserver_class != '' {
    contain $webserver_class
  }
  if $dbserver_class and $dbserver_class != '' {
    contain $dbserver_class
  }

  $options_default = {
  }
  $real_options = $options_default + $options
  ::tp::install { 'icingaweb2' :
    ensure             => $ensure,
    auto_prereq => $auto_prereq,
  }

  if $template {
    ::tp::conf { 'icingaweb2':
      ensure       => $ensure,
      template     => $template,
      base_dir     => 'conf',
      options_hash => $real_options,
    }
  }

  if $db_backend {
    $camel_db_backend = $db_backend ? {
      'mysql' => 'Mysql',
      'pgsql' => 'Pgsql',
    }
    package { "icinga2-ido-${db_backend}": }
    package { "php-ZendFramework-Db-Adapter-Pdo-${camel_db_backend}": }
  }

  if $fix_php_timezone {
    augeas { 'php_date_timezone':
      context => '/files/etc/php.ini/DATE',
      changes => [
        "set date.timezone ${::psick::timezone}",
      ],
    }
  }
  if $::selinux {
    package { 'icingaweb2-selinux': }
  }

}
