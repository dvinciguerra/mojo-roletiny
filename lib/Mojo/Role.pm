package Mojo::Role;
use Mojo::Base -base;
# ABSTRACT: Mojo::Role - Tiny and simple role system for Mojo 

# pragmas
use strict;
use warnings;

# imports
use Carp qw(carp croak);
use Mojo::Loader qw(load_class);
use Scalar::Util qw(reftype);

# version
our $VERSION = 0.01;


sub import {
  my $class = shift;
  return unless my $mode = shift;

  no strict 'refs';
  no warnings 'redefine';

  # import with
  if($mode eq '-with') {
    my $caller = caller;
    Mojo::Base::_monkey_patch $caller, 'with', sub { with($caller, @_) };
  } 
  else {
    # import requires (role)
    Mojo::Base->import('-base');#('Mojo::Role');
  }
}

# with the role loader
sub with {
  my ($class, $role) = @_;

  # load just one role
  if(reftype(\$role) eq 'SCALAR'){
    _load_class($role);
    _load_methods($class, $role);
  }
 
  # load multi roles
  if(reftype(\$role) eq 'ARRAY'){
    for my $r (@$role){
      _load_class($r);
      _load_methods($class, $r);
    }
  }
}

sub _load_class {
  my ($class) = @_;
  my $e = load_class $class;
  croak qq{Error loading "$class": $e} if ref $e;

  croak qq{Class "$class" isn't a Mojo::Role based class} 
    unless $class->isa(__PACKAGE__);
}

sub _load_methods {
  my ($class, $role) = @_;

  # getting package
  no strict 'refs';
  my $package = *{"${role}::"};

  # iterate method (subs)
  my $methods = [];
  for my $sub (grep { !/^_/ } keys %$package) {
    my $code_ref = $package->{$sub};
    my $code = *$code_ref{CODE} or next;

    Mojo::Base::_monkey_patch($class, $sub, sub { $code_ref->() });
  }
}

1;
