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

my $hash = $ARGV[0];
die "No hash specified\n" unless $hash && $hash =~ /^[a-f0-9]{32}$/i;

my $result = $ua->get("http://www.google.com/search?q=$hash");
# now we have the result page, probably with the clear text password

for my $word (split(/[^[:graph:]]|<[^>]+>/, $result->content())) {
	if ($hash eq md5_hex($word)) {
		print $word, "\n";
		last;
	}
}
