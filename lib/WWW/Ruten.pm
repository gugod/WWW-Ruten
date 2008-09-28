package WWW::Ruten;

use warnings;
use strict;
use Carp;
use URI;
use WWW::Mechanize;
use Encode;

use HTML::TreeBuilder::XPath;
use HTML::Selector::XPath;

our $VERSION = '0.01';

sub new {
    my ($class) = @_;
    my $self = {};
    bless $self;
    return $self;
}

sub search {
    my ($self, $term, @params) = @_;
    $self->{search_params} = {
        term => $term
    };

    return $self;
}

use XXX;
sub each {
    my ($self, $cb) = @_;
    $self->_do_search;

    foreach my $result (@{ $self->{search_results} }) {
        $cb->($result);
    }
    return $self;
}

sub _do_search {
    my ($self) = @_;
    die unless(
        defined $self->{search_params}{term}
    );

    $self->{mech} ||= WWW::Mechanize->new;

    my $mech = $self->{mech};
    $mech->get("http://www.ruten.com.tw");
    $mech->submit_form(
        form_name => "srch",
        fields => {
            k => $self->{search_params}{term}
        }
    );

    my $content = Encode::decode("big5", $mech->content);
    my @results = ();
    my $html = HTML::TreeBuilder::XPath->new;
    $html->parse($content);

    my $selector = HTML::Selector::XPath->new("ul.items h3.title a");

    for my $node ($html->findnodes($selector->to_xpath)) {
        push @results, {
            url => $node->attr("href"),
            title => join("", $node->content_list)
        }
    }

    $self->{search_results} ||=[];
    push @{  $self->{search_results} }, @results;

    return $self;
}


1; # Magic true value required at end of module
__END__

=head1 NAME

WWW::Ruten - [One line description of module's purpose here]


=head1 VERSION

This document describes WWW::Ruten version 0.0.1


=head1 SYNOPSIS

    use WWW::Ruten;


=head1 DESCRIPTION


=head1 INTERFACE 


=over

=item new()

=back

=head1 DIAGNOSTICS

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

WWW::Ruten requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-www-ruten@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Kang-min Liu  C<< <gugod@gugod.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Kang-min Liu C<< <gugod@gugod.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
