# AntiDCCSend.TCL v.2.1
# by CaeSpock <cae@caespock.org>

# Channel to monitor
set canaldcc "#Example"
# Length of ban
set tiempoban 15

bind notc - "DCC Send*" envio_archivo

proc envio_archivo {nick uh hd texto {dest ""}} {
	global canaldcc botnick tiempoban
	putlog "User $nick ($uh) trying to send [lindex $texto 2] Banning"
	set motivo_dcc "User auto sending [lindex $texto 2]"
	newchanban $canaldcc *!*[string range $uh [string first @ $uh] end] $botnick $motivo_dcc $tiempoban
	puthelp "notice $nick :You are infected with the \2[lindex $texto 2]\2 virus, and you are auto sending it to all the users ont he channel. Please go to\2 http://www.nohack.net/ \2for more info."
	putserv "KICK $canaldcc $nick :$motivo_dcc"
	putserv "mode $canaldcc +b *!*[string range $uh [string first @ $uh] end]"
	return 0
}

putlog "Loaded: AntiDCCSend.TCL 2.1 by CaeSpock!"

