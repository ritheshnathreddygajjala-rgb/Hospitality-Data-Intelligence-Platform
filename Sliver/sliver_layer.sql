CREATE OR REFRESH MATERIALIZED VIEW silver_hotel_bookings

COMMENT 'Silver layer: Cleaned and transformed hotel booking data'

AS

WITH cleaned_data AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY booking_id
            ORDER BY ingested_at DESC
        ) AS rn

    FROM bronze_hotel_bookings

    WHERE booking_id IS NOT NULL
)

SELECT
    booking_id,
    guest_id,
    CAST(booking_date AS DATE) AS booking_date,
    CAST(check_in_date AS DATE) AS check_in_date,
    CAST(check_out_date AS DATE) AS check_out_date,
    nights,
    TRIM(hotel_name) AS hotel_name,
    TRIM(city) AS city,
    TRIM(region) AS region,
    TRIM(room_type) AS room_type,
    TRIM(booking_channel) AS booking_channel,
    guests,
    room_rate,
    total_amount,
    discount_amount,
    meal_plan,
    payment_method,
    payment_status,
    booking_status,
    guest_rating,
    source_file,
    ingested_at

FROM cleaned_data

WHERE rn = 1;
