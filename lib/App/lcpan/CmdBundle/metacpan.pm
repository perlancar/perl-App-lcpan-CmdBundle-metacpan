package App::lcpan::CmdBundle::metacpan;

# AUTHORITY
# DATE
# DIST
# VERSION

our $db_schema_spec = {
    component_name => 'metacpan',
    provides => [
        'metacpan_favorite',
    ],
    latest_v => 1,
    install => [
        'CREATE TABLE metacpan_favorite (
             time INT NOT NULL,
             dist VARCHAR(90) NOT NULL, -- XXX references dist(name)
             id VARCHAR(90) NOT NULL,
             total INT NOT NULL,
             rec_ctime INT,
             rec_mtime INT
         )',
        'CREATE INDEX ix_metacpan_favorite__time ON metacpan_favorite(time)',
        'CREATE INDEX ix_metacpan_favorite__dist ON metacpan_favorite(dist)',
        'CREATE INDEX ix_metacpan_favorite__rec_ctime ON metacpan_favorite(rec_ctime)',
        'CREATE INDEX ix_metacpan_favorite__rec_mtime ON metacpan_favorite(rec_mtime)',
    ],
};

1;
# ABSTRACT: More lcpan subcommands related to MetaCPAN

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 SEE ALSO

L<lcpan>

L<https://metacpan.org>
