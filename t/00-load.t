#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Lingua::RU::Numbers' ) || print "Bail out!\n";
}

diag( "Testing Lingua::RU::Numbers $Lingua::RU::Numbers::VERSION, Perl $], $^X" );
