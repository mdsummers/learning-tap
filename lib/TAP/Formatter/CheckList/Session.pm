package TAP::Formatter::CheckList::Session;

use strict;
use TAP::Formatter::Session;

use vars qw($VERSION @ISA);

@ISA = qw(TAP::Formatter::Session);

=head1 NAME

TAP::Formatter::CheckList::Session - Harness output delegate for check list
output

=head1 VERSION

Version 1.0

=cut

$VERSION = '1.0';

=head1 METHODS

=head2 result

Stores results for later output, all together.

=cut

use Data::Dumper;
sub result {
    my $self   = shift;
    my $result = shift;

    my $parser    = $self->parser;
    my $formatter = $self->formatter;

    if ( $result->is_bailout ) {
        $formatter->_failure_output(
                "Bailout called.  Further testing stopped:  "
              . $result->explanation
              . "\n" );
        return;
    }
    if ( ! $result->is_test ) {
      print STDERR "Not a test\n";
      return;
    }
    my $formatted = sprintf("%-50s", $self->name ." " .$result->description);
    print $formatted ." [" .($result->is_actual_ok ? "x" : " ") ."]\n";

    if (!$formatter->quiet
        && (   $formatter->verbose
            || ( $result->is_test && $formatter->failures && !$result->is_ok )
            || ( $formatter->comments   && $result->is_comment )
            || ( $result->has_directive && $formatter->directives ) )
      )
    {
        $self->{results} .= $self->_format_for_output($result) . "\n";
    }
}

=head2 close_test

When the test file finishes, outputs the summary, together.

=cut

sub close_test {
    print "close_test called\n";
    return;
    my $self = shift;

    # Avoid circular references
    $self->parser(undef);

    my $parser    = $self->parser;
    my $formatter = $self->formatter;
    my $pretty    = $formatter->_format_name( $self->name );

    return if $formatter->really_quiet;
    if ( my $skip_all = $parser->skip_all ) {
        $formatter->_output( $pretty . "skipped: $skip_all\n" );
    }
    elsif ( $parser->has_problems ) {
        $formatter->_output(
            $pretty . ( $self->{results} ? "\n" . $self->{results} : "\n" ) );
        $self->_output_test_failure($parser);
    }
    else {
        my $time_report = '';
        if ( $formatter->timer ) {
            my $start_time = $parser->start_time;
            my $end_time   = $parser->end_time;
            if ( defined $start_time and defined $end_time ) {
                my $elapsed = $end_time - $start_time;
                $time_report
                  = $self->time_is_hires
                  ? sprintf( ' %8d ms', $elapsed * 1000 )
                  : sprintf( ' %8s s', $elapsed || '<1' );
            }
        }

        $formatter->_output( $pretty
              . ( $self->{results} ? "\n" . $self->{results} : "" )
              . "ok$time_report\n" );
    }
    print "close_test end\n";
}

sub header {
  print "header called\n";
}

sub time_report {
  print "time_report called\n";
}


1;
