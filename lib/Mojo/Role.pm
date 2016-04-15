package Mojo::Role;

# ABSTRACT: Mojo::Role - Tiny and simple role system for Mojo

# imports
use strict;
use warnings;
use Role::Tiny       ();
use Role::Tiny::With ();
use Mojo::Base       ();

# version
our $VERSION = 0.021;

sub import {
  $_->import for qw(strict warnings utf8);
  feature->import(':5.10');

  # import with
  if (@_ > 1 and $_[1] eq '-with') {
    @_ = 'Role::Tiny::With';
    goto &Role::Tiny::With::import;
  }

  my $target = caller;
  my $has = sub { Mojo::Base::attr($target, @_) };
  { no strict 'refs'; *{"${target}::has"} = $has }

  @_ = 'Role::Tiny';
  goto &Role::Tiny::import;
}

1;
__END__
=encoding utf8

=head1 NAME

Mojo::Role - Tiny and simple role system for Mojo
 
=head1 SYNOPSIS
 
  # role class
  package MojoCoreMantainer;
  use Mojo::Role;
  
  sub mantaining_mojo {
    say "I'm making improvements for Mojolicious..."
  }


  # base class
  package Developer;
  use Mojo::Base -base;
  
  sub make_code {
    say "I'm making code for Mojolicious ecosystem..."
  }


  # class
  package People;
  use Mojo::Base 'Developer';
  
  # using roles
  use Mojo::Role -with;
  with 'MojoCoreMantainer';
  
  # method
  sub what_can_i_do {
    my $self = shift;
    say "I can do people things...";
    $self->make_code;
    $self->mantaining_mojo;
  }


=head1 DESCRIPTION

This module provide a simple and dependence free way to use roles in 
L<Mojolicious|http://mojolicious.org/> classes.

  # For a role class
  use Mojo::Role;
  
  # To import/use a role
  use Mojo::Role -with;
  with 'Role::SomeRoleClass';


=head1 FUNCTIONS

Mojo::Role implement C<with> function, that can be imported with the C<-with> flag.

=head2 with

  with 'SomeRoleClass';

Import a role or a list of roles to use.


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016, Daniel Vinciguerra <daniel.vinciguerra at bivee.com.br>

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.


=head1 SEE ALSO

L<https://github.com/kraih/mojo>, L<Mojo::Base>, L<Role::Tiny>, L<http://mojolicious.org>.


