use Lingua::UK::Numbers qw/uah_in_words/;

use utf8;
use Test::More;

my %data = (
    '0'     => 'нуль гривень нуль копійок',
    '1.01'  => 'одна гривня одна копійка',
    '111.1' => 'сто одинадцять гривень десять копійок',
    '1000000000.94' =>
        "один мільярд гривень дев'яносто чотири копійки",
    '123456789.05' =>
"сто двадцять три мільйона чотириста п'ятдесят шість тисяч сімсот вісімдесят дев'ять гривень п'ять копійок"
    ,
);

foreach my $num ( sort { $a <=> $b } keys %data ) {
    my $words = $data{$num};
    is( uah_in_words($num), $words, "Number $num" );
}

done_testing();