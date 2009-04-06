use inc::Module::Install;

name 'HTTP-Engine-Role';
all_from 'lib/HTTP/Engine/Role.pm';

build_requires 'Catalyst::Runtime';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
