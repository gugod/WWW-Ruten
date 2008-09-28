use strict;
use warnings;
use HTML::TagParser;

use pQuery;
use feature 'say';

$/ = undef;
my $content = <>;

# $content =~ s/^.+<body .*?>//s;
# $content =~ s{</body>.*+$}{}s;

# print $content;

my $html = HTML::TagParser->new($content);
my @elem = $html->getElementsByTagName( "li" );

print $_->innerText for @elem;
