require 'faraday'

# Following variables are set in the workflow's environment variables
username = $JIRA_USERNAME
api_token = $JIRA_API_TOKEN

p "username: #{username}"
p "api_token: #{api_token}"

conn = Faraday.new(
  url: 'https://lexly.atlassian.net/',
  headers: { 'Content-Type' => 'application/json' },
  request: { timeout: 120 }
) do |faraday|
  faraday.request :authorization, :basic, username, api_token
end

options = {
  username: username,
  password: api_token,
  site: 'https://lexly.atlassian.net/',
  context_path: '',
  auth_type: :basic,
  read_timeout: 120,
}

issuetypes = {
  bug: "10400",
  epic: "10401",
  feature: "10398",
  task: "10399",
}

# Create issue
atrs = {
  "fields": {
    "project": {
      "key": "CORE"
    },
    "issuetype": {
      "id": "10400"
    },
    "summary": "This is a test issue xD",
    "description": {
      "content": [
        {
          "content": [
            {
              "text": "This is a test issue",
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
