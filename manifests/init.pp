class avahi {

  # Install dependencies.
  package {['python-avahi', 'python-pip']:
    ensure  => present,
  }

  # Install daemon.
  exec { 'avahi pip':
    command => '/usr/bin/pip install git+git://github.com/PraxisLabs/avahi-aliases.git',
    require => Package['python-avahi', 'python-pip'],
  }

  # Install Provision extension.
  drush::git {'provision_avahi':
    path     => '/var/aegir/.drush/',
    git_repo => 'git://github.com/PraxisLabs/avahi-aliases.git',
    dir_name => 'provision_avahi',
    user     => 'aegir',
  }

  # Allow 'aegir' user to restart the avahi-aliases daemon.
  file {'/etc/sudoers.d/aegir-avahi':
    source => 'puppet:///avahi/aegir-avahi.sudoers',
    mode   => '440',
    owner  => 'root',
    group  => 'root',
  }

  # Provide a file for aegir to register installed sites.
  file {'/etc/avahi/aliases.d/aegir':
    target => '/var/aegir/config/avahi-aliases',
    ensure => 'link',
  }

}
