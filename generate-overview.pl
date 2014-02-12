#!/usr/bin/perl -w

use strict;
use warnings;

use HTML::Entities;
use XML::Simple;

my $path = shift || '.';

print "<!DOCTYPE HTML>\n";
print "<html>\n";
print "<head>\n";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" media=\"all\">\n";
print "</head>\n";
print "<body>\n";

print "<h1>Maven Repository</h1>\n";

print "<h2>Releases</h2>\n";
print "<p>To use the release repository add the following to your pom.xml</p>\n";
print "<pre><code>";
print encode_entities("<repositories>"), "\n";
print encode_entities("    <repository>"), "\n";
print encode_entities("        <id>github-falkoschumann</id>"), "\n";
print encode_entities("        <url>http://falkoschumann.github.io/maven-repository/releases/</url>"), "\n";
print encode_entities("    </repository>"), "\n";
print encode_entities("</repositories>"), "\n";
print "</code></pre>\n";
listRepository("releases");

print "<h2>Snapshots</h2>\n";
print "<p>To use the snapshot repository add the following to your pom.xml</p>\n";
print "<pre><code>";
print encode_entities("<repositories>"), "\n";
print encode_entities("    <repository>"), "\n";
print encode_entities("        <id>github-falkoschumann</id>"), "\n";
print encode_entities("        <url>http://falkoschumann.github.io/maven-repository/snapshots/</url>"), "\n";
print encode_entities("    </repository>"), "\n";
print encode_entities("</repositories>"), "\n";
print "</code></pre>\n";
listRepository("snapshots");

print "</body>\n";
print "</html>\n";


sub listRepository {
	my ($file) = @_;
	print "<table>\n";
	print "<tr>\n";
	print "  <th class=\"groupId\">Group Id</th>\n";
	print "  <th class=\"artifactId\">Artifact Id</th>\n";
	print "  <th class=\"release\">Latest Version</th> \n";
	print "  <th class=\"lastUpdated\">Updated</th> \n";
	print "</tr>\n";
	traverse($file);
	print "</table>\n";
}


sub traverse {
	my ($file) = @_;
	
	if ($file =~ m/maven-metadata.xml$/) {
		my $metadata    = XMLin($file, forcearray => 0);
		my $groupId     = $metadata->{'groupId'};
		my $artifactId  = $metadata->{'artifactId'};
		my $release     = $metadata->{'versioning'}->{'release'};
		my $lastUpdated = $metadata->{'versioning'}->{'lastUpdated'};
		$lastUpdated =~ m/(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)/;
		my $year = $1;
		my $month = $2;
		my $day = $3;
		my $hour = $4;
		my $minute = $5;
		my $second = $6;

		print "<tr>\n";
		print "  <td class=\"groupId\">$groupId</td>\n";
		print "  <td class=\"artifactId\">$artifactId</td>\n";
		print "  <td class=\"release\">$release</td>\n";
		print "  <td class=\"lastUpdated\">$year-$month-$day $hour:$minute:$second</td>\n";
		print "</tr>\n";
	}
	
	return if not -d $file;

	opendir my $dh, $file || die "Can't open $file: $!";
	while (readdir $dh) {
		next if /^\./;
		traverse("$file/$_");	
	}
	close $dh;
}
