// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//store the name and email of the current user
var user_data = new Object();
var job_id = null;

$(document).ready(function(){
  //add the loader to the stage
  $('#ajax1').before('<span id="loader"></span>');
  $('#loader').hide(0);

  FB.init({
           appId: '163862953653734', 
           status: true, 
           cookie: true,
           xfbml: true
          });

  FB.getLoginStatus(function(response) {
    if (response.session) {
      console.info(1);
    }else{ 
      console.info(2); 
    }
  });

  FB.Canvas.setSize();

  handlers.reload();
});

(function() {
  var e = document.createElement('script'); e.async = true;
  e.src = document.location.protocol +
    '//connect.facebook.net/en_US/all.js';
  $('#fb-root').append(e);
}());

function get_user_info(uid){
  user_data.first_name = '';
  var response = new Object();
  var query = FB.Data.query('select first_name, last_name, email from user where uid={0}',
                             uid);
  query.wait(function(rows) {
    user_data.first_name = rows[0].first_name;
    user_data.last_name = rows[0].last_name;
    user_data.email = rows[0].email;
    if (job_id != null) {
      setTimeout(function(){
                   job_detail_page(job_id);
                 }, 2000);
    }
  });
}

var handlers = {
  reload: function(){
    $('.job_button').each(function(x, e){
      $(e).click(function(event){
        var btn = e;
        job_id = $(btn).attr('name');

        if (user_data.first_name == undefined) {
          FB.login(function(response){
                     if (response.session) {
                       show_loader();
                       get_user_info(response.session.uid);
                     }}, 
                  {perms:'email'});
        } else {
          show_loader();
          setTimeout(function(){
                   job_detail_page(job_id);
                 }, 2000);
        }
        event.preventDefault();
      });
    });

    $('.back_home').each(function(x, e){
      $(e).click(function(){
        show_loader();
        setTimeout(job_list_page, 2000);
      }); 
    });

    $('#btn_form').click(function(){
      show_loader();
      setTimeout(form_page, 2000);
      $(this).unbind('click');
    });

    $('#btn_apply').click(function(e){
      show_loader();
      e.preventDefault();
      setTimeout(thank_you_page, 2000);
    });
  }
};

function job_detail_page(id) {
  $.ajax({
    type: "GET",
    url: "/pages/job_detail?id="+id,
    success: function(body){
      $('#ajax1').hide(0, function(){
        $('#ajax1').html(body);
        $('#ajax1').show(0, hide_loader);
        handlers.reload();
        FB.Canvas.setSize();
      });      
    }
  });
}

function job_list_page() {
  $.ajax({
    type: "GET",
    url: "?e=1",
    success: function(body){
      $('#ajax1').hide(0, function(){
        $('#ajax1').html(body);
        $('#ajax1').show(0, hide_loader);
        handlers.reload();
        FB.Canvas.setSize();
      });
    }
  });
}

function form_page() {
  $.ajax({
    type: "GET",
    url: "/pages/apply_form?first_name="+user_data.first_name+
                          "&last_name="+user_data.last_name+
                          "&email="+user_data.email+
                          "&job="+job_id,
    success: function(body){
      $('#ajax1').hide(0, function(){
        $('#ajax1').html(body);
        $('#ajax1').show(0, hide_loader);
        handlers.reload();
        FB.Canvas.setSize();
      });
    }
  });
}

function thank_you_page() {
  $.ajax({
    type: "GET",
    url: "/pages/thank_you?Position__c="+$('#Position__c').val()+
                          "&First_Name__c="+$('#First_Name__c').val()+
                          "&Last_Name__c="+$('#Last_Name__c').val()+
                          "&Name__c="+$('#Name__c').val()+
                          "&Email__c="+$('#Email__c').val()+
                          "&Candidate__c="+$('#Candidate__c').val(),
    success: function(body){
      $('#ajax1').hide(0, function(){
        $('#ajax1').html(body);
        $('#ajax1').show(0, hide_loader);
        handlers.reload();
        FB.Canvas.setSize();
      });
    }
  });
}

function show_loader(){
  $('#loader').fadeIn(500);
}

function hide_loader(){
  $('#loader').fadeOut(500);
}

