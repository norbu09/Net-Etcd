package Net::Etcd;

use Modern::Perl;
use Mouse;
use JSON;
use LWP::UserAgent;
use HTTP::Request;
use Data::Printer;

# ABSTRACT: Perl interface to etcd

# VERSION

use Data::Dump;

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Some::Module;
    use Data::Dump 'dump';

=head1 ATTRIBUTES

=head2 agent

=cut

has 'agent' => (
    is       => 'rw',
    isa      => 'LWP::UserAgent',
    lazy     => 1,
    required => 1,
    builder  => '_build_agent',
);

=head2 strict_ssl

=cut

has 'strict_ssl' => (
    is       => 'rw',
    isa      => 'Bool',
    default  => sub { 0 },
    lazy     => 1,
    required => 1,
);

=head2 debug

=cut

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => sub { 0 },
    lazy    => 1,
);

=head2 uri

=cut

has 'uri' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub { 'http://127.0.0.1:4001' },
    lazy    => 1,
);

sub _build_agent {
    my ($self) = @_;

    return LWP::UserAgent->new(
        ssl_opts => { verify_hostname => $self->strict_ssl },);
}

=head1 SUBROUTINES/METHODS

=head2 get

=cut

sub get {
    my ($self, $key, $raw) = @_;

    my $conf = $self->_talk($key, 'get');
    return $conf if $raw;
    return $conf if exists $conf->{error};

    if (exists $conf->{node}->{nodes}) {

        # we deal with a dir not a single value
        my %tree;
        foreach my $node (@{ $conf->{node}->{nodes} }) {
            my @nodes = split('/', $node->{key});
            shift(@nodes);
            _insert(\%tree, $node->{value}, @nodes);
        }
        return \%tree;
    }
    else {
        return { $key => $conf->{node}->{value} };
    }
}

=head2 set

Sets a value in etcd

This function returns undef on success and an error message on error

=cut

sub set {
    my ($self, $hash, $method, $base) = @_;

    my $res;
    $method = 'put' unless $method;
    foreach my $key (keys %$hash) {
        if (ref($hash->{$key} eq 'HASH')) {
            $res = $self->set($hash->{$key}, 'post', $key);
        }
        else {
            my $path = ($base ? join('/', $base, $key) : $key);
            $res = $self->_talk($path, $method, $hash->{$key});
        }
        return $res->{error} if exists $res->{error};
    }
    return unless exists $res->{error};
    return $res->{error};
}

sub _talk {
    my ($self, $path, $method, $value) = @_;

    my $req = HTTP::Request->new(uc($method),
        join('/', $self->uri, 'v2/keys', $path));
    $req->content("value=$value") if $value;

    p($req->dump) if $self->debug;
    my $res = $self->agent->request($req);

    if ($res->is_success) {
        say "Got Content ", $res->content if $self->debug;
        my $data;
        eval { $data = from_json($res->content); };
        if ($@) {

            # this doesn't look like JSON, might be file content
            warn "Could not parse response!\n";
            return;
        }
        return $data;
    }
    else {
        warn $res->status_line if $self->debug;
        given ($res->code) {
            when (403) { return { error => 'forbidden' }; }
            when (404) { return { error => 'not found' }; }
            default    { return { error => $res->status_line }; }
        }
    }
    return;
}

sub _insert {
    my ($ref, $value, $head, @tail) = @_;
    if (@tail) { _insert(\%{ $ref->{$head} }, $value, @tail) }
    else       { $ref->{$head} = $value }
}

=head1 BUGS

Please report any bugs or feature requests on GitHub's issue tracker L<https://github.com/norbu09/Net::Etcd/issues>.
Pull requests welcome.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Etcd


You can also look for information at:

=over 4

=item * GitHub repository

L<https://github.com/norbu09/Net::Etcd>

=item * MetaCPAN

L<https://metacpan.org/module/Net::Etcd>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net::Etcd>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net::Etcd>

=back


=head1 ACKNOWLEDGEMENTS

=over 4

=back

=cut

__PACKAGE__->meta->make_immutable();    # End of Net::Etcd
