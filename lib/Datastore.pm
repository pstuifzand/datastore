package Datastore;

use strict;
use warnings;

use DBIx::DWIW;
use Storable qw/freeze thaw/;

sub new {
    my ($klass, $config) = @_;

    my $self = {};

    $self->{DB} = DBIx::DWIW->Connect(
        %$config
    );

    return bless $self, $klass;
}

sub get {
    my ($self, $id) = @_;
    my $object = thaw($self->{DB}->Scalar("SELECT `body` FROM `entities` WHERE `id` = ?", pack 'h*', $id));
    return $object;
}

sub create_uuid {
    my ($self) = @_;

    my @c = ('0' .. '9', 'a' .. 'f');

    my $s;

    for (1..32) {
        $s .= $c[rand(@c)];
    }
    return $s;
}

sub put {
    my ($self, $object) = @_;

    if ($object->{id}) {
        $self->{DB}->Execute("UPDATE `entities` SET `updated` = NOW(), `body` = ? WHERE `id` = ?", freeze($object), pack('h*', $object->{id}));
        return $object->{id};
    }
    else {
        $object->{id} = $self->create_uuid();
        $self->{DB}->Execute("INSERT INTO `entities` (`id`, `body`, `created`, `updated`) VALUES (?, ?, NOW(), NOW())", pack('h*', $object->{id}), freeze($object));
        return $object->{id};
    }
}

sub delete {
    my ($self, $object) = @_;
    $self->{DB}->Execute("DELETE FROM `entities` WHERE `id` = ?", pack('h*', $object->{id}));
    return;
}

sub all {
    my ($self, $opt, $field, $dir) = @_;

    my @d = $self->{DB}->Hashes("SELECT `body` FROM `entities` ORDER BY `$field` $dir LIMIT $opt->{limit}");

    my @all;

    for (@d) {
        push @all, thaw($_->{body});
    }

    return \@all;
}

1;

