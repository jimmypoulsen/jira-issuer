require 'dotenv/load'
require 'json'
require 'faraday'

# Following variables are set in the workflow's environment variables
username = ENV['JIRA_USERNAME']
api_token = ENV['JIRA_API_TOKEN']
jira_site = ENV['JIRA_SITE']
jira_project_key = ENV['JIRA_PROJECT_KEY']
github_link_custom_field_id = ENV['JIRA_GITHUB_LINK_CUSTOM_FIELD_ID']
github_id_custom_field_id = ENV['JIRA_GITHUB_ID_CUSTOM_FIELD_ID']

issue_number = ENV['ISSUE_NUMBER']
issue_title = ENV['ISSUE_TITLE']
issue_body = ENV['ISSUE_BODY']
issue_labels = JSON.parse(ENV['ISSUE_LABELS'])
issue_url = ENV['ISSUE_URL']

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

issuetype_id = issuetypes[issuetype_key || :task]

conn = Faraday.new(
  url: jira_site,
  headers: { 'Content-Type' => 'application/json' },
  request: { timeout: 120 }
) do |faraday|
  faraday.request :authorization, :basic, username, api_token
end

options = {
  username: username,
  password: api_token,
  site: jira_site,
  context_path: '',
  auth_type: :basic,
  read_timeout: 120,
}

# Create issue
atrs = {
  "fields": {
    "project": {
      "key": jira_project_key
    },
    "issuetype": {
      "id": issuetype_id
    },
    "customfield_#{github_link_custom_field_id}": issue_url,
    "customfield_#{github_id_custom_field_id}": issue_number.to_i,
    "summary": issue_title,
    "description": {
      "content": [
        {
          "content": [
            {
              "text": issue_body,
              "type": "text"
            }
          ],
          "type": "paragraph"
        }
      ],
      "type": "doc",
      "version": 1
    }
  }
}

response = conn.post do |req|
  req.url '/rest/api/3/issue'
  req.body = atrs.to_json
end

p response
