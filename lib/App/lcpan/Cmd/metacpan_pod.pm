package App::lcpan::Cmd::metacpan_pod;

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
    summary => 'Open a .pod file on MetaCPAN',
    description => <<'_',

This will open `https://metacpan.org/pod/NAME`. `NAME` will be first checked for
existence in local index database.

_
    args => {
        %App::lcpan::common_args,
        %App::lcpan::pods_args,
    },
};
sub handle_cmd {
    my %args = @_;

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $envres = envresmulti();
    for my $pod (@{ $args{pods} }) {
        (my $pod_path = $pod) =~ s!::!/!g;
        my ($file_id) = $dbh->selectrow_array(
            "SELECT id FROM content WHERE path LIKE '%/lib/${pod_path}.pod' OR path LIKE '%/${pod_path}.pod'", {});
        $file_id or do {
            $envres->add_result(404, "No such .pod '$pod'");
            next;
        };

        require Browser::Open;
        my $url = "https://metacpan.org/pod/$pod";
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
