#!/usr/bin/perl -w

use strict;
use warnings;

my $path = shift || '.';

print "<!DOCTYPE HTML>\n";
print "<html>\n";
print "<head>\n";
print "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" media=\"all\">\n";
print "</head>\n";
print "<body>\n";

print "<table>\n";
print "<tr>\n";
print "  <th>Artifact</th>\n";
print "  <th>Version</th> \n";
print "</tr>\n";

traverse($path);

sub traverse {
	my ($file) = @_;
	
	if ($file =~ m/maven-metadata.xml$/) {
		open(IP, "$file") or die "Can't open $file: $!";
		undef $/;
		my $content = <IP>;
		close(IP);
		
		$content =~ m/<artifactId>(.*)<\/artifactId>/;
		my $artifactId = $1;
		$content =~ m/<release>(.*)<\/release>/;
		my $release = $1;
		print "<tr>\n";
		print "  <td>$artifactId</td>\n";
		print "  <td>$release</td>\n";
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

print "</table>\n";

print "</body>\n";
print "</html>\n";
