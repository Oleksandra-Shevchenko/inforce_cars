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
