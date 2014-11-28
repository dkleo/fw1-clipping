

component extends="org.corfield.framework" {

    // ------------------------ APPLICATION SETTINGS ------------------------ //
    this.name = "clipping_app";
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0,2,0,0);
    this.dataSource = "dtb_clipping";
    this.ormEnabled = true;
    this.ormsettings = {
        // cfclocation="./model/beans",
        dbcreate="update",       // update database tables only
        dialect="MySQL",         // assume MySql, other dialects available http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WSED380324-6CBE-47cb-9E5E-26B66ACA9E81.html
        // eventhandling="true",
        // eventhandler="root.model.beans.eventhandler",
        logsql="true",
        flushAtRequestEnd = false
    };

    this.mappings["/root"] = getDirectoryFromPath(getCurrentTemplatePath());
    this.triggerDataMember = true // so we can access properties directly (no need for getters and setters)

    /**
     * Overiding the default configs ACROSS ALL ENVS
     * See: https://github.com/framework-one/fw1/wiki/Developing-Applications-Manual#configuring-fw1-applications
     */
    // ------------------------ FW/1 SETTINGS ------------------------ //
    variables.framework = {
        // home = 'home:main.default',
        reloadApplicationOnEveryRequest = true, //use this only in dev
        trace = false,

        // cannot use below unless server understands rewriting
        // generateSES = true,
        // SESOmitIndex=true,

        // routes = [
        //     { "/raiz/" = "/", hint="Routing example"},
        // ],

        // enable the use of subsystems
        // *** enabling this will break the tutorial ap as of 12-oct-14
        // see https://github.com/framework-one/fw1/wiki/Using-Subsystems
        usingSubsystems = true,
        defaultSubsystem = 'home', //default is 'home'
        siteWideLayoutSubsystem = 'common',
    }

    /**
    * customize framework variables based on environment
    * see: https://github.com/framework-one/fw1/wiki/Developing-Applications-Manual#environment-control
    */
   // ------------------------ ENVIRONMENT DEFINITIONS ------------------------ //
    public function getEnvironment() {
       if ( findNoCase( "localhost", CGI.SERVER_NAME ) ) return "prod";
       if ( findNoCase( "127.0.0.1", CGI.SERVER_NAME ) ) return "dev";
       else return "prod";
    }

    variables.framework.environments = {
       dev = { reloadApplicationOnEveryRequest = true,  trace = true,},
       prod = { password = "supersecret" }
    }

    /**
    * This creates an instance of framework.ioc (DI/1) and tells it to look
    * in the model folder for CFCs to manage, then it tells FW/1
    * to use that as the “bean factory”.
     */
    // ------------------------ CALLED WHEN APPLICATION STARTS ------------------------ //
    function setupApplication() {
        var bf = new framework.ioc( "model" );
        setBeanFactory( bf );

        // if we are using subsystems, this is how you setup the BeanFactory
        // for the "home" subsystem
        // https://github.com/framework-one/fw1/wiki/Using-Subsystems#setting-bean-factories-with-setupsubsystem
        var homeBf = new framework.ioc( "home/model" );
        setBeanFactory( homeBf );
        setSubsystemBeanFactory('home', homeBf);
        variables.frameworkTrace( "<b>Just setup Bean Factory</b>", 'homeBf');


        // setting an application var
        application.datasource = this.datasource;

        // include UDF functions
        // the functions inside the CFC cann be referred by application.functionName()
        application.tools = createObject("component", "lib.functions");
    }

    /**
     * setupSubsystem() is called once for each subsystem, when a subsystem is initialized.
     * reloaded, the initialized subsystems are cleared and setupSubsystem()
     * see: https://github.com/framework-one/fw1/wiki/Using-Subsystems#configuring-subsystems
     */
    function setupSubsystem(subsystem) {
        // do something when the subsystem is initiated
    }

    /**
     * If you have some logic that is meant to be run on **every** request,
     * the FW/1 way to implement this is to implement setupRequest()
     * in your Application.cfc and have it retrieve the desired controller
     * by name and run the appropriate event method, like this:
     *
     * Note that the request context itself is not available at this point!
     */
    function setupRequest() {
        // controller( 'security.checkAuthorization' );
        request.example_request_var = "Elephant";
    }

    /**
     * If you need to perform some actions after controllers and services have
     * completed but before any views are rendered, you can implement setupView()
     * in your Application.cfc and FW/1 will call it after setting up the view
     * and layout queue but before any rendering takes place:
     *
     * You cannot call controllers here
     */
    function setupView( struct rc ) {
        // pre-rendering logic
    }

    /**
     * This is called after all views and layouts have been rendered in a regular
     *  request or immediately before the redirect actually occurs when redirect()
     *  has been called.
     *
     *  You cannot call controllers here.
     */
    function setupResponse( struct rc ) {
        // end of request processing
    }

    /**
     * sets up session vars and logic when a session starts
     */
    function setupSession(){
        session.example_session_var = "platipus";
    }
}