use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/WWW/Ruten.pm';

build_requires  'Test::More'        => '0.42';

requires
    'Encode' => 0,
    'WWW::Mechanize' => 1.66,
    'HTML::TreeBuilder::XPath' => 0,
    'HTML::Selector::XPath' => 0;

WriteAll;


