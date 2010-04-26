#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Thread::Actor' );
}

diag( "Testing Thread::Actor $Thread::Actor::VERSION, Perl $], $^X" );
