#!/usr/bin/perl
use strict;
use warnings;
use TAP::Harness;
use lib './lib';
use TAP::Formatter::CheckList;

my $formatter = TAP::Formatter::CheckList->new({
  verbosity => 1
});
my $harness = TAP::Harness->new({
  formatter => $formatter
});

my @tests = glob('tests/*.t');

my $aggregate = $harness->runtests(@tests);
