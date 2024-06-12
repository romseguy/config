#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab
# © 2012 Michael Stapelberg, Public Domain

# This script is a simple wrapper which prefixes each i3status line with custom
# information. To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.pl
# In the 'bar' section.

use strict;
use warnings;
# You can install the JSON module with 'cpan JSON' or by using your
# distribution’s package management system, for example apt-get install
# libjson-perl on Debian/Ubuntu.
use JSON;

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

# Don’t buffer any output.
$| = 1;

# Skip the first line which contains the version header.
print scalar <STDIN>;

# The second line contains the start of the infinite array.
print scalar <STDIN>;

# Read lines forever, ignore a comma at the beginning if it exists.
while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
    # Decode the JSON-encoded line.
    my @blocks = @{decode_json($statusline)};

    my $lil = `tlp-stat -s | grep Mode | cut -d= -f2`;
    # my $lil = `cat /etc/tlp.conf | egrep ^#TLP_DEFAULT_MODE | egrep -o 'AC|BAT'`;
    # my $lol = `vnstat -m | tail -n +6 | head -n1`;
    my $lol = `vnstat | grep today | awk '{print substr(\$8, 1, 3)""substr (\$9, 1, 1)}'`;
    my $lal = `vnstat | grep yesterday | awk '{print substr (\$8, 1, 3)""substr (\$9, 1, 1)}'`;
    my $lul = `vnstat -w | grep "current week" | awk '{print substr(\$9, 1, 3)""substr (\$10, 1, 1)}'`;
    my $lel = `vnstat -m | grep "\`date +"%b '%y"\`" | awk '{print substr(\$9, 1, 3)""substr (\$10, 1, 1)}'`;

    # Prefix our own information (you could also suffix or insert in the
    # middle).
    @blocks = ({
         full_text => "T: " . trim($lol) . " | Y: " . trim($lal) . " | Wk: " . trim($lul) . " | Mth: " . trim($lel) . " | " . trim($lil) . " ",
    }, @blocks);

    # Output the line as JSON.
    print encode_json(\@blocks) . ",\n";
    #print encode_json("\$_") . ",\n";
}
