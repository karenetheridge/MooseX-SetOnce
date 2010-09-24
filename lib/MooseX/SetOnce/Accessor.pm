package MooseX::SetOnce::Accessor;
use Moose::Role 0.90;

around _inline_store => sub {
  my ($orig, $self, $instance, $value) = @_;

  my $code = $self->$orig($instance, $value);
  $code = sprintf qq[%s->meta->get_attribute("%s")->_ensure_unset(%s);\n%s],
    $instance,
    quotemeta($self->associated_attribute->name),
    $instance,
    $code;

  return $code;
};

1;
