# Introduction
This code is shit. I admit it. However, please acknowledge the fact that it was written in less than 45 minutes and it **works**.

# TO DO
- [ ] Fetch issuetypes from Jira instead of defining them in run.rb

# How to use
Here's an example workflow that uses this action. This example workflow runs when you open a new issue.

```yml
name: 'Create Jira issue'
on:
  issues:
    types: [opened]
permissions:
  contents: read
  statuses: read
jobs:
  build:
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout to action
        uses: actions/checkout@v2.4.0
        with:
          repository: 'jimmypoulsen/jira-relay'
          ref: 'v1.0.13'
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
      - name: Create Jira issue
        uses: jimmypoulsen/jira-relay@v1.0.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          JIRA_USERNAME: ${{ secrets.JIRA_USERNAME }}
          JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
          JIRA_SITE: ${{ secrets.JIRA_SITE }}
          JIRA_PROJECT_KEY: ${{ secrets.JIRA_PROJECT_KEY }}
          JIRA_GITHUB_LINK_CUSTOM_FIELD_ID: ${{ secrets.JIRA_GITHUB_LINK_CUSTOM_FIELD_ID }}
          JIRA_GITHUB_ID_CUSTOM_FIELD_ID: ${{ secrets.JIRA_GITHUB_ID_CUSTOM_FIELD_ID }}
          ISSUE_NUMBER: ${{ github.event.issue.number }}
          ISSUE_TITLE: ${{ github.event.issue.title }}
          ISSUE_BODY: ${{ github.event.issue.body }}
          ISSUE_URL: ${{ github.event.issue.html_url }}
          ISSUE_LABELS: ${{ toJSON(github.event.issue.labels) }}

```

# References
JIRA API: https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issues/#api-rest-api-3-issue-post

GitHub events: https://docs.github.com/en/webhooks-and-events/webhooks/webhook-events-and-payloads?actionType=opened#issues
