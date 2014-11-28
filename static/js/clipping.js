/**
 * janela Modal para Ocorrências
 */
function ajax_ocorrencia_lista(id){
  $.get( "/ajax_ocorrencia_lista/" + id, function( data ) {
    $( ".modal-body" ).html( data );
    $( ".modal-title" ).html( "Lista de Ocorrências" );
    $('#myModal').modal({show:true});
  });
}
/**
 * Faz a busca por modelos ou exemplares a medida que o usuario digita
 * carrega resultados dinamicamente
 */
function ajaxBusca(){
  if($("#q").val().length >=0){
    $.get( "/ajax_search", { q: $("#q").val() },function( data ) {
      $( "#div_body" ).html( data );
      // "oculta" menu lateral, mantendo a div
      $( "#div_menu_direito" ).html( " " );
    });
  }
}

// Jquery sticker para menu direito
$(document).ready(function(){
  $("#divMenu").sticky({topSpacing:60});
});

/**
 * cancel buttons that go back to referer
 *
 */
$(".go-back").click(function(){
  history.back();
});

/**
 * verifica a existência de campos para marca e modelo
 * e, se existirem, faz autocomplete
 */
if ($('#id_mod_marca').length > 0) {
  $(function() {
      $( "#id_mod_marca" ).autocomplete({
        source: "/ajax_search_field/mod_marca",
        minLength: 2,
        focus: function( event, ui ) {
          $( "#id_mod_marca" ).val( ui.item.label );
          return false;
        },
        select: function( event, ui ) {
          $( "#id_mod_marca" ).val( ui.item.label );
          return false;
        }
      })
      .data( "ui-autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li>" )
          .append( "<a><b>" + item.label + "</b></a>")
          .appendTo( ul );
      };
  });
}


// autocomplete de modelos
if ($('#id_mod_marca').length > 0) {
  $(function() {
      $( "#id_mod_modelo" ).autocomplete({
        source: "/ajax_search_field/mod_modelo",
        minLength: 2,
        focus: function( event, ui ) {
          $( "#id_mod_modelo" ).val( ui.item.label );
          return false;
        },
        select: function( event, ui ) {
          $( "#id_mod_modelo" ).val( ui.item.label );
          return false;
        }
      })
      .data( "ui-autocomplete" )._renderItem = function( ul, item ) {
        return $( "<li>" )
          .append( "<a><b>" + item.label + "</b></a>")
          .appendTo( ul );
      };
  });
}

/**
 * Aplica Style de switch on/off nos checkboxes de exemplares
 * http://www.bootstrap-switch.org/
 */
$(document).ready(function(){
  $.fn.bootstrapSwitch.defaults.onText = 'SIM';
  $.fn.bootstrapSwitch.defaults.offText = 'NÃO';
  $.fn.bootstrapSwitch.defaults.onColor = 'danger';
  $("[name='ex_status_emprestado']").bootstrapSwitch();
  $("[name='ex_status_baixado']").bootstrapSwitch();
});

/**
 *  Sweet Alert
 *  Gera confirms estilizados na exclusão de modelos
 *  e exemplares
 */
 $( "#btnExcluirExemplar, #btnExcluirModelo" ).click(function(){
  swal({
    title: "Tem certeza?",
    text: "Essa ação não poderá ser desfeita!",
    type: "warning",
    showCancelButton: true,
    cancelButtonText: "Cancelar" ,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Excluir!" },
  function(){
    document.getElementById("formExcluir").submit();
  });
});