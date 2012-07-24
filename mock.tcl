#!/bin/sh
# the next line ignored by Tcl \
exec tclsh "$0" "$@"

# ===== REQUEST HEADERS =====

set request_header {
    c magic
    c opcode
    S keylen
    c extlen
    c datatype
    S vbucket
    I bodylen
    I opaque
    W cas
}

set request_get $request_header
set request_getq $request_header
set request_getk $request_header
set request_getkq $request_header
set request_gat [concat $request_header {
    I expiration
}]
set request_gatq $request_gat
set request_touch $request_gat
set request_delete $request_header
set request_flush [concat $request_header {
    I expiration
}]
set request_set [concat $request_header {
    I flags
    I expiration
}]
set request_add $request_set
set request_replace $request_set
set request_noop $request_header
set request_incr [concat $request_header {
    W delta
    W initial
    I expiration
}]
set request_decr $request_incr
set request_quit $request_header
set request_append $request_header
set request_prepend $request_header
set request_version $request_header
set request_stats $request_header
set request_verbosity [concat $request_header {
    I level
}]

# ===== RESPONSE HEADERS =====

set response_header {
    c magic
    c opcode
    S keylen
    c extlen
    c datatype
    S status
    I bodylen
    I opaque
    W cas
}

set response_get [concat $response_header {
    I flags
}]
set response_getq $response_get
set response_getk $response_get
set response_getkq $response_get
set response_gat $response_get
set response_gatq $response_get
set response_touch $response_header
set response_delete $response_header
set response_flush $response_header
set response_set $response_header
set response_add $response_header
set response_replace $response_header
set response_noop $response_header
set response_incr [concat $response_header {
    W value
}]
set response_decr $response_incr
set response_quit $response_header
set response_append $response_header
set response_prepend $response_header
set response_version $response_header
set response_stats $response_header
set response_verbosity $response_header
