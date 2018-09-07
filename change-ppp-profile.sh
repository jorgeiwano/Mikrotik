{
	:local ns1 "172.30.30.10";
	:local ns2 "8.8.8.8";
	:foreach i in=[/ppp profile find] do={
		/ppp profile set $i dns-server="$ns1, $ns2"
	}
}