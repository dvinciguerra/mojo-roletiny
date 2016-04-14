#!perl 

# pragmas
use 5.10.0;
use strict;
use warnings;

# imports
use FindBin;
use lib "$FindBin::Bin/lib";
use lib "$FindBin::Bin/../lib";

use Test::More;
use Mojo::Role;

# test class
use People;
use Developer;
use MojoCoreMantainer;


subtest 'test for class base' => sub {
  isa_ok 'MojoCoreMantainer', 'Mojo::Role';
};

subtest 'test for role type' => sub {
  isa_ok 'MojoCoreMantainer', 'Mojo::Role';
};

subtest 'test with function' => sub {
  ok !Developer->isa('Mojo::Role');
  can_ok 'People', 'with';
};

subtest 'test for class loader' => sub {
  # not a role
  eval { Mojo::Role::_load_class('People') };
  ok $@;

  # not exists
  eval { Mojo::Role::_load_class('ClassThatNotExists') };
  ok $@;

  # ok
  eval { Mojo::Role::_load_class('MojoCoreMantainer') };
  ok !$@;
};

subtest 'test for with' => sub {
  # load class and method
  eval { Mojo::Role::with(__PACKAGE__, 'TestWith') };
  ok !$@;

  # method is loaded?
  is test_method(), 1;
};

done_testing();

