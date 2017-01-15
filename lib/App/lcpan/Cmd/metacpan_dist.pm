package App::lcpan::Cmd::metacpan_dist;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::Any::IfLOG '$log';

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'Open distribution POD on MetaCPAN',
    description => <<'_',

Given distribution `DIST`, this will open
`https://metacpan.org/release/AUTHOR/DIST-VERSION`. `DIST` will first be checked
for existence in local index database.

_
    args => {
        %App::lcpan::common_args,
        %App::lcpan::dist_args,
    },
};
sub handle_cmd {
    my %args = @_;
    my $dist = $args{dist};

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my ($file_id, $cpanid, $version) = $dbh->selectrow_array(
        "SELECT file_id, cpanid, version FROM dist WHERE name=? AND is_latest", {}, $dist);
    $file_id or return [404, "No such dist '$dist'"];

    require Browser::Open;
    my $err = Browser::Open::open_browser("https://metacpan.org/release/$cpanid/$dist-$version");
    return [500, "Can't open browser"] if $err;
    [200];
}

1;
# ABSTRACT:
