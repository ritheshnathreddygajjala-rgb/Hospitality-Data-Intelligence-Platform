CREATE OR REFRESH MATERIALIZED VIEW gold_monthly_trends

COMMENT 'Gold layer: Monthly Hotel Booking Trends'

AS

SELECT
    DATE_TRUNC('MONTH', check_in_date) AS stay_month,

    COUNT(booking_id) AS total_bookings,

    SUM(
        CASE
            WHEN LOWER(booking_status) = 'cancelled'
            THEN 1 ELSE 0
        END
    ) AS cancelled_bookings,

    SUM(
        CASE
            WHEN LOWER(booking_status) <> 'cancelled'
            THEN nights ELSE 0
        END
    ) AS room_nights,

    SUM(
        CASE
            WHEN LOWER(booking_status) <> 'cancelled'
            THEN COALESCE(total_amount, 0) - COALESCE(discount_amount, 0)
            ELSE 0
        END
    ) AS net_revenue

FROM silver_hotel_bookings

GROUP BY DATE_TRUNC('MONTH', check_in_date);



CREATE OR REFRESH MATERIALIZED VIEW gold_hotel_performance

COMMENT 'Gold layer: Hotel Performance Analysis'

AS

SELECT
    region,
    INITCAP(LOWER(TRIM(city))) AS city,
    hotel_name,

    COUNT(booking_id) AS total_bookings,

    SUM(
        CASE
            WHEN LOWER(booking_status) = 'completed'
            THEN COALESCE(nights, 0)
            ELSE 0
        END
    ) AS room_nights,

    SUM(
        CASE
            WHEN LOWER(booking_status) = 'completed'
            THEN
                CASE
                    WHEN total_amount IS NOT NULL
                    THEN total_amount - COALESCE(discount_amount, 0)
                    ELSE 0
                END
            ELSE 0
        END
    ) AS net_revenue,

    ROUND(
        SUM(
            CASE
                WHEN LOWER(booking_status) = 'completed'
                THEN
                    CASE
                        WHEN total_amount IS NOT NULL
                        THEN total_amount - COALESCE(discount_amount, 0)
                        ELSE 0
                    END
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN LOWER(booking_status) = 'completed'
                    THEN COALESCE(nights, 0)
                    ELSE 0
                END
            ), 0
        ),
        2
    ) AS average_daily_rate

FROM silver_hotel_bookings

GROUP BY
    region,
    INITCAP(LOWER(TRIM(city))),
    hotel_name;

CREATE OR REFRESH MATERIALIZED VIEW gold_room_type_performance

COMMENT 'Gold layer: Room Type Performance Analysis'

AS

SELECT
    room_type,

    COUNT(booking_id) AS total_bookings,

    SUM(
        CASE
            WHEN LOWER(booking_status) = 'completed'
            THEN COALESCE(nights, 0)
            ELSE 0
        END
    ) AS room_nights,

    SUM(
        CASE
            WHEN LOWER(booking_status) = 'completed'
            THEN COALESCE(total_amount, 0)
                 - COALESCE(discount_amount, 0)
            ELSE 0
        END
    ) AS net_revenue,

    ROUND(
        AVG(guest_rating),
        2
    ) AS average_guest_rating

FROM silver_hotel_bookings

GROUP BY room_type;


CREATE OR REFRESH MATERIALIZED VIEW gold_channel_analysis
COMMENT 'Gold layer: Booking Channel Analysis'
AS

