require 'sales_force'

class PagesController < ApplicationController
  before_filter :check_token, :except => [:error]

  def index
    begin
      @jobs = SalesForce::Request.get_jobs
    rescue Exception => e
      #if the request fail, we hardcode the job list
      puts e.to_s
      @jobs = {}
    end

    unless params['e'].nil?
      render :layout => false
    end
  end

  def job_detail
    begin
      @job_detail = SalesForce::Request.get_job_details params['id']
    rescue Exception => e
      #the same that index page
      @job_detail = {}
    end
    render :layout => false
  end

  def apply_form
    begin
      @candidate = SalesForce::Request.get_candidate_id
    rescue Exception => e
      @candidate = 0
    end
    @user_data = params
    render :layout => false
  end

  def thank_you
    begin
      SalesForce::Request.create_applicant params
    rescue Exception => e
      #if the request fail, it doesn't matter, we show the thank you page
    end
    render :layout => false
  end

  def error
  end

  #if you want, you can remove this action, just be sure to remove the view too.
  def refresh_token
    @refresh_token = params["refresh_token"]
  end

end
