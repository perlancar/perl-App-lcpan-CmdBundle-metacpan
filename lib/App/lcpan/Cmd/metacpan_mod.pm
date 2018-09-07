package App::lcpan::Cmd::metacpan_mod;

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
    summary => 'Open module POD on MetaCPAN',
    description => <<'_',

This will open `https://metacpan.org/pod/MODNAME`. `MODNAME` will first be
checked for existence in local index database.

_
    args => {
        %App::lcpan::common_args,
        %App::lcpan::mods_args,
    },
};
sub handle_cmd {
    my %args = @_;

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my $envres = envresmulti();
    for my $mod (@{ $args{modules} }) {
        my ($file_id) = $dbh->selectrow_array(
            "SELECT file_id FROM module WHERE name=?", {}, $mod);
        $file_id or do {
            $envres->add_result(404, "No such module '$mod'");
            next;
        };

        require Browser::Open;
        my $url = "https://metacpan.org/pod/$mod";
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
