# Hospitality Data Intelligence

### End-to-End Hotel Booking Data Engineering Project using Databricks

## Project Overview

Hospitality Data Intelligence is an end-to-end data engineering project developed using Databricks and SQL. The project processes hotel booking data through the Medallion Architecture (Bronze, Silver, and Gold layers) to transform raw data into clean, structured, and analytics-ready information.

The final Gold-layer datasets support business analysis through an interactive Hotel Booking Dashboard.

## Technology Stack

- Databricks
- SQL
- Delta Lake
- Lakeflow Declarative Pipelines
- Databricks Workflows
- Databricks AI/BI Dashboards
- GitHub

## Architecture

This project follows the Medallion Architecture:

**Bronze → Silver → Gold → Dashboard**

![Hotel Booking Architecture](Pipeline/pipeline%20architecture%20diagram.png)

## Data Engineering Workflow

### 1. Bronze Layer – Data Ingestion
- Ingests raw hotel booking data from CSV files.
- Stores source records for further processing.
- Maintains the raw data layer.

### 2. Silver Layer – Data Cleaning
- Handles missing and null values.
- Removes duplicate booking records.
- Standardizes text fields.
- Performs data validation and transformations.
- Prepares clean data for analysis.

### 3. Gold Layer – Business Analysis
Creates analytical datasets to address the following business requirements:

| Analysis | Business Metrics |
|---|---|
| Monthly Trends | Bookings, cancellations, room nights, net revenue |
| Hotel Performance | Bookings, room nights, net revenue, ADR |
| Room Type Performance | Bookings, room nights, revenue, guest ratings |
| Channel Analysis | Bookings, cancellations, cancellation rate, revenue |
| Data Quality | Missing values, duplicates, invalid records |
| Reconciliation | Bronze-to-Silver record reconciliation |

## Dashboard

An interactive Hotel Booking Dashboard was developed using Databricks AI/BI Dashboards to visualize business performance and booking trends.

**Dashboard Report:** [View Hotel Booking Dashboard](Dashboard/Hotel_Booking_Dashboard.pdf.pdf)

## Pipeline Automation

- Configured Databricks Workflows to execute the pipeline.
- Set up scheduled execution.
- Supports repeatable data processing.
- Monitors pipeline execution through job run history.

## Project Structure

```text
Hospitality-Data-Intelligence/
│
├── Bronze/
│   └── bronze_ingestion.sql
│
├── Silver/
│   └── silver_cleaning.sql
│
├── Gold/
│   ├── gold_monthly_trends.sql
│   ├── gold_hotel_performance.sql
│   ├── gold_room_type_performance.sql
│   ├── gold_channel_analysis.sql
│   ├── gold_data_quality_summary.sql
│   └── gold_reconciliation_summary.sql
│
├── Pipeline/
│   ├── pipeline_overview.md
│   ├── workflow_details.md
│   └── hotel_booking_architecture.png
│
├── Dashboard/
│   └── Hotel_Booking_Dashboard.pdf
│
└── README.md
```

## Project Objectives

- Build an end-to-end data engineering pipeline.
- Implement Medallion Architecture using Databricks.
- Perform data cleaning and transformation using SQL.
- Develop business-ready Gold-layer datasets.
- Automate pipeline execution using Databricks Workflows.
- Generate meaningful business insights through dashboards.

## Conclusion

This project demonstrates the implementation of a structured data engineering workflow using Databricks, SQL, and Medallion Architecture. It transforms raw hotel booking records into reliable analytical datasets that support business reporting and decision-making.
