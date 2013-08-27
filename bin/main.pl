#!/usr/bin/perl
use strict;
no strict 'subs';
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Configr;
use mylocal;
use mysql;
use hosts;
use Cwd;

##########################################################

my $tmp = 0;

#checkDiskSpace();

readParams( $ARGV[0] , $ARGV[1] );
chdir $MAIN_DIR;
checkConfigValues();
#if( $USE_LOG == 1 ){
    open LF , '>>' , $LOG_FILE or die "Can not open log file $!";
#}
#else{
#    open LF , '>>' , STDERR or die "Can not open log file $!";
#}
print LF logStr( "Start" );

print LF logStr( "Setting params for MySQL" ) if $DEBUG;
setMysql( $DB_HOST , $DB_NAME , $DB_PORT , $DB_USER , $DB_PASSWORD );
my $res = checkMysql();
if( !$res ){
    print LF logStr( "Can not connect with MySQL" );
    die "Can not connect to MySQL. Will not work";
}

print LF logStr( "Connected with MySQL" ) if _connect;
print LF logStr( "Building network" );
$tmp = buildNet( $NETWORKS_FILE , $TMP_FILE );
print LF logStr( "Network is builded" );
print LF logStr( "Total alive hosts is $tmp" );
print LF logStr( "Comparing results" );
#$res = compareResults;
#if ( $res != 1 ){
#    print LF logStr ( "NOT all devices are up!" );
#}
#else{
#    print LF logStr ( "All devices are up!" );
#}
#print LF logStr ( "Updating data" );
#updateData;

print LF logStr( "Disconnected from MySQL" ) if _disconnect;

print LF logStr( "Finish" );
close LF;

exit 0;
