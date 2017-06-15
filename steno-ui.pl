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
my $ui = $mw->Toplevel();
initUi( $ui, $mw);
$mw->repeat(
    2000,
    sub {
        $newUpdateTime  = (stat($filename)->mtime);
        if ($newUpdateTime > $lastUpdateTime) {
            notify( $mw, "Mode $json->{'mode'} $lastUpdateTime", 2000 );
            if ($json->{'command'} eq "close"){
                $ui->destroy;
                $mw->destroy;
            }
            if ($json->{'command'} eq "hide"){
            }
            if ($json->{'command'} eq "show"){
            }

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
    $notification->geometry("-0+60");
    my $frame = $notification->Frame( -border => 5, -relief => 'groove' )->pack;
    $frame->Label( -text => $message, )->pack( -padx => 5 );
    $notification->after( $ms, sub { $notification->destroy } );
}

sub initUi {
    my ( $ui, $mw ) = @_;
    $ui->transient($mw);
    $ui->overrideredirect(1);
    $ui->Popup( -popanchor => 'c' );
    $ui->geometry("-0+20");
    my $frame = $ui->Frame( -border => 5, -relief => 'groove' )->pack;
    $frame->Label( -text => "Status", )->pack( -padx => 5 );
}
