use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lingua::RU::Numbers',
    AUTHOR              => q{"koorchik" <"koorchik@cpan.org">},
    VERSION_FROM        => 'lib/Lingua/RU/Numbers.pm',
    ABSTRACT_FROM       => 'lib/Lingua/RU/Numbers.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Lingua-RU-Numbers-*' },
);
