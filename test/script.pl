#!/usr/bin/perl

#CREDIT TO ruoso http://daniel.ruoso.com/ 

use strict;
use warnings;
use utf8;
use 5.01000;

# we shouldn't use SDL::Timer, because it starts a different thread,
# and the SDL binding doesn't take care of that...
use Time::HiRes;

use SDL;
use SDL::App;
use SDL::Mouse;
use SDL::Color;
use SDL::Audio;
use SDL::AudioSpec;
use SDL::Event;
use SDL::Events;
use Devel::Peek;
my $p = 0;
my $f = 0;

sub callback{
  my ($int_size, $len, $streamref) = @_;

  for (my $i = 0; $i < $len; $i++) {
    use bytes;
    substr($$streamref, $i, 1, chr(sin($p)));

    if ($f && $p++ > 200) {
      $f = 0;
    } elsif (!$f && $p-- < 0) {
      $f = 1;
    }
  }


}

sub setup_audio
{
    my $desired = SDL::AudioSpec->new;
    my $obtained = SDL::AudioSpec->new;
    $desired->freq ( 44100 );
    $desired->format ( AUDIO_U8 );
    $desired->samples ( 4096 );
    $desired->callback( 'main::callback'); #canno
    $desired->channels ( 1 );
   
    die('AudioMixer, Unable to open audio: '.SDL::get_error."\n" ) if ( SDL::Audio::open($desired, $obtained) < 0 );


    SDL::Audio::pause(0);

  
}

setup_audio();

sleep(4);

SDL::quit();