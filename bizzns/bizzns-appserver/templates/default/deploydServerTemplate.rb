#!/bin/env node
//  Deployd Node Server
var express = require('express');
var fs      = require('fs');

var deployd = require('deployd');
var options = {};
var dpd ;
       




/**
 *  Define the sample application.
 */
var ServerApp = function() {

    //  Scope.
    var self = this;


    /*  ================================================================  */
    /*  Helper functions.                                                 */
    /*  ================================================================  */

    /**
     *  Set up server IP address and port # using env variables/defaults.
     */
    self.setupVariables = function() {
        //  Set the environment variables we need.
        self.ipaddress = <%= node['deployd']['server']['ipaddress'] %>;
        self.port      = <%= node['deployd']['server']['serverPort'] %> ;

        if (typeof self.ipaddress === "undefined") {
            //  Log errors  but continue w/ 127.0.0.1 - this
            //  allows us to run/test the app locally.
            console.warn(' using 127.0.0.1');
            self.ipaddress = "127.0.0.1";
            self.port = 8080;
        };


        options= {port: self.port , 
            db   : {
                port : <%= node['deployd']['server']['mongodbPort'] %>  ,
                host : self.ipaddress ,
                name : <%= node['deployd']['server']['name'] %>,
                credentials : {
                    username : "admin",
                    password : "8fl1zKohO94V"
                }
            },
            env : <%= node['deployd']['server']['env'] %>
        };
    };


    /**
     *  Populate the cache.
     */
     
    self.populateCache = function() {
        if (typeof self.zcache === "undefined") {
            self.zcache = { 'index.html': '' };
        }

        //  Local cache for static content.
        self.zcache['index.html'] = fs.readFileSync('./index.html');
    };


    /**
     *  Retrieve entry (content) from cache.
     *  @param {string} key  Key identifying content to retrieve from cache.
     */
    self.cache_get = function(key) { return self.zcache[key]; };


    /**
     *  terminator === the termination handler
     *  Terminate server on receipt of the specified signal.
     *  @param {string} sig  Signal to terminate on.
     */
    self.terminator = function(sig){
        if (typeof sig === "string") {
           console.log('%s: Received %s - terminating sample app ...',
                       Date(Date.now()), sig);
           process.exit(1);
        }
        console.log('%s: Node server stopped.', Date(Date.now()) );
    };


    /**
     *  Setup termination handlers (for exit and a list of signals).
     */
    self.setupTerminationHandlers = function(){
        //  Process on exit and signals.
        process.on('exit', function() { self.terminator(); });

        // Removed 'SIGPIPE' from the list - bugz 852598.
        ['SIGHUP', 'SIGINT', 'SIGQUIT', 'SIGILL', 'SIGTRAP', 'SIGABRT',
         'SIGBUS', 'SIGFPE', 'SIGUSR1', 'SIGSEGV', 'SIGUSR2', 'SIGTERM'
        ].forEach(function(element, index, array) {
            process.on(element, function() { self.terminator(element); });
        });
    };


    /*  ================================================================  */
    /*  App server functions (main app logic here).                       */
    /*  ================================================================  */

    /**
     *  Create the routing table entries + handlers for the application.
     */
    self.createRoutes = function() {
        self.routes = { };

        self.routes['/asciimo'] = function(req, res) {
            var link = "http://i.imgur.com/kmbjB.png";
            res.send("<html><body><img src='" + link + "'></body></html>");
        };

        self.routes['/'] = function(req, res) {
            res.setHeader('Content-Type', 'text/html');
            res.send(self.cache_get('index.html') );
        };
    };


    /**
     *  Initialize the server (express) and create the routes and register
     *  the handlers.
     */
    self.initializeServer = function() {
        self.createRoutes();
        self.app = express();

        //  Add handlers for the app (from the routes).
        for (var r in self.routes) {
            self.app.get(r, self.routes[r]);
        }
    };


    /**
     *  Initializes the sample application.
     */
    self.initialize = function() {
        self.setupVariables();
        self.populateCache();
        self.setupTerminationHandlers();

        // Create the express server and routes.
        self.initializeServer();
    };


    /**
     *  Start the server (starts up the sample application).
     */
    self.start = function() {
         //Start the app on the specific interface (and port).
        // self.app.listen(self.port, self.ipaddress, function() {
        //    console.log('%s: Node server started on %s:%d ...',
        //                Date(Date.now() ), self.ipaddress, self.port);
        // });

        
        dpd = deployd(options);
        dpd.listen(self.port,self.ipaddress);
        console.log("!!!!! dpd listen called !!!!");
        console.log('%s: Node server started on %s:%d ...',
                     Date(Date.now() ), self.ipaddress, self.port);
        dpd.on('listening', function() {
                console.log("DPD Server is listening with process.env == "  + self.ipaddress + ":: " + options.port );
                var todos = dpd.createStore('todos');
                console.log("dpd.createstore call didnt fail!!!!!  "  );
                process.chdir(__dirname);
                //console.log("__dirname === >> " + __dirname);
        });

        dpd.on('error', function(err) {
                console.error("dpd error" + err);
                process.nextTick(function() { // Give the server a chance to return an error
                process.exit();
        });
});
    };

};   /*  Sample Application.  */



/**
 *  main():  Main code.
 */
var zapp = new ServerApp();
zapp.initialize();
zapp.start();

