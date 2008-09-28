#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 1;
use WWW::Ruten;

my $ruten = new WWW::Ruten;

$ruten->search("iPod");
$ruten->each(
    sub {
        my ($self) = @_;

        diag $self->{title};
        diag $self->{url};
    }
);

ok("Program finished without problem.");

