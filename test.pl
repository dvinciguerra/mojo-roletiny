#!perl

use 5.10.0;
use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }


# People is Developer and does 'MojoCoreMantainer'
package People {
  use Mojo::Base 'Developer';

  # using roles
  use Mojo::Role -with;
  with 'MojoCoreMantainer';
  with 'PerlCoreMantainer';


  sub what_can_i_do {
    my $self = shift;
    say "I can do people things...";
    $self->make_code;
    $self->mantaining_mojo;
    $self->mantaining_perl;
  }
}

my $p = People->new;
$p->what_can_i_do;

use Data::Dumper;
no strict 'refs';
my $code = *{"People::"};
say Dumper *{$code->{what_can_i_do}}{CODE};


