require 'cgi'
require 'json'
require 'oauth2'

module SalesForce
  class Request
    class << self
      def get_jobs
        query = "SELECT Id,
                        Name,
                        CreatedDate,
                        Functional_Area__c,
                        Location__c,
                        Open_Date__c,
                        Job_Description__c
                 FROM Position__c
                 ORDER BY Open_Date__c DESC
                 LIMIT 10"

        response = JSON.parse($sales_force.get("#{$instance_url}query/?q="+query))
      end

      def get_job_details id
        query = "SELECT Id,
                        Name,
                        Functional_Area__c,
                        Location__c,
                        Job_Description__c
                 FROM Position__c
                 WHERE Id = '#{id}'"
        
        response = JSON.parse($sales_force.get("#{$instance_url}query/?q="+query))
      end

      def get_candidate_id
        query = "SELECT Id
                 FROM Candidate__c
                 WHERE First_Name__c = 'Darrell' AND 
                       Last_Name__c = 'Green'"
        #check if the candidate is already created
        candidate = JSON.parse($sales_force.get("#{$instance_url}query/?q="+query))
        response = candidate["records"][0]["Id"]
      end

      def create_applicant applicant
=begin
        params_candidate = "{
                              \"Last_Name__c\":\"#{applicant["Last_Name__c"]}\",
                              \"First_Name__c\":\"#{applicant["First_Name__c"]}\",
                              \"Email__c\":\"#{applicant["Email__c"]}\"
                            }"

        if candidate["totalSize"] == 1
          Token::get_token.post("#{INSTANCE_URL}sobjects/Candidate__c/"+
                                "#{candidate["records"][0]["Id"]}?_HttpMethod=PATCH", 
                     params_candidate, 
                                 {'Content-type' => 'application/json'})
          candidate = {"id" => candidate["records"][0]["Id"]}
        else
          candidate = JSON.parse(Token::get_token.post("#{INSTANCE_URL}sobjects/Candidate__c/", 
                                            params_candidate, 
                                            {'Content-type' => 'application/json'}))
        end
=end

        params_job = "{
                        \"Position__c\":\"#{applicant["Position__c"]}\",
                        \"Candidate__c\":\"#{applicant["Candidate__c"]}\",
                        \"Source_Picker__c\":\"Facebook\"
                      }"

        response = $sales_force.post("#{$instance_url}sobjects/Job_Application__c/", 
                              params_job, 
                              {'Content-type' => 'application/json'})
      end
    end
  end
end
