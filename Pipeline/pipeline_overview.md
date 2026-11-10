# Data Pipeline Overview

## Project: Hospitality Data Intelligence

### 1. Overview
This project implements an end-to-end Hotel Booking Data Engineering pipeline using Databricks and SQL. It follows the Medallion Architecture to ingest, clean, transform, and analyze hotel booking data.

### 2. Pipeline Architecture

The pipeline follows three layers:

**Bronze Layer – Raw Data Ingestion**
- Ingests hotel booking data from CSV files.
- Stores the original source records.
- Maintains raw data for further processing.

**Silver Layer – Data Cleaning and Transformation**
- Handles missing and null values.
- Removes duplicate booking records.
- Standardizes text values.
- Validates booking dates and numerical fields.
- Prepares clean data for analysis.

**Gold Layer – Business-Level Aggregation**
- Creates business-ready analytical tables.
- Calculates booking and cancellation metrics.
- Analyzes hotel, room type, and booking channel performance.
- Generates monthly booking and revenue trends.
- Provides data quality and reconciliation summaries.

### 3. Technologies Used
- Databricks
- SQL
- Delta Lake
- Lakeflow Declarative Pipelines
- Databricks Workflows
- Databricks AI/BI Dashboards

### 4. Workflow Automation
- Configured a Databricks Job to execute the data pipeline.
- Set up a scheduled workflow for automated execution.
- Supports pipeline updates when new source data is available.

### 5. Business Insights
The Gold layer supports analysis of:
- Monthly booking trends
- Hotel performance by region and city
- Room type performance
- Booking channel analysis
- Cancellation rates
- Data quality and reconciliation

### 6. Final Output
The processed Gold tables are used to build an interactive Hotel Booking Dashboard for business reporting and decision-making.

### 7. Project Objective
To build a scalable and structured data engineering solution that transforms raw hotel booking data into reliable, analytics-ready information using Databricks and Medallion Architecture.
