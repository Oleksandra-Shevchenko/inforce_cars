WITH us_states AS (
    SELECT unnest(ARRAY[
        'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
        'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
        'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
        'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
        'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
        ]) AS code
),
     locations_with_state AS (
         SELECT
             cars.*,
             CASE
                 WHEN location ~ E'\\([A-Z]{2}\\)' THEN REGEXP_REPLACE(location, E'.*\\(([A-Z]{2})\\).*', E'\\1')
                 WHEN location ~ E'^[A-Z]{2}\\s*-' THEN LEFT(location, 2)
                 ELSE NULL
                 END AS state_code
         FROM cars
     )

SELECT
    vehicle,
    vin,
    COALESCE(owners, 0)                          AS owners,
    COALESCE(accident_count, 0)                  AS accident,
    CONCAT(mileage, ' MI')                       AS odometer,
    CONCAT(engine, ' L')                         AS engine,
    COALESCE(
            CASE
                WHEN has_keys THEN 'Yes'
                ELSE 'No'
                END, '-')                        AS keys,
    auction                                      AS source,
    lot,
    COALESCE(seller, '-')                        AS seller,
    location,
    COALESCE(date::text, '-')                    AS auction_date,
    current_bid

FROM locations_with_state l
         JOIN us_states s ON l.state_code = s.code
         JOIN condition_assessments ca ON l.id = ca.car_id

WHERE recommendation_status='RECOMMENDED'
  AND date >= CURRENT_DATE
  AND seller IS NOT NULL
  AND (:mileage_start IS NULL OR :mileage_end IS NULL OR mileage BETWEEN :mileage_start AND :mileage_end)
  AND (:owners_start IS NULL OR :owners_end IS NULL OR owners BETWEEN :owners_start AND :owners_end)
  AND (:accident_start IS NULL OR :accident_end IS NULL OR accident_count BETWEEN :accident_start AND :accident_end)
  AND (:year_start IS NULL OR :year_end IS NULL OR year BETWEEN :year_start AND :year_end)
  AND (:vehicle_condition IS NULL OR ca.issue_description = ANY(:vehicle_condition))
  AND (:vehicle_types IS NULL OR vehicle_type = ANY(:vehicle_types))
  AND (:make IS NULL OR make = :make)
  AND (:model IS NULL OR model = :model)
  AND (:predicted_roi_start IS NULL OR :predicted_roi_end IS NULL OR predicted_roi BETWEEN :predicted_roi_start AND :predicted_roi_end)
  AND (:predicted_profit_margin_start IS NULL OR :predicted_profit_margin_end IS NULL OR predicted_profit_margin BETWEEN :predicted_profit_margin_start AND :predicted_profit_margin_end)
  AND (:engine_type IS NULL OR engine = ANY(:engine_type))
  AND (:transmission IS NULL OR transmision = ANY(:transmission))
  AND (:drive_train IS NULL OR drive_type = ANY(:drive_train))
  AND (:cylinder IS NULL OR engine_cylinder = ANY(:cylinder))
  AND (:auction_names IS NULL OR auction_name = ANY(:auction_names))
  AND (:body_style IS NULL OR body_style = ANY(:body_style))
LIMIT 50;
