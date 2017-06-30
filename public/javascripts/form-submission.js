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
      var data = {
        location: {
          address_one: $("#address_one").val(),
          address_two: $("#address_two").val(),
          city: $('#city').val(),
          state: $('#state').val(),
          zip: $('#zip').val()
        }
      }

      $('#location-form-errors').html('');
      $.post('/api/locations', data, onSuccessfulGeocode);
    };

    var onSuccessfulGeocode = function(data) {
      data = JSON.parse(data);
      var newRow = '<tr><td>' + data['address'] + '</td><td>' + data.coords + '</td></tr>';

      $('#locations-table').append(newRow);

      $("#address_one").val('');
      $("#city").val(''); 
      $("#state").val('');
      $("#zip").val('');
    };

    var invalidFormSubmission = function(errors) {
      $('#location-form-errors').html('');

      var formattedErrors = '';
      errors.forEach(function(error) {
        formattedErrors += '<li>' + error + '</li>'
      });

      $('#location-form-errors').html(
        '<p>Please address the following errors:</p><ul>' + formattedErrors + '</ul></p>'
      )
    };

    return {
      formValidation: formValidation,
      invalidFormSubmission: invalidFormSubmission,
      validFormSubmission: validFormSubmission
    }
  };
// })();