module PagesHelper

  def make_title job
    response = ''
    response = '<b>' + job["Name"] + '</b>'
    unless job["Functional_Area__c"].nil?
      response += ", #{job["Functional_Area__c"]}"
    end

    unless job["Location__c"].nil?
      response += ", #{job["Location__c"]}"
    end
    return response
  end

end
