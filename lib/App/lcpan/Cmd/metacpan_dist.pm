package App::lcpan::Cmd::metacpan_dist;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

use Perinci::Object;

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
        %App::lcpan::dists_args,
    },
};
sub handle_cmd {
    my %args = @_;

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $envres = envresmulti();
    for my $dist (@{ $args{dists} }) {
        my ($file_id, $cpanid, $version) = $dbh->selectrow_array(
            "SELECT file_id, cpanid, version FROM dist WHERE name=? AND is_latest", {}, $dist);
        $file_id or do {
            $envres->add_result(404, "No such dist '$dist'");
            next;
        };

        require Browser::Open;
        my $url = "https://metacpan.org/release/$cpanid/$dist-$version";
        my $err = Browser::Open::open_browser($url);
        if ($err) {
            $envres->add_result(500, "Can't open browser for URL $url");
        } else {
            $envres->add_result(200, "OK");
        }
    }
    $envres->as_struct;
}

1;
# ABSTRACT:
