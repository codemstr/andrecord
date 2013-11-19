use Android;
my $a = Android->new();
my $dir = '/sdcard/recording.mp3';
my $data;
my $offhook = 0;
while (1) {
 my $track = $a->startTrackingPhoneState();

 if ($track) {
	my $read = $a->readPhoneState();
	my $cur = $read->{result}->{state};
	my $num = $read->{result}->{incomingNumber};
	if ($cur eq 'idle') {
	   	if ($offhook == 1) {
			stoprecord();
			$offhook = 0;
		}
	   sleep 1;
	} else {
		if ($cur) {
			print "State: $cur\n";
		} 
		if ($cur eq 'offhook') {
			if ($offhook == 0) {	
				print "Started recording of microphone.\n";
				record();
				$offhook = 1;
			} else {
				$offhook = 1;
			}
		}
		sleep 1;
	}
	if ($num && $cur ne 'idle') {
	     if ($offhook == 0) {
		print "Incoming call from $num\n";
		#record();
		$offhook = 1;
	     } else {
		    print "Call from $num not recording\n";
		}
	 }
 
  }
}




sub record { 
   $a->recorderStartMicrophone("$dir");
}
sub stoprecord {
   $a->recorderStop();
}
