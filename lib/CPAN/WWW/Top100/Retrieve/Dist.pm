# Declare our package
package CPAN::WWW::Top100::Retrieve::Dist;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# import the Moose stuff
use Moose;
use MooseX::StrictConstructor;
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
__END__

=for stopwords todo dbid dist

=head1 NAME

CPAN::WWW::Top100::Retrieve::Dist - Represents a distribution listed in the Top100

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

example: heavy

=head3 dbid

The dbid of Top100 this dist is listed on.

=head3 rank

The rank of this dist on the Top100 list.

=head3 author

The author of this dist.

=head3 dist

The distribution name.

=head3 score

The score of the distribution on the Top100 list.

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with this module.

=cut

