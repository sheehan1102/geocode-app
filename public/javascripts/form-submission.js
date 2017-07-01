// (function(){
  var FormSubmission = function() {

    var formValidation = function() {
      errors = []
      if ($("#address_one").val() === '') { errors.push('Address cannot be blank') };
      if ($("#city").val() === '') { errors.push('City cannot be blank') };
      if ($("#state").val() === '') { errors.push('State cannot be blank') };
      if ($("#zip").val() === '') { errors.push('Postal code cannot be blank') };
      return errors;
    };

    var validFormSubmission = function() {
      $('#location-form-errors').slideUp();

      var data = {
        location: {
          address_one: $("#address_one").val(),
          address_two: $("#address_two").val(),
          city: $('#city').val(),
          state: $('#state').val(),
          zip: $('#zip').val()
        }
      }

      $('#errors-wrapper').slideUp(100);
      $.post('/api/locations', data, onSuccessfulGeocode);
    };

    var onSuccessfulGeocode = function(data) {
      data = JSON.parse(data);
      appearNewAddress(data);

      $("#address_one").val('');
      $("#address_two").val('');
      $("#city").val(''); 
      $("#state").val('');
      $("#zip").val('');
    };

    var appearNewAddress = function(data) {
      var newRow = '<div style="display: none;" id="location-' + data.id + '" class="locations-row"> \
        <p>' + data.address + ':</p> \
        <ul class="locations-list"> \
          <li>Latitude: <b>' + data.lat + '</b>, Longitude: <b>' + data.long + '</b></li> \
        </ul> \
      </div>'

      $('#locations-row-wrapper').prepend(newRow);

      var id = '#location-' + data.id;

      $(id).slideDown(750);
    };

    var invalidFormSubmission = function(errors) {
      $('#location-form-errors').html('');

      var formattedErrors = '';
      errors.forEach(function(error) {
        formattedErrors += '<li>' + error + '</li>'
      });

      var errorHtml = '<p>Please address the following errors:</p><ul>' + formattedErrors + '</ul>';
      $('#location-form-errors').html(errorHtml);
      $('#location-form-errors').slideDown();
    };

    var errorFlashMessage = function(errorHtml) {
      $('#flash-box').html(errorHtml);
      $('#flash-box').fadeIn();
    };

    return {
      formValidation: formValidation,
      invalidFormSubmission: invalidFormSubmission,
      validFormSubmission: validFormSubmission
    }
  };
// })();