package Thread::Actor;

use 5.010;
use strict;
use warnings;

our $VERSION = '0.001';

use threads::lite qw/spawn/;
use Carp qw/croak/;

sub _trampoline {
	my ($class) = @_ = threads::lite::receive;
	goto $class->can('run');
}

use namespace::clean;

sub import {
	goto &threads::lite::import;
}

sub create {
	my ($class, $options, @arguments) = @_;
	croak "class $class doesn't have a run method" unless defined $class->can('run');
	unshift @{ $options->{modules} }, $class;
	unshift @arguments, $class;
	my @threads = spawn($options, \&_trampoline);
	$_->send(@arguments) for @threads;
	return @threads;
}

1;    # End of Thread::Actor

=head1 NAME

Thread::Actor - Actor threads made symple

=head1 VERSION

Version 0.001

=head1 SYNOPSIS

 package PingPong;
 use Thread::Actor qw/receive/;
 use parent 'Thread::Actor';

 sub run {
     while (my ($other, @message) = receive) {
         $other->send(@message);
     }
 }

=head1 DESCRIPTION

Thread::Actor is a user friendly and object-oriented wrapper around L<threads::lite>. It was created because threads::lite has some powerful but confusing behavior, in particular around the start-up function. Thread::Actor is meant to be inherited from, though it also exports functions.

=head1 EXPORTING

This module delegates exporting to L<threads::lite>.

=head1 METHODS

=head2 create($options, @arguments)

This method starts a new thread using $options (as specefied for threads::lite::spawn) and calls $class->run(@arguments) in it.

=head2 run

This is an abstract method, meaning you will have to define it in your subclass. It is run with the arguments provides in create.

=head1 AUTHOR

Leon Timmermans, C<< <leont at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-thread-actor at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Thread-Actor>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SEE ALSO

Thread::Appartment

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Thread::Actor


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Thread-Actor>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Thread-Actor>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Thread-Actor>

=item * Search CPAN

L<http://search.cpan.org/dist/Thread-Actor>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2010 Leon Timmermans, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
