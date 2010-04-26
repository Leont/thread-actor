use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Thread::Actor',
    license             => 'perl',
    dist_author         => 'Leon Timmermans <leont@cpan.org>',
    dist_version_from   => 'lib/Thread/Actor.pm',
    build_requires => {
        'Test::More' => 0,
    },
	requires            => {
		'namespace::clean' => 0,
		'threads::lite'    => 0,
	},
    add_to_cleanup      => [ 'Thread-Actor-*' ],
    create_makefile_pl  => 'traditional',
);

$builder->create_build_script();
