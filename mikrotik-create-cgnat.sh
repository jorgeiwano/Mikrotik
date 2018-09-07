{
# interface de saida para NAT
:local outInterface "ether1";
# prefixo do range de ip valido
:local outRange "168.227.101";
# prefixo do range de ip invalido
:local natRange "100.64";
# network inicial do range de ip invalido
# ex1: "100.64.0.0/21 = usar terceiro octeto=0"
# ex2: "100.64.8.0/21 = usar terceiro octeto=8"
:local i 40;
# range das networks 
:local natRangeMask "128/26";
# nome do pool
:local poolName "CGNAT2";
# port map 1 para 7 (rotear /21 = 8 networks /24, 1 /24 sobra)
:local ports "1024-9999, 10000-19999, 20000-29999, 30000-39999, 40000-49999, 50000-59999, 60000-65535";


# nao alterar a partir daqui
:local ports [:toarray $ports];
:local poolCGNAT "";
:local range "";
/ip firewall nat
:foreach port in=$ports do={;
	:set range "$natRange.$i.$natRangeMask";
	:set poolCGNAT ("$range," . $poolCGNAT);
	add action=netmap chain=srcnat out-interface=$outInterface protocol=tcp src-address=$range to-addresses="$outRange.$natRangeMask" to-ports=$port comment="CGNAT";
	add action=netmap chain=srcnat out-interface=$outInterface protocol=udp src-address=$range to-addresses="$outRange.$natRangeMask" to-ports=$port comment="CGNAT";
	add action=netmap chain=srcnat out-interface=$outInterface src-address=$range to-addresses="$outRange.$natRangeMask" comment="CGNAT";
	:set i ($i+1);
};
/ip pool add name=$poolName ranges=$poolCGNAT;
}