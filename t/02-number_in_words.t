use Lingua::RU::Numbers qw/number_in_words/;

use utf8;
use Test::More;

my %masculine = (
    '0'          => 'ноль',
    '1'          => 'один',
    '102'        => 'сто два',
    '1000000000' => "один миллиард",
    '122456781'  => "сто двадцать два миллиона четыреста пятьдесят шесть тысяч семьсот восемьдесят один"
);

foreach my $num ( sort { $a <=> $b } keys %masculine ) {
    my $words = $masculine{$num};
    is( number_in_words($num, 'MASCULINE'), $words, "Masculine number $num" );
}


my %feminine = (
    '0'          => 'ноль',
    '1'          => 'одна',
    '102'        => 'сто две',
    '1000000000' => "один миллиард",
    '122456781'  => "сто двадцать два миллиона четыреста пятьдесят шесть тысяч семьсот восемьдесят одна"
);

foreach my $num ( sort { $a <=> $b } keys %feminine ) {
    my $words = $feminine{$num};
    is( number_in_words($num, 'FEMININE'), $words, "Feminine number $num" );
}


done_testing();
