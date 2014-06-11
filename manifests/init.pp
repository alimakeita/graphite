#This is the init file that will launch the graphite application

class graphite {
#    include graphite::pack-graphite
#	include graphite::web
#	include graphite::whisper
#	include graphite::carbon
    
#    package { 'python-pip': 
#        ensure => 'present',
#     }
}

class graphite::web {
#  package {'bitmap':
#    ensure => present,
#  }

  package {"graphite-web":
    ensure => present,
    provider => pip,
#    require =>  Package['python-pip'],
 }


#  service { 'httpd':
#    ensure     => running,
#    enable     => true,
#    hasrestart => true,
#    hasstatus  => true,
#  }

   file {'/opt/graphite':
     ensure => directory,
   }   

   
  file {"local_settings.py":
    path => "/opt/graphite/webapp/graphite/local_settings.py",
    ensure => file,
    owner   => "root",
    group   => "root",
    mode    => "0644",
#    notify  => Service["httpd"],
    content => template("graphite/local_settings.py.erb"),
   }

}

class graphite::carbon {


#    exec {'Twisted-13.2.0':
#        command => '/usr/bin/curl http://twistedmatrix.com/Releases/Twisted/13.2/Twisted-13.2.0.tar.bz2 | tar -xjvf /opt/ && cd Twisted-13.2.0 && /usr/bin/python setup.py install',
#        cwd => '/opt/',
#        path => '/usr/bin/curl, /bin/tar, /usr/bin/python',
#    }

#    exec {'Twisted-13.2.0':
#        command => '/usr/bin/wget http://twistedmatrix.com/Releases/Twisted/13.2/Twisted-13.2.0.tar.bz2',
#        cwd => '/opt/',
#        path => '/usr/bin/wget',
#    }

    file {'/opt/Twisted-13.2.0.tar.bz2':
        source => 'puppet:///modules/graphite/Twisted-13.2.0.tar.bz2',
        notify => Exec["unpack Twisted"]
    }

 #   file {'/opt/Twisted-13.2.0':
  #      ensure => directory,
  #  } 

   exec {'unpack Twisted':
      command => '/bin/tar -xjvf /opt/Twisted-13.2.0.tar.bz2',
#       creates => '/opt/Twisted-13.2.0',       
       cwd => '/opt',
#      subscribe => File['/opt/Twisted-13.2.0.tar.bz2'],
       refreshonly => true,
#       path => '/bin/tar',
        notify => Exec["install Twisted"],
  }


#    exec {'untar-twisted':
#        command => 'tar xjvf /opt/Twisted-13.2.0.tar.bz2',
#       }


    exec {'install Twisted':
        cwd => '/opt/Twisted-13.2.0',
        command => '/usr/bin/python setup.py install',
        creates => '/opt/Twisted-13.2.0/setup.py',
        path => '/usr/bin/python',
    }
  
  package {"carbon":
    ensure => present,
    provider => pip,
    require => File['/opt/graphite'],
  }
  
  package {"daemonize":
    ensure => present,
    provider => pip,
  }

  file {'/opt/graphite/lib/carbon/util.py':
    ensure => present,
    source => 'puppet:///modules/graphite/util.py',
    mode =>'0755',
    require => Package['carbon'],
  }

  file { '/etc/init.d/carbon-cache':
    ensure => present,
    source => 'puppet:///modules/graphite/carbon-cache-init.sh',
    mode => '0755',
    require => Package['carbon'],
   }

  file { '/etc/init.d/carbon-relay':
    ensure => present,
    source => 'puppet:///modules/graphite/carbon-relay-init.sh',
    mode => '0755',
    require => Package['carbon'],
   }

  file { '/etc/init.d/carbon-aggregator':
    ensure => present,
    source => 'puppet:///modules/graphite/carbon-aggregator-init.sh',
    mode => '0755',
    require => Package['carbon'],
   }

  file {'/etc/httpd/conf/extra/vhosts-enabled/graphite-vhosts.conf':
    ensure => present,
    source => 'puppet:///modules/graphite/graphite-vhosts.conf',
    mode => '0644',
#    notify => Service['httpd'],
   }

  service { 'carbon-cache':
    ensure     => running,
    enable     => true,
##  hasrestart => true,
##    hasstatus  => true,
    require    => File['/etc/init.d/carbon-cache'],
  }

  file {'/opt/graphite/conf/carbon.conf':
    ensure => present,
    source => 'puppet:///modules/graphite/carbon.conf',
    mode => '0644' ,
   }

  file {'/opt/graphite/conf/graphite.wsgi':
    ensure => present,
    source => 'puppet:///modules/graphite/graphite.wsgi',
    mode => '0644',
   }

  file {'/opt/graphite/conf/storage-aggregation.conf':
    ensure => present,
    source => 'puppet:///modules/graphite/storage-aggregation.conf',
    mode => '0644',
   }

  file {'/opt/graphite/conf/storage-schemas.conf':
    ensure => present,
    source => 'puppet:///modules/graphite/storage-schemas.conf',
    mode => '0644',
   }
}

class graphite::whisper { 

    package { "whisper":
     ensure => present,
     provider => pip,
     require => File['/opt/graphite'],
#     require => Package['python-pip'],
  }

    file {'/opt/graphite/storage/delete_wspfiles':
        ensure => present,
        source => 'puppet:///modules/graphite/delete_wspfiles',
        mode => '0644',
    }
}
