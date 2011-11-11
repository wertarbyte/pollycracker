#!/usr/bin/perl
#
# Pollycracker by Stefan Tomanek <stefan@pico.ruhr.de>
#
# Crack MD5 hashes by using Google to search for
# clear text counterparts

use strict;
use warnings;

use LWP::UserAgent;
use Digest::MD5 qw/md5_hex/;

my $ua = new LWP::UserAgent(agent=> "Pollycracker");

my %hashes = map {$_=>1} grep {/^[a-f0-9]{32}$/i} @ARGV;

die "No valid hash specified\n" unless %hashes;

my %seen = ();
my %table =
	# calculate the hash for each word on the pages
	map { md5_hex($_), $_ }
	# remove duplicate words
	grep {!$seen{$_}++}
	# get the result page for each requested hash and split it into words
	map {
		split(/[^[:graph:]]|<[^>]+>/,
		$ua->get("http://www.google.com/search?q=$_")->content())
	} keys %hashes;

foreach (keys %hashes) {
	if (exists $table{$_}) {
		print "$_\t$table{$_}\n";
	}
}
