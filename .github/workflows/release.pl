#!/usr/bin/perl
use strict;

use XML::Simple;
use File::Basename;
use Data::Dumper;
use Digest::SHA1 qw(sha1 sha1_hex);

my $url = 'http://downloads.sourceforge.net/project';
my $zipfile	= $ARGV[0] || 'repo.xml';

my $install = XMLin('install.xml', KeepRoot => 0, KeyAttr => '', NoAttr => 0);
my $version = $install->{version};
print("$version\n");
	
my $repo = XMLin('repo.xml', ForceArray => 1, KeepRoot => 0, KeyAttr => 0, NoAttr => 0);
$repo->{plugins}[0]->{plugin}[0]->{version} = $version;
	
open (my $fh, "<", $zipfile);
binmode $fh;
	
my $digest = Digest::SHA1->new;
$digest->addfile($fh);
close $fh;

$repo->{plugins}[0]->{plugin}[0]->{sha}[0] = $digest->hexdigest;

$url .= "/$zipfile";
$repo->{plugins}[0]->{plugin}[0]->{url}[0] = $url;

XMLout($repo, RootName => 'extensions', NoSort => 1, XMLDecl => 1, KeyAttr => '', OutputFile => 'new.xml', NoAttr => 0);


