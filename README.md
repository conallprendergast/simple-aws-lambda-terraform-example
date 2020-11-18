# Introduction

This repository demonstrates a simple AWS lambda deployment using terraform. The lambda code is developed in Python.

It creates the following resources:
- A lambda function called _http-monitor_, that prints the return code of a HTTP GET to google.com
- And eventbridge scheduler that kicks off the above lambda every minute
- Supporting IAM roles, schedules etc

# Requirements

You must be logged in to AWS via the AWS cli.

    aws configure

## Usage

    gradle zip
    terrafrom init
    terraform apply

