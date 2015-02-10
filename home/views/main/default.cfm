<!-- home::views/default -->
<cfoutput>
  | <a href="#buildURL('clipping.form')#">Add an Article</a>
  | <a href="javascript: ajaxClippingForm('#buildURL('clipping.ajaxForm')#');">Add an Article (Ajax)</a>
  |
  <br/>
</cfoutput>
<br/>

<cfoutput>
    <cfif rc.qry_clipping.count gt 0>

      <!---    generate pagination     --->
      <cf_pagination_with_orm
        intNumberOfTotalItems="#rc.qry_clipping.count#"
        intPagesToLinkTo="5"
        intItemsPerPage="#application.recordsPerPage#">

        <!---    display the records for this current page     --->
        <cfloop index="Clipping" array="#rc.qry_clipping.data#">
            <p>
            <b><a href="#buildURL(action = 'clipping.form', queryString = 'clipping_id=' & Clipping.getClipping_Id())#">#Clipping.getClipping_titulo()#</a></b>
              | <a href="javascript: ajaxClippingForm('#buildURL('clipping.ajaxForm')#',#Clipping.getClipping_Id()#);">Edit (Ajax)</a>
              | <a href="javascript: ajaxViewSummary('#buildURL('clipping.summary')#',#Clipping.getClipping_Id()#);">View Summary (Ajax)</a>
              |
            <br/>
            <font class="text-muted small">#dateFormat(Clipping.getCreated(), "mmmm d, yyyy")# at #timeFormat(Clipping.getCreated(), "hh:mm")#</font>
            <br/>

            <!---    shows a short preview of text (HTML tags removed)     --->
            #application.UDFs.abrevia_string(application.UDFs.stripHTML(Clipping.getClipping_texto()), 200)#
            <br/><br/>

            </p>
        </cfloop>

        </cf_pagination_with_orm>


    <cfelse><!---    nothing to display     --->

        <p>
            There are no articles currently.
        </p>
    </cfif>
</cfoutput>


