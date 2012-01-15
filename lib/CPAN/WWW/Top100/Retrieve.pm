# Declare our package
package CPAN::WWW::Top100::Retrieve;

# ABSTRACT: Retrieves the CPAN Top100 data from http://ali.as/top100

# import the Moose stuff
use Moose;
use MooseX::StrictConstructor 0.08;
use Moose::Util::TypeConstraints;
use Params::Coerce;
use namespace::autoclean;

# get some utility stuff
use LWP::UserAgent;
use URI;
use HTML::TableExtract;

use CPAN::WWW::Top100::Retrieve::Dist;
use CPAN::WWW::Top100::Retrieve::Utils qw( default_top100_uri dbids type2dbid dbid2type );

has 'debug' => (
	isa		=> 'Bool',
	is		=> 'rw',
	default		=> sub { 0 },
);

has 'ua' => (
	isa		=> 'LWP::UserAgent',
	is		=> 'rw',
	required	=> 0,
	lazy		=> 1,
	default		=> sub {
		LWP::UserAgent->new;
	},
);

has 'error' => (
	isa		=> 'Str',
	is		=> 'ro',
	writer		=> '_error',
);

# Taken from Moose::Cookbook::Basics::Recipe5
subtype 'My::Types::URI' => as class_type('URI');

coerce 'My::Types::URI'
	=> from 'Object'
		=> via {
			$_->isa('URI') ? $_ : Params::Coerce::coerce( 'URI', $_ );
		}
	=> from 'Str'
		=> via {
			URI->new( $_, 'http' )
		};

has 'uri' => (
	isa		=> 'My::Types::URI',
	is		=> 'rw',
	required	=> 0,
	lazy		=> 1,
	default		=> sub {
		default_top100_uri();
	},
	coerce		=> 1,
);

has '_data' => (
	isa		=> 'HashRef',
	is		=> 'ro',
	default		=> sub { {} },
);

sub _retrieve {
	my $self = shift;

	# Do we already have data?
	if ( keys %{ $self->_data } > 0 ) {
		warn "Using cached data" if $self->debug;
		return 1;
	} else {
		warn "Starting retrieve run" if $self->debug;
	}

	# Okay, get the data via LWP
	warn "LWP->get( " . $self->uri . " )" if $self->debug;
	my $response = $self->ua->get( $self->uri );
	if ( $response->is_error ) {
		my $errstr = "LWP Error: " . $response->status_line . "\n" . $response->content;
		$self->_error( $errstr );
		warn $errstr if $self->debug;
		return 0;
	}

	# Parse it!
	return $self->_parse( $response->content );
}

sub _parse {
	my $self = shift;
	my $content = shift;

	# Get the tables!
	foreach my $dbid ( sort { $a <=> $b } @{ dbids() } ) {
		warn "Parsing dbid $dbid..." if $self->debug;

		my $table_error;
		my $table = HTML::TableExtract->new( attribs => { id => "ds$dbid" }, error_handle => \$table_error );
		$table->parse( $content );

		if ( ! $table->tables ) {
			my $errstr = "Unable to parse table $dbid";
			$errstr .= " $table_error" if length $table_error;
			$self->_error( $errstr );
			warn $errstr if $self->debug;
			return 0;
		}

		foreach my $ts ( $table->tables ) {
			# Store it in our data struct!
			my %cols;
			foreach my $row ( $ts->rows ) {
				if ( ! keys %cols ) {
					# First row, the headers!
					my $c = 0;
					%cols = map { $_ => $c++ } @$row;
				} else {
					# Make the object!
					my $obj = CPAN::WWW::Top100::Retrieve::Dist->new(
						## no critic ( ProhibitAccessOfPrivateData )
						'dbid'		=> $dbid,
						'type'		=> dbid2type( $dbid ),
						'rank'		=> $row->[ $cols{ 'Rank' } ],
						'author'	=> $row->[ $cols{ 'Author' } ],
						'dist'		=> $row->[ $cols{ 'Distribution' } ],

						# ugly logic here, but needed to "collate" the different report types
						'score'		=> ( exists $cols{ 'Dependencies' } ? $row->[ $cols{ 'Dependencies' } ] :
									( exists $cols{ 'Dependents' } ? $row->[ $cols{ 'Dependents' } ] :
										( exists $cols{ 'Score' } ? $row->[ $cols{ 'Score' } ] : undef ) ) ),
					);

					push( @{ $self->_data->{ $dbid } }, $obj );
				}
			}
		}
	}

	return 1;
}

sub list {
	my $self = shift;
	my $type = shift;

	return if ! defined $type or ! length $type;
	$type = type2dbid( lc( $type ) );
	return if ! defined $type;

	# if we haven't retrieved yet, do it!
	return if ! $self->_retrieve;

	# Generate a copy of our data
	my @r = ( @{ $self->_data->{ $type } } );
	return \@r;
}

# from Moose::Manual::BestPractices
no Moose;
__PACKAGE__->meta->make_immutable;

1;

=pod

=for stopwords Top100 AnnoCPAN CPANTS Kwalitee RT com diff dists github ua uri

=head1 SYNOPSIS

	#!/usr/bin/perl
	use strict; use warnings;

	use CPAN::WWW::Top100::Retrieve;
	use Data::Dumper;

	my $top100 = CPAN::WWW::Top100::Retrieve->new;
	print Dumper( $top100->list( 'heavy' ) );

=head1 DESCRIPTION

This module retrieves the data from CPAN Top100 and returns it in a structured format.

=head2 Constructor

This module uses Moose, so you can pass either a hash or hashref to the constructor. The object will cache all
data relevant to the Top100 for as long as it's alive. If you want to get fresh data just make a new object and
use that.

The attributes are:

=head3 debug

( not required )

A boolean value specifying debug warnings or not.

The default is: false

=head3 ua

( not required )

The LWP::UserAgent object to use in place of the default one.

The default is: LWP::UserAgent->new;

=head3 uri

( not required )

The uri of Top100 data we should use to retrieve data in place of the default one.

The default is: CPAN::WWW::Top100::Retrieve::Utils::default_top100_uri()

=head2 Methods

Currently, there is only one method: list(). You call this and get the arrayref of data back. For more
information please look at the L<CPAN::WWW::Top100::Retrieve::Dist> class. You can call list() as
many times as you want, no need to re-instantiate the object for each query.

=head3 list

Takes one argument: the $type of Top100 list and returns an arrayref of dists.

WARNING: list() will return an empty list if errors happen. Please look at the error() method for the string.

Example:

	use Data::Dumper;
	print Dumper( $top100->list( 'heavy' ) );
	print Dumper( $top100->list( 'volatile' ) );

=head3 error

Returns the error string if it was set, undef if not.

=head1 SEE ALSO

L<CPAN::WWW::Top100::Retrieve::Dist>
L<CPAN::WWW::Top100::Retrieve::Utils>

=cut
