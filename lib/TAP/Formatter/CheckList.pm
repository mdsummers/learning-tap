package TAP::Formatter::CheckList;

use strict;
use TAP::Formatter::Base ();
use TAP::Formatter::CheckList::Session;
use POSIX qw(strftime);

use vars qw($VERSION @ISA);

@ISA = qw(TAP::Formatter::Base);

=head1 NAME

TAP::Formatter::CheckList - Harness output delegate for check list output

=head1 VERSION

Version 1.0

=cut

$VERSION = '1.0';

sub open_test {
    my ( $self, $test, $parser ) = @_;

    my $session = TAP::Formatter::CheckList::Session->new(
        {   name      => $test,
            formatter => $self,
            parser    => $parser,
        }
    );

    $session->header;

    return $session;
}

sub _should_show_count {
    return 0;
}

sub summary {
  print "summary called\n";
}

sub _output_summary_failure {
  print "_output_summary_failure called\n";
}

1;
