#!/usr/bin/env perl
#

use Test::More;
use Test::Deep;
use lib 'lib';
use JSON;

plan qw/no_plan/;

BEGIN { use_ok('Net::Etcd'); }

#my $etcd = Net::Etcd->new(debug => 1);
my $etcd = Net::Etcd->new();
isa_ok($etcd, Net::Etcd);

my $msg = $etcd->get('message', 'raw');
cmp_deeply(
    $msg, {
        "action" => "get",
        "node"   => {
            "key"           => "/message",
            "value"         => "Helo",
            "modifiedIndex" => 6,
            "createdIndex"  => 6
        }
    },
    '"get" got right value'
);
my $msg2 = $etcd->get('message2');
cmp_deeply($msg2, { error => 'not found' }, '"get" did not find value');
my $msg3 = $etcd->get('tree', 'raw');
cmp_deeply(
    $msg3, {
        "action" => "get",
        "node"   => {
            "key"   => "/tree",
            "dir"   => JSON::true,
            "nodes" => [ {
                    "key"           => "/tree/leave1",
                    "value"         => "true",
                    "modifiedIndex" => 7,
                    "createdIndex"  => 7
                }, {
                    "key"           => "/tree/leave2",
                    "value"         => "string",
                    "modifiedIndex" => 8,
                    "createdIndex"  => 8
                }
            ],
            "modifiedIndex" => 7,
            "createdIndex"  => 7
        }
    },
    '"get" got a dir'
);

my $msg4 = $etcd->get('tree');
cmp_deeply($msg4, { tree => { leave1 => 'true', leave2 => 'string' }}, '"get" got a deep parsed hash' );

my $msg5 = $etcd->get('message');
cmp_deeply($msg5, { message => 'Helo' }, '"get" got a parsed hash');
