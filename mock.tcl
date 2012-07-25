#!/bin/sh
# the next line ignored by Tcl \
exec tclsh "$0" "$@"

package require logger

source [file join [file dirname [info script]] protocol.tcl]

proc showstate {} {
    upvar 1 state state
    set ret {}
    dict for {key value} $state {
        lappend ret "$key = $value"
    }
    return [join $ret "\n"]
}

namespace eval mock {
    variable log
    set log [logger::init mock]
    namespace export {init}
    variable serversocket

    proc closeSocket {socket} {
        variable log
        variable $socket
        upvar 0 $socket state
        ${log}::notice "closing $socket"
        catch {close $socket}
        unset state
    }

    # This gets called whenever a client sends a new line
    # of data or disconnects
    proc handler {socket} {
        variable log
        variable $socket
        upvar 0 $socket state

        # Do we have a disconnect?
        if {[eof $socket]} {
            closeSocket $socket
            return
        }
        # Does reading the socket give us an error?
        if {[catch {gets $socket line} ret] == -1} {
            closeSocket $socket
            return
        }
        # Did we really get a whole line?
        if {$ret == -1} return
        # ... and is it not empty? ...
        set line [string trim $line]
        if {$line == ""} return
        ${log}::notice "$socket > $line"
        if {[catch {slave eval $line} ret]} {
            ${log}::warn "$ret: {$line}"
            set ret "ERROR: $ret"
        } else {
            ${log}::notice [regsub -all -line ^ $ret "$socket < "]
        }
        if {[catch {puts $socket $ret}]} {
            closeSocket $socket
        }
    }

    # This gets called whenever a client connects
    proc server {socket host port} {
        variable log
        variable $socket
        upvar 0 $socket state
        # just to be sure ...
        if {[info exist state]} {
            unset state
        }
        set state [dict create]
        dict set state socket $socket
        dict set state host $host
        dict set state port $port
        ${log}::notice "new connection: $socket $host $port"
        fconfigure $socket -buffering line -blocking 0
        fileevent $socket readable [list [namespace code handler] $socket]
    }

    # Initialize server sockets
    proc init {} {
        variable log
        interp create -safe slave
        set commands {showstate}
        foreach command $commands {
            interp alias slave $command {} $command
        }
        ${log}::notice "supported commands: [join $commands ,]"
        ::socket -server [namespace code server] 4242
        ${log}::notice "listening at 4242"
    }
}
