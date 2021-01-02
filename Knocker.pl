#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;
use Term::ANSIScreen qw/:color /;
use Term::ANSIScreen qw(cls);
use Win32::Console;
use Win32::Console::ANSI;

my $CONSOLE=Win32::Console->new;
$CONSOLE->Title('BwE Port Knocker');

START:

cls();
my $BwE = (colored ['bold magenta'], qq{
===========================================================
|            __________          __________               |
|            \\______   \\ __  _  _\\_   ____/               |
|             |    |  _//  \\/ \\/  /|  __)_                |
|             |    |   \\\\        //       \\               |
|             |______  / \\__/\\__//______  /               |
|                    \\/  Port Knocker   \\/                |
|        		                                  |
===========================================================\n\n});
print $BwE;

my $target;
my $port_list;
my $delay;
my $ssh_port;
 
# Grab inputs
print "Enter Target: ";
chop ($target = <stdin>);

# Keyword Auto-filler! Make life easy.
if ($target eq "keyword1")
{
	$target = "10.0.0.1";
	$port_list = "1111 2222 3333 4444";
	$delay = "0.5";
	$ssh_port = "666";
	goto SKIP;
}

if ($target eq "keyword2")
{
	$target = "10.0.0.1";
	$port_list = "1111 2222 3333 4444";
	$delay = "0.5";
	$ssh_port = "666";
	goto SKIP;
}

if ($target eq "keyword3")
{
	$target = "10.0.0.1";
	$port_list = "1111 2222 3333 4444";
	$delay = "0.5";
	$ssh_port = "0";
	goto SKIP;
}

if ($target eq "keyword4")
{
	$target = "10.0.0.1";
	$port_list = "1111 2222 3333 4444";
	$delay = "0.5";
	$ssh_port = "0";
	goto SKIP;
}


print "Enter Ports: ";
chop ($port_list = <stdin>);
print "Enter Delay (Sec): ";
chop ($delay = <stdin>);
print "Enter SSH Port: ";
chop ($ssh_port = <stdin>);

# If no target or port entered
if ($target eq "" | $port_list eq "")
{
	print "\nEmpty Target/Port!\n";
	goto QUIT;
}

# If no delay entered, put in the default
if ($delay eq "")
{
	$delay = "0.5";
}

# If no SSH port entered, put in the default
if ($ssh_port eq "")
{
	$ssh_port = "22";
}

# Skip to preset
SKIP:

# Proof of functionality - Or just incase its already open!
if ($ssh_port eq  "0")
{
	# NO SSH PORT REQUIRED
	
} else {
	
print "\n===========================================================\n";

print "\nChecking SSH port $ssh_port...\n";
 
if( my $socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => $ssh_port , Proto => 'tcp' , Timeout => 1 ))
{
	print colored ['bold green'], "Port $ssh_port is already open\n" ;
	goto QUIT;
}
else
{
	print colored ['bold red'], "Port $ssh_port is closed\n" ;
}
}

print "\n===========================================================\n\n";

# Split input per spaced port number
my @ports_list = split / /, $port_list;

# Loop the list of ports
foreach my $port ( @ports_list ) {

    print "Knocking port $port\n";
     
    # Attempt connection to the port via TCP
    my $socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => $port , Proto => 'tcp' , Timeout => $delay);
     
    # Confirm Connection
    if( $socket )
    {
        print " - Port $port is open\n" ;
    }
    else
    {
        # Nothing To Output!
    }
}

print "\n===========================================================\n";

# Check if knocking is successful
if ($ssh_port eq  "0")
{
	# NO SSH PORT REQUIRED
	
} else {
	
print "\nChecking SSH port $ssh_port...\n";
 
if( my $socket = IO::Socket::INET->new(PeerAddr => $target , PeerPort => $ssh_port , Proto => 'tcp' , Timeout => 1 ))
{
	print colored ['bold green'], "Port $ssh_port is open\n" ;
}
else
{
	print colored ['bold red'], "Port $ssh_port is closed\n" ;
}
}

print "\n\nGo Again? (y/n): "; 
my $input = <STDIN>; chomp $input; 
if ($input eq "n") 
{ 
	goto QUIT 
}
else 
{ 
	goto START
}

QUIT:

print "\nPress Enter to Exit... ";
while (<>) {
chomp;
last unless length;
}

