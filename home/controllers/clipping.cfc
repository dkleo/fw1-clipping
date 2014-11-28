component accessors="true" {

    /**
     * and we add a declaration that the controller depends on the new clipping.cfc
     * (in model/services):
     */
    property clippingService;

    /**
     * init FW variables and methods so that they are available to this controller
     */
    function init(fw) {
        variables.fw = fw;
        return this;
    }

    /**
     * Generates clipping form
     * either for a new one, or for an update
     */
    function form (struct rc){
        // if we are updating, load form pre-populated
        // if(isdefined("rc.clipping_id") && isValid("integer",rc.clipping_id)){
        //     clipping = variables.clippingService.getClipping(rc.clipping_id)
        //     // copies obj properties to rc (so we can fill forms)
        //     application.copyPropertiesToRC(clipping, rc)
        // }
        // will render clipping.form view from here...

        // ------------ better way -----------------------
        param name="rc.clipping_id" default="0";
        if(!StructKeyExists(rc, "Clipping")) rc.Clipping = variables.clippingService.getClipping(rc.clipping_id);
        // rc.Validator = variables.NewsService.getValidator(rc.Clipping);
        // if(!StructKeyExists(rc, "result")) rc.result = rc.Validator.newResult();
    }

    /**
     * post or update an article
     */
    function post( struct rc ) {
        rc.errors = [];
        fw.frameworkTrace( "<b>post Method on Clipping Controller</b>");

        // ------------ start validation ---------
        // for now we are handling validation in the controllers.
        // later, we will move this to the model using validateThis()
        // https://groups.google.com/forum/#!topic/framework-one/Hh-YcyCQcJA
        if(!len(trim(rc.clipping_titulo))) {
            arrayAppend(rc.errors, "You must include a title for your clipping.");
        }

        if(!len(trim(rc.clipping_texto))) {
            arrayAppend(rc.errors, "You must include text for your clipping.");
        }

        if(len(trim(rc.clipping_link)) && !isValid("url", rc.clipping_link)) {
            arrayAppend(rc.errors, "If you include a link, it has to be formatted. Ex: http://www.link.com.");
        }

        if(!len(trim(rc.published)) || !isValid("eurodate", trim(rc.published))) {
            arrayAppend(rc.errors, "You must specify a valid publishing date.");
        }

        // if we have errors, go back to the form passing "ALL" rc values
        if(arrayLen(rc.errors)) {
            variables.fw.redirect("clipping.form", "all");
        }
        // ------------ end validation ---------

        // save (insert or update) this object
        // using the clippingService
        rc.data = variables.clippingService.post(rc);
        rc.clipping = rc.data
        // rc.clipping_id = rc.data.getClipping_id();

        // since there's no clipping.post view, we have to redirect somewhere
        variables.fw.redirect("main.default");
    }
}
