use strict;
use warnings;

use Test::More tests => 12;
use Try::Tiny;

use lib 'lib';

{
  package Apple;
  use Moose;
  use MooseX::SetOnce;

  has color => (
    is     => 'rw',
    traits => [ qw(SetOnce) ],
  );
}

{
  package Orange;
  use Moose;
  use MooseX::SetOnce;

  has color => (
    reader => 'get_color',
    writer => 'set_color',
    traits => [ qw(SetOnce) ],
  );
}

for my $set (
  [ Apple   => qw(    color     color) ],
  [ Orange  => qw(get_color set_color) ],
) {
  my ($class, $getter, $setter) = @$set;
  my $object = $class->new;

  {
    my $error;
    my $died = try {
      $object->$setter('green');
      return;
    } catch {
      $error = $_;
      return 1;
    };

    ok( ! $died, "can set a SetOnce attr once") or diag $error;
    is($object->$getter, 'green', "it has the first value we set");
  }

  {
    my $error;
    my $died = try {
      $object->$setter('blue');
      return;
    } catch {
      $error = $_;
      return 1;
    };

    ok( $died, "can't set a SetOnce attr twice (via $setter)");
    is($object->$getter, 'green', "it has the first value we set");
  }

  {
    my $error;
    my $died = try {
      $object->meta->get_attribute('color')->set_value($object, 'yellow');
      return;
    } catch {
      $error = $_;
      return 1;
    };

    ok( $died, "can't set a SetOnce attr twice (via set_value)");
    is($object->$getter, 'green', "it has the first value we set");
  }
}

