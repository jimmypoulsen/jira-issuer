require 'dotenv/load'
require 'json'
require 'faraday'

# Following variables are set in the workflow's environment variables
username = ENV['JIRA_USERNAME']
api_token = ENV['JIRA_API_TOKEN']
issue_title = ENV['ISSUE_TITLE']
issue_body = ENV['ISSUE_BODY']
issue_labels = JSON.parse(ENV['ISSUE_LABELS'])
issue_url = ENV['ISSUE_URL']

p "issue_labels: #{issue_labels}"
p "issuetype_id: #{issuetype_id}"

issuetypes = {
  bug: "10400",
  epic: "10401",
  feature: "10398",
  task: "10399",
}

# assign issuetype where issue_label's name string matches issuetype's key
issuetype_key = issuetypes.keys.find do |key|
  issue_labels.map do |label|
    label['name'].gsub('type: ', '')
  end.include?(key.to_s)
end

issuetype_id = issuetypes[issuetype_key || nil]

# conn = Faraday.new(
#   url: 'https://lexly.atlassian.net/',
#   headers: { 'Content-Type' => 'application/json' },
#   request: { timeout: 120 }
# ) do |faraday|
#   faraday.request :authorization, :basic, username, api_token
# end

# options = {
#   username: username,
#   password: api_token,
#   site: 'https://lexly.atlassian.net/',
#   context_path: '',
#   auth_type: :basic,
#   read_timeout: 120,
# }

# # Create issue
# atrs = {
#   "fields": {
#     "project": {
#       "key": "CORE"
#     },
#     "issuetype": {
#       "id": "10400"
#     },
#     "summary": "This is a test issue xD",
#     "description": {
#       "content": [
#         {
#           "content": [
#             {
#               "text": "This is a test issue",
#               "type": "text"
#             }
#           ],
#           "type": "paragraph"
#         }
#       ],
#       "type": "doc",
#       "version": 1
#     }
#   }
# }

# response = conn.post do |req|
#   req.url '/rest/api/3/issue'
#   req.body = atrs.to_json
# end

# p response
