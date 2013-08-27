package Configr;

use mylocal;
use Cwd;
use POSIX qw(strftime);
use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(   $MAIN_DIR
                    $DB_HOST
                    $DB_NAME
                    $DB_PORT
                    $DB_USER
                    $DB_PASSWORD
                    $NETWORKS_FILE
                    $TMP_FILE
                    $USE_SNMP
                    $SNMP_VER
                    $SNMPWALK_BIN
                    $COMPARE_FILE
                    $USE_TFTP
                    $TFTP_DIR
                    $USE_PORT_PARSING
                    $UPL_PORT_DESC
                    $USE_GIT
                    $USE_NAGIOS
                    $NAGIOS_BIN
                    $NAGIOS_CFG
                    $NAGIOS_TMP_FILE
                    $USE_LOG
                    $LOG_FILE
                    $DEBUG
                    readParams
                    checkConfigValues
                    logStr
                );

our($MAIN_DIR ,
    $DB_HOST ,
    $DB_NAME ,
    $DB_USER ,
    $DB_PASSWORD ,
    $NETWORKS_FILE , 
    $TMP_FILE , 
    $USE_SNMP , 
    $SNMP_VER , 
    $SNMPWALK_BIN , 
    $COMPARE_FILE , 
    $USE_TFTP , 
    $TFTP_DIR , 
    $USE_PORT_PARSING , 
    $UPL_PORT_DESC , 
    $USE_GIT , 
    $USE_NAGIOS , 
    $NAGIOS_BIN , 
    $NAGIOS_CFG , 
    $NAGIOS_TMP_FILE ,
    $USE_LOG ,
    $LOG_FILE ,
    $DEBUG ,
   );

#### OIDû õðàíèì â ÁÄ

sub logStr{
    my $t = myTime();
    my $str = "$t $_[0]";
    return $str;
}

sub myTime{
    #my $get_cur_ts = time;
    #my $now_string = strftime "%a %b %e %d %m %Y %H:%M:%S %Y", localtime;
    #print $now_string."\n";
    my $getCurTS = time;
    my $time = strftime "%Y-%m-%d %H:%M:%S", localtime;
    return $time;
}

sub readParams{
    if( ( !defined $_[0] ) || ( length $_[0] == 0 ) ){ usage(); }
    chomp $_[0];
    if( $_[0] eq "-f" ){
        if( ( !defined $_[1] ) || ( length $_[1] == 0 ) ){ usage(); }
        chomp $_[1];
        readMainConfig( $_[1] );
    }
    elsif( $_[0] eq "-h" ){ usage(); }
    elsif( $_[0] eq "-v" ){ version(); }
    elsif( $_[0] eq "-s" ){ showVar();}
}

sub version{
    print "\nConfigr\nv.2\nby Ilya Vasilyev, 2010-2013\n";
}

sub usage{
    print "\n
    Usage:
    main.pl -f PathToConfigurationFile       Read configuration file
            -h                               This help
            -v                               Version
    
    ";
    exit;
}

sub showVar{
    print "Parsed values:
        MAIN_DIR =  $MAIN_DIR
        DB_HOST = $DB_HOST 
        DB_NAME = $DB_NAME 
        DB_USER = $DB_USER 
        DB_PASSWORD = ***
        DB_PORT = $DB_PORT
        NETWORKS_FILE =  $NETWORKS_FILE 
        TMP_FILE =  $TMP_FILE
        USE_SNMP =  $USE_SNMP
        SNMP_VER =  $SNMP_VER
        SNMPWALK_BIN =  $SNMPWALK_BIN 
        COMPARE_FILE =  $COMPARE_FILE 
        USE_TFTP =  $USE_TFTP
        TFTP_DIR =  $TFTP_DIR
        USE_PORT_PARSING =  $USE_PORT_PARSING  
        UPL_PORT_DESC =  $UPL_PORT_DESC 
        USE_GIT =  $USE_GIT 
        USE_NAGIOS =  $USE_NAGIOS  
        NAGIOS_BIN =  $NAGIOS_BIN  
        NAGIOS_CFG =  $NAGIOS_CFG  
        NAGIOS_TMP_FILE =  $NAGIOS_TMP_FILE
        USE_LOG = $USE_LOG
        LOG_FILE =  $LOG_FILE
        DEBUG = $DEBUG
    ";    
}


