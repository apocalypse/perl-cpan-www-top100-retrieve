#!/usr/bin/perl
use strict; use warnings;

use CPAN::WWW::Top100::Retrieve;
use Data::Dumper;

#my $top100 = CPAN::WWW::Top100::Retrieve->new( debug => 1 );
my $top100 = CPAN::WWW::Top100::Retrieve->new;

# structured output
foreach my $type ( qw( heavy volatile ) ) {
	my $c = 0;
	my $res = $top100->list( $type );
	if ( ! defined $res ) {
		warn $top100->error;
		next;
	}
	foreach my $dist ( @$res ) {
		if ( ++$c > 10 ) {
			last;
		}

		print uc( $type ) . " List($c): " . $dist->dist . " (" . $dist->author . ")\n";
	}
}

# Output all
#print "HEAVY List: " . Dumper( $top100->list( 'heavy' ) );
#print "\n\nVOLATILE List: " . Dumper( $top100->list( 'volatile' ) );
