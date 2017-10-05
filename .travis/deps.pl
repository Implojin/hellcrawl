#!/usr/bin/env perl
use strict;
use warnings;

my @deps = qw(
    gdb
);

if ($ENV{BUILD_ALL}) {
    retry(qw(git submodule update --init --recursive));

    push @deps, qw(
       libegl1-mesa-dev
       libasound2-dev
       libxss-dev
       mingw-w64
       gcc-mingw-w64
       gcc-mingw-w64-i686
       g++-mingw-w64-i686
       gcc-mingw-w64-x86-64
       binutils-mingw-w64-i686
       binutils-mingw-w64-x86-64
    );
}
else {
    push @deps, qw(
        liblua5.1-0-dev
        liblua5.1-0-dbg
        mingw-w64
        gcc-mingw-w64
        gcc-mingw-w64-i686
        g++-mingw-w64-i686
        gcc-mingw-w64-x86-64
        binutils-mingw-w64-i686
        binutils-mingw-w64-x86-64
    );

    push @deps, qw(
        libsdl2-dev
        libsdl2-image-dev
        libsdl2-mixer-dev
    ) if $ENV{TILES} || $ENV{WEBTILES};
}

retry(qw(sudo apt-get install), @deps);

sub retry {
    my (@cmd) = @_;

    my $tries = 5;
    my $sleep = 5;

    my $ret;
    while ($tries--) {
        print "Running '@cmd'\n";
        $ret = system(@cmd);
        return if $ret == 0;
        print "'@cmd' failed ($ret), retrying in $sleep seconds...\n";
        sleep $sleep;
    }

    print "Failed to run '@cmd' ($ret)\n";
    # 1 if there was a signal or system() failed, otherwise the exit status.
    exit($ret & 127 ? 1 : $ret >> 8);
}
