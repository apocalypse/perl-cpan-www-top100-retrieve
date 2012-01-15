# Declare our package
package CPAN::WWW::Top100::Retrieve::Dist;

# ABSTRACT: Describes a dist in the Top100

# import the Moose stuff
use Moose;
use MooseX::StrictConstructor 0.08;
use namespace::autoclean;

has 'type' => (
	isa		=> 'Str',
	is		=> 'ro',
	required	=> 1,
);

has 'dbid' => (
	isa		=> 'Int',
	is		=> 'ro',
	required	=> 1,
);

# Common to all types
has 'rank' => (
	isa		=> 'Int',
	is		=> 'ro',
	required	=> 1,
);

has 'author' => (
	isa		=> 'Str',
	is		=> 'ro',
	required	=> 1,
);

has 'dist' => (
	isa		=> 'Str',
	is		=> 'ro',
	required	=> 1,
);

has 'score' => (
	isa		=> 'Int',
	is		=> 'ro',
	required	=> 1,
);

# from Moose::Manual::BestPractices
no Moose;
__PACKAGE__->meta->make_immutable;

1;

=pod

=for stopwords dbid dist

=head1 SYNOPSIS

	#!/usr/bin/perl
	use strict; use warnings;
	use CPAN::WWW::Top100::Retrieve;

	my $top100 = CPAN::WWW::Top100::Retrieve->new;
	foreach my $dist ( @{ $top100->list( 'heavy' ) } ) {
		print "Heavy dist(" . $dist->dist . ") rank(" . $dist->rank .
			") author(" . $dist->author . ") score(" .
			$dist->score . ")\n";
	}

=head1 DESCRIPTION

This module holds the info for a distribution listed in the Top100.

=head2 Attributes

Those attributes hold information about the distribution.

=head3 type

The type of Top100 this dist is listed on.

Example: heavy

=head3 dbid

The dbid of Top100 this dist is listed on.

Example: 1

=head3 rank

The rank of this dist on the Top100 list.

Example: 81

=head3 author

The author of this dist.

Example: LBROCARD

=head3 dist

The distribution name.

Example: Tapper-MCP

=head3 score

The score of the distribution on the Top100 list.

Example: 153

If the type is: heavy

	The score is the number of downstream dependencies

If the type is: volatile, debian, downstream, meta1/2/3

	The score is the number of dependent modules

If the type is: fail

	The score is the FAIL score

=cut

