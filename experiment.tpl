# task 1: generate HTTP requests for the model
# collect Iter8's built-in latency and error related metrics
- task: gen-load-and-collect-metrics-http
  with:
    percentiles:
    - 95
    versionInfo:
    - url: CANDIDATE_SVC

# task 2: validate service level objectives 
# using the metrics collected in the above task
- task: assess-app-versions
  with:
    SLOs:
      # error rate must be 0
    - metric: built-in/http-error-rate
      upperLimit: 0
      # 95th percentile latency must be under 150 msec
    - metric: built-in/http-latency-p95
      upperLimit: 150

# task 3: if SLOs are satisfied, do something
- if: SLOs()
  run: |
    echo "Promote"
    curl -v -H 'Content-Type: application/json' \
        -d '{ "action": "promote", "pull_request": { "merged": "", "commits": "", "base": { "ref": "" }}}' \
        GATEWAY_SVC

# task 4: if SLOs are not satisfied, do something else
- if: not SLOs()
  run: |
    echo "Call cleanup"
    curl -v -H 'Content-Type: application/json' \
        -d '{ "action": "cleanup", "pull_request": { "merged": "", "commits": "", "base": { "ref": "" }}}' \
        GATEWAY_SVC
