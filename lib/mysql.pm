package mysql;

use DBI;
use strict;
use warnings;
use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( _connect _disconnect checkMysql checkTable setMysql myQuery countRecords $dbh );
#our @EXPORT_OK = qw( $dbh );


#my $sql_user		= $ENV{SQL_USER};
#my $sql_password	= $ENV{SQL_PASSWD};
#my $sql_base		= $ENV{SQL_BASE};
#my $sql_host		= $ENV{SQL_HOST};

my( $sql_user , $sql_password , $sql_base , $sql_host , $sql_port );

my $debug = 0;
my $sth;
our $dbh;
#our $sth;
#my $DBD;

if( $debug ){ print "User:$sql_user\nPassword:$sql_password\n"; }

sub setMysql{
    if( !$sql_host )		{ $sql_host=$_[0]; }
    if( !$sql_base )		{ $sql_base=$_[1]; }
    if( !$sql_port )		{ $sql_port=$_[2]; }
    if( !$sql_user )		{ $sql_user=$_[3]; }
    if( !$sql_password )	{ $sql_password=$_[4]; }
}

sub _connect{
    my( $u , $p ) = @_;

    $sql_user		= $u if $u;
    $sql_password	= $p if $p;

    if( $debug ){ print "User:$sql_user\nPassword:$sql_password\n"; }

    #$dbh =  DBI->connect( "DBI:mysql:".$sql_base.";host=".$sql_host."" , $sql_user , $sql_password ) or die $DBI::errstr;;
    $dbh = DBI->connect( "DBI:mysql:$sql_base:$sql_host:$sql_port" , $sql_user , $sql_password ,
			{ PrintError => 0 , }
			) or return 0;
    $dbh -> { RaiseError } = 1;
    return 1;
}

sub _disconnect{
    if( $sth ){ $sth->finish(); }
    $dbh->disconnect or warn $dbh->errstr;
    return 1;
}

sub countRecords{
    $sth = $dbh -> prepare( "SELECT COUNT(*) FROM ".$_[0] );
    $sth -> execute;
    my $res = $sth -> fetchrow;
    $sth -> finish;
    return $res;
}

sub myQuery{
    $sth = $dbh -> prepare( $_[0] );
    $sth -> execute || die "Can not do MySQL query: ".$_[0];
    $sth -> finish;
    return 1;
}

sub checkTable{
    my ( $i , $t );
    $sth = $dbh -> prepare( "SELECT COUNT(*) FROM `".$_[0]."`;" );
    print "CHECK TABLE:\nSELECT COUNT(*) FROM `".$_[0]."`;\n" if( $debug );
    $sth -> execute || die "Can not do sql query\n";
    while( $i = $sth -> fetchrow ){
	$t = $i;
    }
    return $t;
}

sub checkMysql{
    if( !_connect ){ return 0; }
    else { _disconnect(); }
    return 1;
}

1;
