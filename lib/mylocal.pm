package mylocal;

use strict;
use warnings;
use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( $/ $\ );

our $/ = "\n";
our $\ = "\n";


1;