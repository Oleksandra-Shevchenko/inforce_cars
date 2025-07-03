---for 1 year---
SELECT
    DATE_TRUNC('month', sale.date) AS month,
    ROUND(AVG(sale.final_bid), 2) AS avg_price
FROM cars
         JOIN car_sale_history sale ON cars.id = sale.car_id
WHERE sale.status= 'Sold'
  AND sale.date >= CURRENT_DATE - INTERVAL '1 year'
  AND seller IS NOT NULL
  AND (:auctions IS NULL OR auction = ANY(:auctions))
  AND (:year_start IS NULL OR :year_end IS NULL OR year BETWEEN :year_start AND :year_end)
-- AND (:vehicle_condition IS NULL OR l.vehicle_condition = :vehicle_condition)
  AND (:vehicle_type_1 IS NULL OR vehicle_type = :vehicle_type_1)
  AND (:vehicle_type_2 IS NULL OR vehicle_type = :vehicle_type_2)
  AND (:make IS NULL OR make = :make)
  AND (:model IS NULL OR model = :model)
  AND (:sale_start IS NULL OR :sale_end IS NULL OR sale.date BETWEEN :sale_start AND :sale_end)
GROUP BY month
ORDER BY month;

----for 1 week--
SELECT
    DATE_TRUNC('week',sale.date) AS sale_day,
    ROUND(AVG(sale.final_bid), 2) AS avg_price
FROM cars
         JOIN car_sale_history sale ON cars.id = sale.car_id
WHERE sale.status = 'Sold'
  AND sale.date >= CURRENT_DATE - INTERVAL '7 days'
  AND sale.date < CURRENT_DATE
  AND seller IS NOT NULL
  AND (:auctions IS NULL OR auction = ANY(:auctions))
  AND (:year_start IS NULL OR :year_end IS NULL OR year BETWEEN :year_start AND :year_end)
-- AND (:vehicle_condition IS NULL OR l.vehicle_condition = :vehicle_condition)
  AND (:vehicle_type_1 IS NULL OR vehicle_type = :vehicle_type_1)
  AND (:vehicle_type_2 IS NULL OR vehicle_type = :vehicle_type_2)
  AND (:make IS NULL OR make = :make)
  AND (:model IS NULL OR model = :model)
  AND (:sale_start IS NULL OR :sale_end IS NULL OR sale.date BETWEEN :sale_start AND :sale_end)
GROUP BY sale_day
ORDER BY sale_day;


---for 6-8 weeks--
SELECT
    DATE_TRUNC('week', sale.date) AS week_start,
    ROUND(AVG(sale.final_bid), 2) AS avg_price
FROM cars
         JOIN car_sale_history sale ON cars.id = sale.car_id
WHERE sale.status = 'Sold'
  AND sale.date >= CURRENT_DATE - INTERVAL '8 weeks'
  AND sale.date < CURRENT_DATE
  AND seller IS NOT NULL
  AND (:auctions IS NULL OR auction = ANY(:auctions))
  AND (:year_start IS NULL OR :year_end IS NULL OR year BETWEEN :year_start AND :year_end)
-- AND (:vehicle_condition IS NULL OR l.vehicle_condition = :vehicle_condition)
  AND (:vehicle_type_1 IS NULL OR vehicle_type = :vehicle_type_1)
  AND (:vehicle_type_2 IS NULL OR vehicle_type = :vehicle_type_2)
  AND (:make IS NULL OR make = :make)
  AND (:model IS NULL OR model = :model)
  AND (:sale_start IS NULL OR :sale_end IS NULL OR sale.date BETWEEN :sale_start AND :sale_end)
GROUP BY week_start
ORDER BY week_start;



-- Query with updated filters and flexible time range(months)--
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
         SELECT cars.*,
                CASE
                    WHEN location ~ E'\\([A-Z]{2}\\)' THEN REGEXP_REPLACE(location, E'.*\\(([A-Z]{2})\\).*', E'\\1')
                    WHEN location ~ E'^[A-Z]{2}\\s*-' THEN LEFT(location, 2)
                    ELSE NULL
                    END AS state_code,
                CASE
                    WHEN location ~ E'\\([A-Z]{2}\\)' THEN TRIM(REGEXP_REPLACE(location, E'\\s*\\([A-Z]{2}\\)', ''))
                    WHEN location ~ E'^[A-Z]{2}\\s*-'
                        THEN TRIM(SPLIT_PART(location, '-', 2))
                    ELSE NULL
                    END AS city
         FROM cars
     )
SELECT
    DATE_TRUNC('month', l.date) AS month,
    ROUND(AVG(sh.final_bid), 2) AS avg_price

FROM locations_with_state l
         JOIN us_states s ON l.state_code = s.code
         JOIN car_sale_history sh ON l.id = sh.car_id
         JOIN condition_assessments ca ON l.id = ca.car_id

WHERE seller IS NOT NULL
  AND sh.status= 'Sold'
  AND sh.final_bid IS NOT NULL
  AND (:state_codes IS NULL OR state_code = ANY(:state_codes))
  AND (:cities IS NULL OR city = ANY(:cities))
  AND (:auctions IS NULL OR auction = ANY(:auctions))
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
  AND (:sale_start IS NULL OR :sale_end IS NULL OR sh.date BETWEEN :sale_start AND :sale_end)
GROUP BY month
ORDER BY month;