sub readMainConfig {
    my $confFile = $_[0];
    print "conf is $confFile";
    if( !-f $confFile ){
        print "Can not read configuration file $confFile";
        exit;
    }
    open CF, '<', $confFile || die print "Can`t open file $confFile!  Error: $!\n";
    my( $value , $var );
    while( <CF> ){
        chomp;                  # no newline
        s/#.*//;                # no comments
        s/^\s+//;               # no leading white
        s/\s+$//;               # no trailing white
        next unless length;     # anything left?
        my( $var , $value ) = split( /\s*=\s*/, $_, 2);
        #print "$var = $value\n";
        $MAIN_DIR = $value if( $var eq "MAIN_DIR");
        $DB_HOST = $value if( $var eq "DB_HOST" );
        $DB_NAME = $value if( $var eq "DB_NAME" );
        $DB_USER = $value if( $var eq "DB_USER" );
        $DB_PASSWORD = $value if( $var eq "DB_PASSWORD" );
        $DB_PORT = $value if( $var eq "DB_PORT" );
        $NETWORKS_FILE = $value if( $var eq "NETWORKS_FILE");
        $TMP_FILE = $value if( $var eq "TMP_FILE");
        $USE_SNMP = $value if( $var eq "USE_SNMP");
        $SNMP_VER = $value if( $var eq "SNMP_VER");
        $SNMPWALK_BIN = $value if( $var eq "SNMPWALK_BIN");
        $COMPARE_FILE = $value if( $var eq "COMPARE_FILE");
        $USE_TFTP = $value if( $var eq "USE_TFTP");
        $TFTP_DIR = $value if( $var eq "TFTP_DIR");
        $USE_PORT_PARSING = $value if( $var eq "USE_PORT_PARSING");
        $UPL_PORT_DESC = $value if( $var eq "UPL_PORT_DESC");
        $USE_GIT = $value if( $var eq "USE_GIT");
        $USE_NAGIOS = $value if( $var eq "USE_NAGIOS");
        $NAGIOS_BIN = $value if( $var eq "NAGIOS_BIN");
        $NAGIOS_CFG = $value if( $var eq "NAGIOS_CFG");
        $NAGIOS_TMP_FILE = $value if( $var eq "NAGIOS_TMP_FILE");
        $USE_LOG = $value if( $var eq "USE_LOG");
        $LOG_FILE = $value if( $var eq "LOG_FILE");
        $DEBUG = $value if( $var eq "DEBUG");
    }
    close CF;
    showVar() if( $DEBUG == 1 );
}

sub checkConfigValues{
    if( $USE_LOG ){
        if( !-f $LOG_FILE ){
            print "There is no log file at $LOG_FILE, trying to create";
            open LF , '>' , $LOG_FILE || die "Can not create log file at $LOG_FILE  Error: $!";
            close LF;
        }
    }
    else{ print "In config file USE_LOG turned off. Will print messages to STDERR"; }
    #checkDiskSpace( $MAIN_DIR );
    #checkMysql( $DB_HOST , $DB_NAME , $DB_USER , $DB_PASSWORD );
    if( !-f $NETWORKS_FILE ){ die "There is no file with networks! Error: $!"; }
    if( $USE_SNMP == 1 ){
        if( !-x $SNMPWALK_BIN ){ die "Can not find snmpwalk here: $SNMPWALK_BIN Error: $!"; }
    }
    if( $USE_NAGIOS == 1 ){
        if( !-x $NAGIOS_BIN ){ die "Can not find nagios binary file here: $NAGIOS_BIN Error: $!"; }
        if( !-f $NAGIOS_CFG ){ die "Can not find nagios configuration file here: $NAGIOS_CFG Error: $!"; }
    }
}

sub checkDiskSpace {
    my( $gg , $fs ) = split( /\// , $_[0] );
    $fs = $fs."S";
    my $space = `/bin/df | grep "$fs" | awk '{print \$4}'`;
    if( "16384" > $space ){ print "Not enough workspace! /$space"; }
    else{ print "Space is OK. /$space"; }
}

1;
