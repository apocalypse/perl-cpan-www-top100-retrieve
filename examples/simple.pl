#!/usr/bin/perl
use strict; use warnings;

use CPAN::WWW::Top100::Retrieve;
use Data::Dumper;

my $top100 = CPAN::WWW::Top100::Retrieve->new;
my $data = $top100->retrieve or die $top100->error;
print Dumper( $data );
exit;
