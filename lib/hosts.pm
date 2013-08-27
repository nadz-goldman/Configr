package hosts;
use strict;
use warnings;
use Net::Netmask;
use Net::Ping::Network;
use mysql;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw( buildNet compareResults updateData );

my ( @networks , @net , @fields , @currentHosts , @oldHosts ) = ();
my ( $tmp , $i , $k , $str , $ip , $net , $mask , $block , $y , $total , $sth ) = 0;
my %y;

# $_[0] - file with networks
# $_[1] - file with alive hosts

sub buildNet {
    myQuery( "TRUNCATE TABLE `currentHosts`;" );
    open NF, '<', $_[0];    
    @networks = <NF>;
    close NF;
    foreach $str( @networks ){
        chomp $str;
        ( $fields[$i][0] , $fields[$i][1] ) = split( /\// , $str );
	#print "i[0] = $fields[$i][0]\ti[1] = $fields[$i][1]";
        $i++;
    }
    open LH, '>', $_[1];
    for( $i = 0 ; $i <= $#networks ; $i++ ){
        $block =
          Net::Ping::Network->new( $fields[$i][0] , $fields[$i][1] , 2 , 3 , 40 );
        ( $y , $k ) = $block -> doping();
        while( my( $key , $value ) = each( %$y ) ){
            if( $value ){
                print LH $key;
                myQuery( "INSERT INTO
                 `currentHosts` ( `address` )
                 VALUES
                 ( '$key' );
		");
                $total++;
            }
            
        }
    }
    close LH;
    return $total;
}

sub compareResults{
    my $d = countRecords( "devices" );
    my $c = countRecords( "currentHosts" );
    print "There is no records in devices table" if( $d == 0 );
    if( $d != $c ){
	&getCurrentHosts;
	foreach my $h ( @currentHosts ){
	    #&addHost( $h );
	    &checkHostInTable( $h );
	#    print "Host $h added to devices table";
	}
	return 0;
    }
    return 1 if $d == $c;
}

sub getCurrentHosts{
    @currentHosts = ();
    $sth = $dbh -> prepare( "SELECT address FROM currentHosts;" );
    $sth -> execute;
    while( $i = $sth -> fetchrow ){
	push @currentHosts , $i;
    }    
}

sub getOldHosts{
    my $i = countRecords( "devices" );
    $sth = $dbh -> prepare( "SELECT address FROM devices;" );
    $sth -> execute;
    while( $i = $sth -> fetchrow ){
	push @oldHosts , $i;
    }
}

sub updateData{
    getOldHosts;
    getCurrentHosts;
    my %h1;
    map { $h1{$_} = 1 } @oldHosts;
    map { $h1{$_} += 1 } @currentHosts;
    
    my @diffs = grep { $h1{$_} == 1 } keys %h1;
    print join("\n", @diffs);
    
    #my ( $a1 , $a2 );
    #$a1 = @currentHosts;
    #$a2 = @oldHosts;
    #print "current hosts array size: $a1 ; old hosts array size: $a2";
####    foreach my $c ( @currentHosts ){
####	foreach my $o ( @oldHosts ){
####	    if( $c eq $o ){
####		hostIsUp( $c );
####		#last;
####	    }
####	}
####	#addHost( $c );
####    }
####    foreach my $o ( @oldHosts ){
####	foreach my $c ( @currentHosts ){
####	    if( $c eq $o ){
####		#last;
####	    }
####	}
####	#hostUnseen( $o );
####    }
}

sub hostUnseen{
    return 1;
}
sub checkHostInTable{
    $i = "";
    $sth = $dbh -> prepare ( "SELECT address
			      FROM devices
			      WHERE address='$_[0]';
			    " );
    $sth -> execute;
    while( $i = $sth -> fetchrow ){
	if( $i eq $_[0] ){
	    hostIsUp( $_[0] );
	}
	else{ addHost( $_[0] ) };
    }
    $sth -> finish;    
}
sub addHost{
	$sth = $dbh -> prepare ( "INSERT INTO devices
			( `address` , `first_seen` , `last_seen` )
			VALUES
			( '$_[0]' , NOW() , NOW() );
		       " );
	$sth -> execute;
	$sth -> finish;
}

sub hostIsUp{
    print "Updating host $_[0]";
    $sth = $dbh -> prepare ( "UPDATE devices
		    SET
		    last_seen=NOW()
		    WHERE
		    `address`='$_[0]';
		   " );
    $sth -> execute;
    $sth -> finish;
}

1;
