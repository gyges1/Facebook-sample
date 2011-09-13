module ApplicationHelper

  def nice_date date
    response = ''
    months = {
              "01" => "January", 
              "02" => "February", 
              "03" => "March", 
              "04" => "April",
              "05" => "May", 
              "06" => "June", 
              "07" => "July", 
              "08" => "August",
              "09" => "September", 
              "10" => "October", 
              "11" => "November",
              "12" => "December"
             }

    response = date.split('T')[0].split('-')
    response = "#{months[response[1]]} #{response[2]}, #{response[0]}"
  end

end
