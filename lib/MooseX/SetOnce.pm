use strict;
use warnings;
package MooseX::SetOnce;
# ABSTRACT: write-once, read-many attributes for Moose

# XXX TODO: here is where we would call Moose::Exporter
use MooseX::SetOnce::Attribute;
use MooseX::SetOnce::Accessor;

=head1 SYNOPSIS

Add the "SetOnce" trait to attributes:

  package Class;
  use Moose;
  use MooseX::SetOnce;

  has some_attr => (
    is     => 'rw',
    traits => [ qw(SetOnce) ],
  );

...and then you can only set them once:

  my $object = Class->new;

  $object->some_attr(10);  # works fine
  $object->some_attr(20);  # throws an exception: it's already set!

=head1 DESCRIPTION

The 'SetOnce' attribute lets your class have attributes that are not lazy and
not set, but that cannot be altered once set.

The logic is very simple:  if you try to alter the value of an attribute with
the SetOnce trait, either by accessor or writer, and the attribute has a value,
it will throw an exception.

If the attribute has a clearer, you may clear the attribute and set it again.

=cut


1;
