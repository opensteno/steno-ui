#!/usr/bin/perl
#See https://docstore.mik.ua/orelly/perl3/tk/index.htm
use warnings;
use strict;
use Tk;
my $mw = tkinit;
$mw->update;
my $number;

notify( $mw, "Notification Window #" . ++$number, 1000 );
$mw->repeat( 15000,
             sub { notify( $mw, "Notification Window #" . ++$number, 1000 ) } );

MainLoop;

sub notify {
    my ( $mw, $message, $ms ) = @_;
    my $notification = $mw->Toplevel();
    $notification->transient($mw);
    $notification->overrideredirect(1);
    $notification->Popup( -popanchor => 'c' );
    $notification->geometry("-0+20");
    my $frame = $notification->Frame( -border => 5, -relief => 'groove' )->pack;
    $frame->Label( -text => $message, )->pack( -padx => 5 );
    $frame->Button(
        -text    => 'OK',
        -command => sub { $notification->destroy; undef $notification 
        },
        )->pack( -pady => 5 );
    $notification->after( $ms, sub { $notification->destroy } );
}
