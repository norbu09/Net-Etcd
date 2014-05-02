#!/usr/bin/env perl
#

use Test::More;
use Test::Deep;
use lib 'lib';
use JSON;

plan qw/no_plan/;

BEGIN { use_ok('Net::Etcd'); }

my $etcd = Net::Etcd->new(debug => 1);
isa_ok($etcd, Net::Etcd);

ok($etcd->set({foo => 'bar'}) eq undef, 'set "foo" to "bar"');
#ok($etcd->set({tree => {leave1 => 'true', leave2 => 'string'}}) eq undef, 'set "tree"');
