class bandersnatch ($document_root = '/srv/pypi') {

  package { 'bandersnatch':
    ensure    => present,
    require   => User['bandersnatch'],
    provider  => pip,
  }

  group { 'bandersnatch':
    ensure  => present,
    name    => 'bandersnatch',
  }

  user { 'bandersnatch':
    ensure  => present,
    home    => $document_root,
    require => Group['bandersnatch'],
  }

  file { '/etc/bandersnatch.conf':
    ensure  => present,
    content => template('bandersnatch/etc/bandersnatch.conf.erb'),
    mode    => '0644',
  }

  file { $document_root:
    ensure  => 'directory',
    owner   => 'bandersnatch',
    group   => 'bandersnatch',
    mode    => '0755',
  }

  cron { 'bandersnatch':
    command => 'bandersnatch mirror |& logger -t bandersnatch[mirror]',
    user    => bandersnatch,
    hour    => '*/2',
  }

}
