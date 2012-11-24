# Slightly Nicer Futon

**futon_couchdb** is a plugin for Apache CouchDB 1.2 which adds a little bit of flexibility when serving Futon.

Primarily, this is a simple reference implementation of a CouchDB plugin. Noteworthy lessons:

* Making a minimal Rebar (Erlang) project
* Building such a project, "linking" against CouchDB.
* Integrating the plugin (an http handler) into CouchDB
* Supporting custom configuration options, and defining their defaults

## Features

futon_couchdb does the following.

1. Detect mobile browsers and serve Futon from an apparenty hard-coded alternative directory, `mobilefuton/`.
1. Add an Easter egg: if the requested hostname has a final dot (`"example.com."`&mdash;yes, that is valid), serve Sammy Futon from `sammy_futon/`.
1. Or, if the `httpd/sammy_futon` config is `true`, serve Sammy Futon.

## Building

If you hate Freedom, just sign up for an [Iris Couch][ic] account, since they run hosted CouchDB with this plugin.

To build for yourself, use Build CouchDB: https://github.com/iriscouch/build-couchdb

    rake plugin="git://github.com/iriscouch/pingquery_couchdb origin/master"

[ic]: http://www.iriscouch.com/service

## Installation

Build CouchDB already took care of this step!

## Development

This is what I do. It's not perfect but barely harder than building a fork of CouchDB, and it allows 1.0.x, 1.1.x, as well as trunk support.

This example assumes three Git checkouts, side-by-side:

* `couchdb` - Perhaps a trunk checkout, but could be any tag or branch
* `build-couchdb` (optional) - For the boring Couch dependencies
* This project

### Build dependencies plus couch

You can build CouchDB however you like. Just complete `make dev` successfully. This example uses Build CouchDB.

    cd couchdb
    rake -f ../build-couchdb/Rakefile couchdb:configure
    # Go get coffee. This builds the deps, then runs the boostrap and configure scripts
    make dev

Next, teach rebar where to find CouchDB, and teach Erlang and Couch where to find this plugin.

    cd ../pingquery_couchdb
    export ERL_COMPILER_OPTIONS='[{i, "../couchdb/src/couchdb"}]'
    export ERL_ZFLAGS="-pz $PWD/ebin"
    ln -s "../../../../pingquery_couchdb/etc/couchdb/default.d/pingquery.ini" ../couchdb/etc/couchdb/default.d

You're ready. Run this every time you change the code:

    ./rebar compile && ../couchdb/utils/run -i
