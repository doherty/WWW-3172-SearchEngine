use Test::More tests => 6;
use strict;
use warnings;

# the order is important
use WWW::3172::SearchEngine;
use Dancer::Test;

route_exists        [GET => '/'],   'a route handler is defined for /';
response_status_is  [GET => '/'],   200, 'response status is 200 for /';

route_exists        [GET  => '/s'], 'a route handler is defined for /s';
route_exists        [POST => '/s'], 'a route handler is defined for POST /s';

foreach my $method (qw(GET POST)) {
    my $res = dancer_response $method, '/s', { params => { 'q' => 'test' } };
    response_status_is $res, 200, "response status is 200 for $method /s";
}

