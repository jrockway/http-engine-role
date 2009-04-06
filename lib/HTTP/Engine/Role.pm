package HTTP::Engine::Role;
use Moose::Role;

use HTTP::Engine;
require MooseX::Getopt;

use MooseX::Types -declare => [qw/PortNumber/];
use MooseX::Types::Moose 'Int';

# setup useful types

subtype PortNumber,
  as Int,
  where { $_ > 0 && $_ < 65536 },
  message { "The port number must be between 1 and 65536" };

class_type 'HTTP::Engine::Request';
class_type 'HTTP::Engine::Response';
class_type 'HTTP::Engine';

use namespace::clean -except => 'meta';

requires 'handle_request';

has '_engine_type' => (
    is      => 'ro',
    isa     => 'Str',
    traits  => ['NoGetopt'],
    default => 'ServerSimple',
);

has 'port' => (
    is            => 'ro',
    isa           => PortNumber,
    required      => 1,
    documentation => 'The port to bind the HTTP server to.',
);

has 'engine' => (
    traits     => ['NoGetopt'],
    is         => 'ro',
    isa        => 'HTTP::Engine',
    lazy_build => 1,
);

sub _build_engine {
    my $self = shift;
    my $e = HTTP::Engine->new(
        interface => {
            module => $self->_engine_type,
            args   => {
                host => 'localhost',
                port => $self->port,
            },
            request_handler => sub {
                $self->handle_request(@_);
            },
        },
    );
    return $e;
}

1;

