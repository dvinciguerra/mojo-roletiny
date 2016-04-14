#!/usr/bin/env perl 
use 5.10.0;
use strict;
use warnings;

package Does::Encode::SHA1 {
  use Mojo::Role -role; # automatic load Mojo::Base -strict

  # imports
  use Digest::SHA1 qw/sha1_hex/;

  # method required (die unless caller can)
  requires 'as_hash';
 
  sub encode {
    my $self = shift;
    return sha1_hex $self->as_hash;
  }
}

In your class:

package App::Controller::Home {
  use Mojo::Base 'Mojolicious::Controller';

  # load roles
  use Mojo::Role -with;
  with 'Does::Encode::SHA1';

  # attributes
  has '_data' => {};


  # methods
  sub do_something {
    my $self = shift;

    # call encode method
    my $enc = $self->encode;

    ...
  }

  # required method
  sub as_hash {
    return $_[0]->_data
  }
}


