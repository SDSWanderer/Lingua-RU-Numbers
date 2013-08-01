package Lingua::RU::Numbers;

use strict;
use warnings;
use v5.10;
use utf8;

use Exporter;
our $VERSION   = '0.06';
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(uah_in_words number_in_words);

use Carp;

my %diw = (
    0 => {
        0  => { 0 => "ноль",          1 => 1},
        1  => { 0 => "",              1 => 2},
        2  => { 0 => "",              1 => 3},
        3  => { 0 => "три",           1 => 0},
        4  => { 0 => "четыре",        1 => 0},
        5  => { 0 => "пять",          1 => 1},
        6  => { 0 => "шесть",         1 => 1},
        7  => { 0 => "семь",          1 => 1},
        8  => { 0 => "восемь",        1 => 1},
        9  => { 0 => "девять",        1 => 1},
        10 => { 0 => "десять",        1 => 1},
        11 => { 0 => "одиннадцать",   1 => 1},
        12 => { 0 => "двенадцать",    1 => 1},
        13 => { 0 => "тринадцать",    1 => 1},
        14 => { 0 => "четырнадцать",  1 => 1},
        15 => { 0 => "пятнадцать",    1 => 1},
        16 => { 0 => "шестнадцать",   1 => 1},
        17 => { 0 => "семнадцать",    1 => 1},
        18 => { 0 => "восемнадцать",  1 => 1},
        19 => { 0 => "девятнадцать" , 1 => 1},
    },
    1 => {
        2  => { 0 => "двадцать",      1 => 1},
        3  => { 0 => "тридцать",      1 => 1},
        4  => { 0 => "сорок",         1 => 1},
        5  => { 0 => "пятьдесят",     1 => 1},
        6  => { 0 => "шестьдесят",    1 => 1},
        7  => { 0 => "семьдесят",     1 => 1},
        8  => { 0 => "восемьдесят",   1 => 1},
        9  => { 0 => "девяносто",     1 => 1},
    },
    2 => {
        1  => { 0 => "сто",           1 => 1},
        2  => { 0 => "двести",        1 => 1},
        3  => { 0 => "триста",        1 => 1},
        4  => { 0 => "четыреста",     1 => 1},
        5  => { 0 => "пятьсот",       1 => 1},
        6  => { 0 => "шестьсот",      1 => 1},
        7  => { 0 => "семьсот",       1 => 1},
        8  => { 0 => "восемьсот",     1 => 1},
        9  => { 0 => "девятьсот",     1 => 1}
    }
);

my %nom = (
    0  =>  {0 => "копейки",   1 => "копеек",     2 => "одна копейка",  3 => "две копейки"},
    1  =>  {0 => "рубля",     1 => "рублей",     2 => "один рубль",    3 => "два рубля"},
    2  =>  {0 => "тысячи",    1 => "тысяч",      2 => "тысяча",        3 => "две тысячи"},
    3  =>  {0 => "миллиона",  1 => "миллионов",  2 => "один миллион",  3 => "два миллиона"},
    4  =>  {0 => "миллиарды", 1 => "миллиардов", 2 => "один миллиард", 3 => "два миллиарда"},
    5  =>  {0 => "триллион",  1 => "триллионов", 2 => "один триллион", 3 => "два триллиона"}
);

my $out_rub;

sub uah_in_words {
	my $sum = shift;
	return "ноль рублей ноль копеек" if $sum == 0;

	my ( $retval, $i, $sum_rub, $sum_kop );

	$retval  = "";
	$out_rub = ( $sum >= 1 ) ? 0 : 1;
	$sum_rub = sprintf( "%0.0f", $sum );
	$sum_rub-- if ( ( $sum_rub - $sum ) > 0 );
	$sum_kop = sprintf( "%0.2f", ( $sum - $sum_rub ) ) * 100;

	my $kop = get_string( $sum_kop, 0 );

	for ( $i = 1 ; $i < 6 && $sum_rub >= 1 ; $i++ ) {
		my $sum_tmp = $sum_rub / 1000;
		my $sum_part = sprintf( "%0.3f", $sum_tmp - int($sum_tmp) ) * 1000;
		$sum_rub = sprintf( "%0.0f", $sum_tmp );

		$sum_rub-- if ( $sum_rub - $sum_tmp > 0 );
		$retval = get_string( $sum_part, $i ) . " " . $retval;
	}
	$retval .= " рублей" if ( $out_rub == 0 );
	$retval .= " " . $kop;
	$retval =~ s/\s+/ /g;
	return $retval;
}

