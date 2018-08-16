# DALops TCL ver 1.3.5 by CaeSpock <Cae@CaeSpock.ORG>
#
# This TCL will try to gain ops on channels via NickServ/Chanserv
# Will prevent so the bot doesnt flood services.
#
# I suggest:
# . Leave in black the need-op section
#   need-op {   }
# . In the init-server :
#   set init-server {putserv "MODE $botnick +i-ws"
#   identif }
#   And define this procedure:
#   proc identif { } {
#         putlog "Identifying as I enter the server"
#         putserv "nickserv IDENTIFY BotNick PassForBot1"
#         putserv "nickserv IDENTIFY AltNick PassForBot2"
#   }
#
# Options:
# In the DCC
# .identify <- will identify to services and request ops
# Automatic:
# As soon as chanserv/nickserv requests, the TCL will auto identify
#

###  VARIABLES SECTION  ###
### YOU CAN MODIFY THIS ###

### Please put your bot's main nick and password
set nick_bot "BotNick"
set nick_pass "PassForBot1"
### Please put your bot's secondary nick and password
set nick_2_bot "BotNick2"
set nick_2_pass "PassForBot2"
### Please put the time lenght in minutes between each identify to gain ops
set cada_cuanto 3
### Please put the channels your bot resides, separated by spaces
set canales "#CaeSpock"
### Why i didnt use the $channels global variable?
### Cause some bots are not ment to be oped on some channels they are in

###      !CODE GOES HERE!     ###
### !MODIFY AT YOUR OWN RISK! ###

bind dcc - identify identificarse
bind notc - "*/msg NickServ*IDENTIFY*" notice_ident
bind notc - "*is operated by ChanSer*" notice_ident

proc identificarse {handle idx args} {
  	global nick_bot nick_2_bot nick_pass nick_2_pass canales botnick
        putserv "nickserv IDENTIFY $nick_bot $nick_pass"
        if {$nick_2_bot != ""} {
          putserv "nickserv IDENTIFY $nick_2_bot $nick_2_pass"
        }
        set total_canales [llength $canales]
        for {set contador 0} {$contador < $total_canales} {incr contador} {
           putserv "chanserv op [lindex $canales $contador] $botnick"
           putdcc $idx "Identifying and requesting ops at \2[lindex $canales $contador]\2.\n"
        }
}

proc notice_ident {nick host handle text {dest ""}} {
  	global nick_bot nick_2_bot nick_pass nick_2_pass canales botnick
	if {$dest==""} { set dest $botnick }
        putserv "nickserv IDENTIFY $nick_bot $nick_pass"
        if {$nick_2_bot != ""} {
          putserv "nickserv IDENTIFY $nick_2_bot $nick_2_pass"
        }
        set total_canales [llength $canales]
        for {set contador 0} {$contador < $total_canales} {incr contador} {
           putserv "chanserv op [lindex $canales $contador] $botnick"
           putlog "Identifying and requesting ops at \2[lindex $canales $contador]\2 on \2$nick\2's request."
        }
}

proc identificarme {} {
  global nick_bot nick_2_bot nick_pass nick_2_pass cada_cuanto _tiempo_timer canales server botnick
  unset _tiempo_timer
  if {$canales == "" || $nick_pass == ""} {
    putlog "Error: Channels or Pass not defined!"
    return 0
  }
  set total_canales [llength $canales]
  for {set contador 0} {$contador < $total_canales} {incr contador} {
      if {![botisop [lindex $canales $contador]]} {
        putserv "nickserv IDENTIFY $nick_bot $nick_pass"
        if {$nick_2_bot != ""} {
          putserv "nickserv IDENTIFY $nick_2_bot $nick_2_pass"
        }
        putserv "chanserv op [lindex $canales $contador] $botnick"
        putlog "Trying to gain ops on \2[lindex $canales $contador]\2"
      }
  }
  if { [info exists _tiempo_timer] } { killtimer $_tiempo_timer }
  set _tiempo_timer [timer $cada_cuanto identificarme]
}

# Startup of the script, once the bot is restarted will start here:

if { [info exists _tiempo_timer] } { killtimer $_tiempo_timer }

set _tiempo_timer [timer $cada_cuanto identificarme]

putlog "DALnet GetOps v.1.3.5 by CaeSpock loaded & Configured for $nick_bot !"

