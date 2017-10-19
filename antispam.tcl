# AntiSpam.TCL v.1.1
# by CaeSpock <cae@bolivia-internet.com>

# What Channel to Monitor
set canalspam "#Channel"
# Length of ban
set tiempo_ban_spam 15
# Reason for the kick
set razonspam "Mensajes automaticos de script NO permitidos."

# Define here all the combinations of spam
bind notc - "*script*" envio_spam
bind notc - "*X-Cript*" envio_spam
bind notc - "*IRcap*" envio_spam
bind notc - "*satan*" envio_spam
bind notc - "*http*" envio_spam
bind notc - "*www.*" envio_spam
bind notc - "*Al©oSS S©®IpT*" envio_spam
bind notc - "*§åtåñ §©®ïþt*" envio_spam
bind notc - "*T-TÅ_§Ç®ÎPT*" envio_spam
bind notc - "*^MeTaLLiCo^*" envio_spam

bind pubm - "*unca he visto a*" spam_publico
bind pubm - "*http*" spam_publico
bind pubm - "*N|Ght(M)aRe ScripT*" spam_publico
bind pubm - "*split detectado*" spam_publico
bind pubm - "*www.*" spam_publico
bind pubm - "*§åtåñ §©®ïþt*" spam_publico
bind pubm - "*Al©oSS S©®IpT*" spam_publico
bind pubm - "*X-Cript*" spam_publico
bind pubm - "*T-TÅ_§Ç®ÎPT*" spam_publico
bind pubm - "*^MeTaLLiCo^*" spam_publico
bind pubm - "*IRcap*" spam_publico
bind pubm - "*iVeSiTo ScripT*" spam_publico
bind pubm - "*script*" spam_publico
bind pubm - "*away*" spam_publico
bind pubm - "*/ctcp* *PAGE*" spam_publico
bind pubm - "*/ctcp* *page*" spam_publico
bind pubm - "*Auto Ausencia*" spam_publico

bind ctcp - ACTION spam_ctcp

# You shouldent have to modify from here

proc envio_spam {nick uh hd texto} {
  global canalspam botnick tiempo_ban_spam razonspam
  putlog "\2Spam: $nick\2 ($hd) dijo $texto "
  if {$hd != "*"} {
    if {([matchattr $hd m]) || ([matchattr $hd n]) || ([matchattr $hd o]) || ([matchattr $hd b])} {
       return 0
    }
  }
  if { $nick != $botnick } {
	  newchanban $canalspam *!*[string range $uh [string first @ $uh] end] $botnick $razonspam $tiempo_ban_spam
          puthelp "notice $nick :In \2$canalspam\2 We dont allow spam messsages!"
	  putserv "KICK $canalspam $nick :$razonspam"
	  putserv "mode $canalspam +b *!*[string range $uh [string first @ $uh] end]"
  }
  return 0
}

proc spam_publico {nick uhost hand chan rest} {
  global botnick tiempo_ban_spam razonspam
  putlog "\2Spam: $nick\2 (\2$hand\2) dijo:$rest"
  if {$hand != "*"} {
    if {([matchattr $hand m]) || ([matchattr $hand n]) || ([matchattr $hand o]) || ([matchattr $hand b])} {
      puthelp "PRIVMSG $chan :\001ACTION listens to $nick and smiles :-)\001"
      return 0
    }
  }
  puthelp "notice $nick :En \2$chan\2 In \2$canalspam\2 We dont allow spam messsages!"
  set baneo *!*[string range $uhost [string first @ $uhost] end]
  newchanban $chan $baneo $botnick $razonspam $tiempo_ban_spam
  putserv "KICK $chan $nick :$razonspam"
  putserv "mode $chan +b $baneo"
  return 0
}

proc spam_ctcp { nk uh hd dest kw arg } {
  global canalspam botnick tiempo_ban_spam razonspam
  if {[string match "*www.*" [string tolower $arg]]  || [string match "*ircap*" [string tolower $arg]] || [string match "*script*" [string tolower $arg]] || [string match "*split detectado*" [string tolower $arg]] || [string match "*away*" [string tolower $arg]]  || [string match "*^MeTaLLiCo^*" [string tolower $arg]]} {
    putlog "\2Spam: $nk\2 (\2$hd\2) dijo:$arg"
    if {$hd != "*"} {
      if {([matchattr $hd m]) || ([matchattr $hd n]) || ([matchattr $hd o]) || ([matchattr $hd b])} {
        puthelp "PRIVMSG $canalspam :\001ACTION listens to $nk and smiles :-)\001"
        return 0
      }
    }
    puthelp "notice $nk :En \2$canalspam\2 In \2$canalspam\2 We dont allow spam messsages!"
    set baneo *!*[string range $uh [string first @ $uh] end]
    newchanban $canalspam $baneo $botnick $razonspam $tiempo_ban_spam
    putserv "KICK $canalspam $nk :$razonspam"
    putserv "mode $canalspam +b $baneo"
  }
  return 0
}

putlog "Loaded: AntiSpam.TCL 1.1 by CaeSpock!"

