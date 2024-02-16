#!/usr/bin/perl
use strict;

use XML::Simple;
use File::Basename;
use Data::Dumper;
use Digest::SHA1 qw(sha1 sha1_hex);

my $repofile = $ARGV[0];
my $version = $ARGV[1];
my $zipfile = $ARGV[2];
my $url = $ARGV[3];

=comment
my $install = XMLin('install.xml', KeepRoot => 0, KeyAttr => '', NoAttr => 0);
my $version = $install->{version};
=cut
print("$version\n");
	
my $repo = XMLin($repofile, ForceArray => 1, KeepRoot => 0, KeyAttr => 0, NoAttr => 0);
$repo->{plugins}[0]->{plugin}[0]->{version} = $version;
	
open (my $fh, "<", $zipfile);
binmode $fh;
	
my $digest = Digest::SHA1->new;
$digest->addfile($fh);
close $fh;

$repo->{plugins}[0]->{plugin}[0]->{sha}[0] = $digest->hexdigest;
print("sha \n", $digest->hexdigest);

$url .= "/$zipfile";
$repo->{plugins}[0]->{plugin}[0]->{url}[0] = $url;

XMLout($repo, RootName => 'extensions', NoSort => 1, XMLDecl => 1, KeyAttr => '', OutputFile => $repofile, NoAttr => 0);


