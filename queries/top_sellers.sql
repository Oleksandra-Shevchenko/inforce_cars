SELECT seller as "Seller Name", COUNT(*) AS Lots
FROM cars
JOIN car_sale_history ON cars.id = car_sale_history.car_id
WHERE seller IS NOT NULL
AND (:auctions IS NULL OR auction = ANY(:auctions))
AND (:year_start IS NULL OR :year_end IS NULL OR year BETWEEN :year_start AND :year_end)
-- AND (:vehicle_condition IS NULL OR vehicle_condition = :vehicle_condition)
AND (:vehicle_type_1 IS NULL OR vehicle_type = :vehicle_type_1)
AND (:vehicle_type_2 IS NULL OR vehicle_type = :vehicle_type_2)
AND (:make IS NULL OR make = :make)
AND (:model IS NULL OR model = :model)
AND car_sale_history.status = 'Sold'
AND (:sale_start IS NULL OR :sale_end IS NULL OR car_sale_history.date BETWEEN :sale_start AND :sale_end)
GROUP BY seller
ORDER BY Lots DESC
LIMIT 10;
