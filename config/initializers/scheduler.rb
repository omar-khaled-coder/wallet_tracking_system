require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '0 * * * *' do
  FetchProductsJob.perform_later
end