WITH channel_metrics AS (
    SELECT
        COALESCE(NULLIF(TRIM(booking_channel), ''), 'Unknown') AS booking_channel,

        COUNT(booking_id) AS total_bookings,

        SUM(
            CASE
                WHEN LOWER(TRIM(booking_status)) = 'cancelled'
                THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings,

        SUM(
            CASE
                WHEN LOWER(TRIM(booking_status)) = 'completed'
                     AND total_amount IS NOT NULL
                THEN total_amount - COALESCE(discount_amount, 0)
                ELSE 0
            END
        ) AS net_revenue

    FROM silver_hotel_bookings

    GROUP BY
        COALESCE(NULLIF(TRIM(booking_channel), ''), 'Unknown')
)

SELECT
    booking_channel,
    total_bookings,
    cancelled_bookings,

    ROUND(
        cancelled_bookings * 100.0 / NULLIF(total_bookings, 0),
        2
    ) AS cancellation_rate,

    net_revenue

FROM channel_metrics;

CREATE OR REFRESH MATERIALIZED VIEW gold_data_quality_summary
COMMENT 'Gold layer: Data Quality Summary'
AS

WITH bronze_counts AS (
    SELECT
        COUNT(*) AS bronze_rows
    FROM bronze_hotel_bookings
),

silver_counts AS (
    SELECT
        COUNT(*) AS silver_rows
    FROM silver_hotel_bookings
),

duplicate_counts AS (
    SELECT
        COUNT(*) AS duplicate_rows
    FROM (
        SELECT booking_id
        FROM bronze_hotel_bookings
        WHERE booking_id IS NOT NULL
        GROUP BY booking_id
        HAVING COUNT(*) > 1
    ) d
),

quality_counts AS (
    SELECT
        SUM(
            CASE
                WHEN booking_date IS NULL
                  OR check_in_date IS NULL
                  OR check_out_date IS NULL
                  OR check_out_date <= check_in_date
                THEN 1 ELSE 0
            END
        ) AS bad_date_rows,

        SUM(
            CASE
                WHEN room_rate IS NULL OR room_rate <= 0
                THEN 1 ELSE 0
            END
        ) AS bad_rate_rows,

        SUM(
            CASE
                WHEN guest_id IS NULL
                  OR hotel_name IS NULL OR TRIM(hotel_name) = ''
                  OR city IS NULL OR TRIM(city) = ''
                  OR booking_channel IS NULL OR TRIM(booking_channel) = ''
                THEN 1 ELSE 0
            END
        ) AS blank_value_rows

    FROM bronze_hotel_bookings
)

SELECT
    b.bronze_rows,
    s.silver_rows,
    d.duplicate_rows,
    q.bad_date_rows,
    q.bad_rate_rows,
    q.blank_value_rows

FROM bronze_counts b
CROSS JOIN silver_counts s
CROSS JOIN duplicate_counts d
CROSS JOIN quality_counts q;


CREATE OR REFRESH MATERIALIZED VIEW gold_reconciliation_check
COMMENT 'Gold layer: Bronze and Silver record reconciliation check'
AS

SELECT
    COUNT(*) AS bronze_rows,

    COUNT(DISTINCT booking_id) AS unique_booking_ids,

    COUNT(*) - COUNT(DISTINCT booking_id)
        AS duplicate_or_null_id_rows,

    SUM(
        CASE
            WHEN booking_id IS NULL THEN 1
            ELSE 0
        END
    ) AS null_booking_id_rows

FROM bronze_hotel_bookings;


CREATE OR REFRESH MATERIALIZED VIEW gold_reconciliation_summary
COMMENT 'Gold layer: Bronze to Silver record reconciliation'
AS

WITH bronze_stats AS (
    SELECT
        COUNT(*) AS bronze_rows,
        COUNT(DISTINCT booking_id) AS unique_booking_ids,
        SUM(
            CASE WHEN booking_id IS NULL THEN 1 ELSE 0 END
        ) AS null_booking_id_rows
    FROM bronze_hotel_bookings
),

silver_stats AS (
    SELECT
        COUNT(*) AS clean_rows
    FROM silver_hotel_bookings
)

SELECT
    b.bronze_rows,
    s.clean_rows,

    b.bronze_rows - b.unique_booking_ids
        AS duplicate_rows_removed,

    b.unique_booking_ids - s.clean_rows
        AS rejected_rows,

    b.bronze_rows - (
        s.clean_rows
        + (b.bronze_rows - b.unique_booking_ids)
        + (b.unique_booking_ids - s.clean_rows)
    ) AS reconciliation_difference,

    CASE
        WHEN b.bronze_rows =
            s.clean_rows
            + (b.bronze_rows - b.unique_booking_ids)
            + (b.unique_booking_ids - s.clean_rows)
        THEN 'Balanced'
        ELSE 'Not Balanced'
    END AS reconciliation_status

FROM bronze_stats b
CROSS JOIN silver_stats s;
