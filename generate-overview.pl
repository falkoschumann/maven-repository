#!/usr/bin/perl -w

use strict;
use warnings;

use HTML::Entities;
use XML::Simple;
use Data::Dumper;

print << 'HEADER';
<!DOCTYPE HTML>
<html>
<head>
<link rel="stylesheet" type="text/css" href="style.css" media="all">
</head>
<body>
<h1>Maven Repository</h1>
HEADER

print << 'RELEASES';
<h2>Releases</h2>
<p>To use the release repository add the following to your pom.xml</p>
<pre><code>&lt;repositories&gt;
    &lt;repository&gt;
        &lt;id&gt;github-falkoschumann&lt;/id&gt;
        &lt;url&gt;http://falkoschumann.github.io/maven-repository/releases/&lt;/url&gt;
    &lt;/repository&gt;
&lt;/repositories&gt;
</code></pre>
RELEASES
listRepository("releases");

print << 'SNAPSHOTS';
<h2>Snapshots</h2>
<p>To use the snapshot repository add the following to your pom.xml</p>
<pre><code>&lt;repositories&gt;
    &lt;repository&gt;
        &lt;id&gt;github-falkoschumann&lt;/id&gt;
        &lt;url&gt;http://falkoschumann.github.io/maven-repository/snapshots/&lt;/url&gt;
    &lt;/repository&gt;
&lt;/repositories&gt;
</code></pre>
SNAPSHOTS
listRepository("snapshots");

print << 'FOOTER';
</body>
</html>
FOOTER


sub listRepository {
	my ($file) = @_;
	print << 'TABLE_HEADER';
<table>
<tr>
  <th class="groupId">Group Id</th>
  <th class="artifactId">Artifact Id</th>
  <th class="release">Versions</th>
  <th class="lastUpdated">Updated</th>
</tr>
TABLE_HEADER
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
		my $version     = $metadata->{'versioning'}->{'versions'}->{'version'};
		my $lastUpdated = $metadata->{'versioning'}->{'lastUpdated'};
		$lastUpdated =~ m/(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)/;
		my $year = $1;
		my $month = $2;
		my $day = $3;
		my $hour = $4;
		my $minute = $5;
		my $second = $6;

		my $txt;
		if (ref($version) eq 'ARRAY') {
			for (my $i = 0; $i < @$version; $i++) {
				if ($release eq @$version[$i]) {
					$txt .= "<strong>@$version[$i]</strong>";
				} else {
					$txt .= @$version[$i];
				}
				if ($i < @$version - 1) {
					$txt .= ', ';
				}
			}
		} else {
			$txt = "<strong>$version</strong>";
		}
		#my $txt = Dumper $version;
		
		print << "TABLE_DATA"
<tr>
  <td class="groupId">$groupId</td>
  <td class="artifactId">$artifactId</td>
  <td class="release">$txt</td>
  <td class="lastUpdated">$year-$month-$day</td>
</tr>
TABLE_DATA
	}
	
	return if not -d $file;

	opendir my $dh, $file || die "Can't open $file: $!";
	while (readdir $dh) {
		next if /^\./;
		traverse("$file/$_");	
	}
	close $dh;
}
