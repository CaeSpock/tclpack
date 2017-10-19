bind join - *!*@*.* join_canal

proc join_canal {nick uh hd ch} {
  global botnick
  if { $nick != $botnick } {
	puthelp "NOTICE $nick :Heya \2$nick\2, welcome to \2$chan\2! Have fun!!"
  }
}

putlog "Loaded: Greet.TCL 1.2 by CaeSpock!"

