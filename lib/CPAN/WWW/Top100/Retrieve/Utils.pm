# Declare our package
package CPAN::WWW::Top100::Retrieve::Utils;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# set ourself up for exporting
use base qw( Exporter );
our @EXPORT_OK = qw( default_top100_uri
	dbid2type type2dbid types dbids
);

sub default_top100_uri {
	return 'http://ali.as/top100/data.html';
}

# TODO hardcoded from CPAN::WWW::Top100::Generator v0.08
my %dbid_type = (
	1	=> 'heavy',
	2	=> 'volatile',
	3	=> 'debian',
	4	=> 'downstream',
	5	=> 'meta1',
	6	=> 'meta2',
	7	=> 'meta3',
	8	=> 'fail',
);
my %type_dbid;
foreach my $k ( keys %dbid_type ) {
	$type_dbid{ $dbid_type{ $k } } = $k;
}

sub dbid2type {
	my $id = shift;
	if ( exists $dbid_type{ $id } ) {
		return $dbid_type{ $id };
	} else {
		return;
	}
}
sub type2dbid {
	my $type = shift;
	if ( exists $type_dbid{ $type } ) {
		return $type_dbid{ $type };
	} else {
		return;
	}
}

sub types {
	return [ keys %type_dbid ];
}

sub dbids {
	return [ keys %dbid_type ];
}

1;
__END__

=for stopwords todo Top100 IDs dbid dbids uri

=head1 NAME

CPAN::WWW::Top100::Retrieve::Utils - Various utilities for Top100 retrieval

=head1 SYNOPSIS

	#!/usr/bin/perl
	use strict; use warnings;
	use CPAN::WWW::Top100::Retrieve::Utils qw( default_top100_uri );
	print "The default Top100 uri is: " . default_top100_uri() . "\n";

=head1 DESCRIPTION

This module holds the various utility functions used in the Top100 modules. Normally you wouldn't
need to use this directly.

=head2 Methods

=head3 default_top100_uri

Returns the Top100 uri we use to retrieve data.

The current uri is:

	return 'http://ali.as/top100/data.html';

=head3 types

Returns an arrayref of Top100 database types.

The current types is:

	return [ qw( heavy volatile debian downstream meta1 meta2 meta3 fail ) ];

=head3 dbids

Returns an arrayref of Top100 database type IDs.

The current dbids is:

	return [ qw( 1 2 3 4 5 6 7 8 ) ];

=head3 dbid2type

Returns the type given a dbid.

=head3 type2dbid

Returns the dbid given a type.

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with this module.

=cut
