# Opscenter appliance for STUPS

This is an appliance that you can use to deploy [Opscenter](http://www.datastax.com/products/datastax-enterprise-visual-admin) on your [STUPS](https://stups.io) environment.

The appliance will register itself with its internal IP address to an existing Etcd cluster.
That IP address can be used by other tools and appliances to find it.
The key where you'll find the IP address is ``/cassandra/opscenter``.

You can easily create instances of this appliance using senza, part of the 
STUPS toolkit.

# Parameters

There are some parameters you can use to change the appliance's behavior. Some
of those parameters provide sane defaults but you can always override those
defaults with values that better match your own requirements.

    +----------------+---------------------------------------------------------+---------------------------+
    | Parameter      | Description                                             | Default                   |
    +----------------+---------------------------------------------------------+---------------------------+
    | EtcdDomain     | Your etcd appliance domain name                         | NONE                      |
    | TrustedNetwork | Trusted network to add to the public ELB security group | 127.0.0.0/8               |
    | ImageVersion   | Opscenter docker image version (for ex. 5.2.0-p0)       | 5.2.0-p0-SNAPSHOT         |
    | ApplicationId  | The application id according to yourturn                | stups-cassandra-opscenter |
    +----------------+---------------------------------------------------------+---------------------------+

The only mandatory parameter is the ``EtcdDomain``. The Opscenter appliance
will register itself in etcd as stated before. If you followed the instructions
from [Spilo](http://spilo.readthedocs.org/en/latest/user-guide/deploy_etcd/) 
you'll have an Etcd domain similar to etcd.<my-team-name>.<domain>.
This is the value you need to specify here.

All the remaining parameters have defaults and you don't need to override them
unless you want to. It's Important to mention that for security reasons the
appliance's public ELB is only accessible from within your VPC (172.16.0.0/12 network).
You can add your own trusted network using the ``TrustedNetwork`` parameter.

This appliance will be kept in sync with the latest Docker image deployed to 
STUPS Open Source Docker Registry (os-registry.stups.zalan.do). You can still
override this version to some other existing image if you need to using the
``ImageVersion`` parameter.

It's also possible that you created your own application record in YourTurn for
auditing purposes. If this is the case you can also override the ``ApplicationId``
parameter specifying your own application id.

## Howto

Creating an instance of this appliance is very easy. You just need to provide 1
parameter which is your etcd domain. Assuming your etc domain is
``etcd.god.example.com`` you would run senza like:

    senza create stups-opscenter.yaml etcd.god.example.com
    
## Known limitations

- There is no authentication. Secure the appliance using security groups.
