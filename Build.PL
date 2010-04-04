# Build.PL
use strict; use warnings;
use Module::Build;

my $build = Module::Build->new(
	# look up Module::Build::API for the info!
	'dynamic_config'	=> 0,
	'module_name'		=> 'CPAN::WWW::Top100::Retrieve',
	'license'		=> 'perl',

	'dist_abstract'		=> "Retrieves the CPAN Top100 data from http://ali.as/top100",
	'dist_author'		=> 'Apocalypse <APOCAL@cpan.org>',

	'create_packlist'	=> 1,
	'create_makefile_pl'	=> 'traditional',
	'create_readme'		=> 1,
	'create_license'	=> 1,
	'sign'			=> 0,

	'test_files'		=> 't/*.t',

	'requires'		=> {
		# WWW stuff, of course...
		'LWP::UserAgent'		=> 0,
		'URI'				=> 0,
		'HTML::TableExtract'		=> 0,

		# Our Moose stuff
		'Moose'				=> 0,
		'Moose::Util::TypeConstraints'	=> 0,
		'MooseX::StrictConstructor'	=> 0,
		'Params::Coerce'		=> 0,
		'namespace::autoclean'		=> 0,

		# we need a recent perl
		'perl'				=> '5.008',
	},

	# include the standard stuff in META.yml
	'meta_merge'	=> {
		'resources'	=> {
			'license'	=> 'http://dev.perl.org/licenses/',
			'homepage'	=> 'http://search.cpan.org/dist/CPAN-WWW-Top100-Retrieve',
			'bugtracker'	=> 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=CPAN-WWW-Top100-Retrieve',
			'repository'	=> 'http://github.com/apocalypse/perl-cpan-www-top100-retrieve',
		},
	},
);

# all done!
$build->create_build_script;
