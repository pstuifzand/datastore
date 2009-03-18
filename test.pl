use strict;
use warnings;

use lib 'lib';

use Datastore;
use Data::Dumper;
use YAML;

my $config = YAML::LoadFile('db.yml');

my $ds = Datastore->new($config);

my $l = $ds->all({ limit => 10 }, created => 'DESC');

for (@$l) {
    print Dumper($_);
}

