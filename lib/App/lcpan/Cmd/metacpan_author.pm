package App::lcpan::Cmd::metacpan_author;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

require App::lcpan;

our %SPEC;

$SPEC{handle_cmd} = {
    v => 1.1,
    summary => 'Open author page on MetaCPAN',
    description => <<'_',

Given author with CPAN ID `CPANID`, this will open
`https://metacpan.org/author/CPANID`. `CPANID` will first be checked for
existence in local index database.

_
    args => {
        %App::lcpan::common_args,
        %App::lcpan::author_args,
    },
};
sub handle_cmd {
    my %args = @_;
    my $author = $args{author};

    my $state = App::lcpan::_init(\%args, 'ro');
    my $dbh = $state->{dbh};

    my ($cpanid) = $dbh->selectrow_array(
        "SELECT cpanid FROM author WHERE cpanid=?", {}, uc $author);
    defined $cpanid or return [404, "No such author '$author'"];

    require Browser::Open;
    my $err = Browser::Open::open_browser("https://metacpan.org/author/$cpanid");
    return [500, "Can't open browser"] if $err;
    [200];
}

1;
# ABSTRACT:
