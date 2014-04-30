package Net::Etcd;

use 5.012;
use Mouse;

# ABSTRACT: 

# VERSION

use Data::Dump;


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Some::Module;
    use Data::Dump 'dump';

=head1 ATTRIBUTES

=head2 attr

=cut

has 'attr' => (
    is => 'rw',
);



=head1 SUBROUTINES/METHODS

=head2 method

=cut

sub method {
    my ($self) = @_;
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

__PACKAGE__->meta->make_immutable();  # End of Net::Etcd
