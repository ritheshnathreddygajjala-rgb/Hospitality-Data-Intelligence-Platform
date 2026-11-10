# Databricks Workflow and Automation

## 1. Overview
The Hotel Booking Data Engineering project uses Databricks Workflows to automate the execution of the data pipeline.

## 2. Workflow Configuration
- **Platform:** Databricks Workflows
- **Job Name:** Hotel SDP
- **Task Type:** Pipeline
- **Pipeline:** Hotel Booking Data Pipeline
- **Execution:** Scheduled and manual runs

## 3. Execution Process
1. The Databricks Job triggers the configured pipeline.
2. The Bronze layer ingests the source data.
3. The Silver layer cleans and transforms the data.
4. The Gold layer generates business-level analytical tables.
5. The pipeline completes and updates the output tables.

## 4. Automation Benefits
- Reduces manual execution.
- Maintains a repeatable data processing workflow.
- Supports scheduled pipeline execution.
- Makes pipeline monitoring easier through run history.

## 5. Monitoring
Pipeline execution can be monitored using:
- Job run history
- Execution status
- Start and completion times
- Pipeline task logs

## 6. Conclusion
Databricks Workflows helps automate and manage the Hotel Booking Data Engineering pipeline, making the data processing process repeatable and easier to monitor.
