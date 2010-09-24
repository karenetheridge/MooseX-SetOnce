package MooseX::SetOnce::Attribute;
use Moose::Role 0.90;

before set_value => sub { $_[0]->_ensure_unset($_[1]) };

sub _ensure_unset {
  my ($self, $instance) = @_;
  Carp::confess("cannot change value of SetOnce attribute")
    if $self->has_value($instance);
}

around accessor_metaclass => sub {
  my ($orig, $self, @rest) = @_;

  return Moose::Meta::Class->create_anon_class(
    superclasses => [ $self->$orig(@_) ],
    roles => [ 'MooseX::SetOnce::Accessor' ],
    cache => 1
  )->name
};

package Moose::Meta::Attribute::Custom::Trait::SetOnce;
sub register_implementation { 'MooseX::SetOnce::Attribute' }

1;
