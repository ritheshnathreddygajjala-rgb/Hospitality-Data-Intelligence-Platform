create or refresh streaming table bronze_hotel_bookings
(
    constraint booking_id_check
    expect(booking_id is not null)
)

comment 'Bronze layer: Raw Hotel Booking Data Ingestion'
as

select *,
_metadata.file_path as source_file,
current_timestamp() AS ingested_at
FROM STREAM read_files(
    '/Volumes/hotel_booking/default/booking_volume',
    format => 'CSV',
    header => 'true',
    inferColumnTypes => true
);