sub number_in_words {
	my ( $sum, $gender ) = @_;
	croak 'gender should be "FEMININE" or "MASCULINE"' unless $gender ~~ ['FEMININE', 'MASCULINE'];
	
	return "ноль" if $sum == 0;

	local $nom{1} = {
		0 => "",
		1 => "",
		2 => $gender eq 'FEMININE' ? 'одна': 'один', 
		3 => $gender eq 'FEMININE' ? 'две': 'два'
	};

	my ( $retval, $i, $sum_words );

	$retval  = "";

	$sum_words = sprintf( "%0.0f", $sum );
	$sum_words-- if ( ( $sum_words - $sum ) > 0 );

	for ( $i = 1 ; $i < 6 && $sum_words >= 1 ; $i++ ) {
		my $sum_tmp = $sum_words / 1000;
		my $sum_part = sprintf( "%0.3f", $sum_tmp - int($sum_tmp) ) * 1000;
		$sum_words = sprintf( "%0.0f", $sum_tmp );

		$sum_words-- if ( $sum_words - $sum_tmp > 0 );
		$retval = get_string( $sum_part, $i ) . " " . $retval;
	}

	$retval =~ s/\s+/ /g;
	$retval =~ s/\s+$//g;
	
	return $retval;;
}

sub get_string {
	my ( $sum, $nominal ) = @_;
	my ( $retval, $nom ) = ( '', -1 );

	if ( ( $nominal == 0 && $sum < 100 ) || ( $nominal > 0 && $nominal < 6 && $sum < 1000 ) ) {
		my $s2 = int( $sum / 100 );
		if ( $s2 > 0 ) {
			$retval .= " " . $diw{2}{$s2}{0};
			$nom = $diw{2}{$s2}{1};
		}
		my $sx = sprintf( "%0.0f", $sum - $s2 * 100 );
		$sx-- if ( $sx - ( $sum - $s2 * 100 ) > 0 );

		if ( ( $sx < 20 && $sx > 0 ) || ( $sx == 0 && $nominal == 0 ) ) {
			$retval .= " " . $diw{0}{$sx}{0};
			$nom = $diw{0}{$sx}{1};
		} else {
			my $s1 = sprintf( "%0.0f", $sx / 10 );
			$s1-- if ( ( $s1 - $sx / 10 ) > 0 );
			my $s0 = int( $sum - $s2 * 100 - $s1 * 10 + 0.5 );
			if ( $s1 > 0 ) {
				$retval .= " " . $diw{1}{$s1}{0};
				$nom = $diw{1}{$s1}{1};
			}
			if ( $s0 > 0 ) {
				$retval .= " " . $diw{0}{$s0}{0};
				$nom = $diw{0}{$s0}{1};
			}
		}
	}
	if ( $nom >= 0 ) {
		$retval .= " " . $nom{$nominal}{$nom};
		$out_rub = 1 if ( $nominal == 1 );
	}
	$retval =~ s/^\s*//g;
	$retval =~ s/\s*$//g;

	return $retval;
}

=head1 NAME

Lingua::RU::Numbers - Converts numbers to money sum in words (in Russian rubles)

=head1 SYNOPSIS

  use Lingua::RU::Numbers qw(number_in_words uah_in_words);

  print number_in_words(100);

  print uah_in_words(1.01);


=head1 DESCRIPTION

B<Lingua::RU::Numbers> helps you to convert number to words.

=head1 FUNCTIONS

=head2 number_in_words( $NUMBER, $GENDER )

returns number in words in ukrainian (UTF-8)

$GENDER can be 'MASCULINE' or 'FEMININE'

=head2 uah_in_words( $NUMBER )

returns money sum in ukrainian words(UTF-8)

e.g.: 1.01 converted to I<odna hryvnya odna kopijka>, 2.22 converted to I<dwi hryvni dwadcyat' dwi kopijki>.

=head1 AUTHOR

Viktor Turskyi <koorchik@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to Github L<https://github.com/koorchik/Lingua-RU-Numbers>

=head1 SEE ALSO

L<Lingua-RU-Number>

=cut

1;    # End of Lingua::RU::Numbers
