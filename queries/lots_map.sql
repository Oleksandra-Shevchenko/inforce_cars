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
    l.state_code,
    COUNT(*) AS lots
FROM locations_with_state l
         JOIN us_states s ON l.state_code = s.code
         JOIN car_sale_history ON l.id = car_sale_history.car_id
WHERE l.seller IS NOT NULL
  AND (:auctions IS NULL OR l.auction = ANY(:auctions))
  AND (:year_start IS NULL OR :year_end IS NULL OR l.year BETWEEN :year_start AND :year_end)
-- AND (:vehicle_condition IS NULL OR l.vehicle_condition = :vehicle_condition)
  AND (:vehicle_type_1 IS NULL OR l.vehicle_type = :vehicle_type_1)
  AND (:vehicle_type_2 IS NULL OR l.vehicle_type = :vehicle_type_2)
  AND (:make IS NULL OR l.make = :make)
  AND (:model IS NULL OR l.model = :model)
  AND car_sale_history.status = 'Sold'
  AND (:sale_start IS NULL OR :sale_end IS NULL OR car_sale_history.date BETWEEN :sale_start AND :sale_end)
GROUP BY l.state_code
ORDER BY lots DESC;