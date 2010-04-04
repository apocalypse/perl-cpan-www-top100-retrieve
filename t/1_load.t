#!/usr/bin/perl
use strict; use warnings;

my $numtests;
BEGIN {
	$numtests = 3;

	eval "use Test::NoWarnings";
	if ( ! $@ ) {
		# increment by one
		$numtests++;
	}
}

use Test::More tests => $numtests;

use_ok( 'CPAN::WWW::Top100::Retrieve::Utils' );
use_ok( 'CPAN::WWW::Top100::Retrieve::Dist' );
use_ok( 'CPAN::WWW::Top100::Retrieve' );
