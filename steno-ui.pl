#!/usr/bin/perl
#See https://docstore.mik.ua/orelly/perl3/tk/index.htm
use warnings;
use strict;
use Tk;
use File::stat;
use Fcntl;
binmode STDOUT, ":utf8";
use utf8;
use JSON;

my $data;
{
  local $/;
  open my $fh, "<", "test.json";
  $data = <$fh>;
  close $fh;
}

my $json = decode_json($data);
my $mw = tkinit;
$mw->update;
my $number;
my $filename = 'test.json';
my $newUpdateTime;
my $lastUpdateTime  = (stat($filename)->mtime);
notify( $mw, "Steno UI started", 2000 );
$mw->repeat(
    2000,
    sub {
        $newUpdateTime  = (stat($filename)->mtime);
        if ($newUpdateTime > $lastUpdateTime) {
            notify( $mw, "$json->{'mode'} $lastUpdateTime", 2000 );
            $lastUpdateTime  = $newUpdateTime;
        }
    }
    );

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
