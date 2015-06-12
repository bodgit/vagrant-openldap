include ::openldap
include ::openldap::client

class { '::openldap::server':
  root_dn         => 'cn=Manager,dc=example,dc=com',
  root_password   => '{SSHA}7dSAJPGe4YKKEvUPuGJIeSL/03GV2IMY',
  suffix          => 'dc=example,dc=com',
  access          => [
    'to attrs=userPassword by self =xw by anonymous auth',
    'to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage by self write by users read',
  ],
  indices         => [
    'objectClass eq,pres',
    'ou,cn,mail,surname,givenname eq,pres,sub',
  ],
  ldap_interfaces => [$ipaddress],
}
::openldap::server::schema { 'cosine':
  position => 1,
}
::openldap::server::schema { 'inetorgperson':
  position => 2,
}
::openldap::server::schema { 'nis':
  position => 3,
}

include ::firewall

firewall { '000 accept related established rules':
  proto  => all,
  state  => ['RELATED', 'ESTABLISHED'],
  action => accept,
}->
firewall { '001 accept all icmp':
  proto  => icmp,
  action => accept,
}->
firewall { '002 accept all to lo interface':
  proto   => all,
  iniface => lo,
  action  => accept,
}->
firewall { '003 allow ssh access':
  dport  => 22,
  proto  => tcp,
  state  => 'NEW',
  action => accept,
}->
firewall { '004 allow ldap access':
  dport  => 389,
  proto  => tcp,
  state  => 'NEW',
  action => accept,
}->
firewall { '999 reject all input':
  proto  => all,
  action => reject,
}->
firewall { '999 reject all forward':
  chain  => 'FORWARD',
  proto  => all,
  action => reject,
}

resources { 'firewall':
  purge => true,
}
