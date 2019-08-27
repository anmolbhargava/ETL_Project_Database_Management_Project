

--SELECT COUNT (*) Statements

SELECT COUNT (*)  AS 'Total Number of Restaurants' FROM [Restropedia.Restaurant];
SELECT COUNT (*) AS 'Total Number of Customers' FROM [Restropedia.Customer];
SELECT COUNT (*) AS 'Total Number of Offers' FROM [Restropedia.Offers];
SELECT COUNT (*) AS 'Total Number of Cuisines' FROM [Restropedia.Cuisine]; 
SELECT COUNT (*) FROM [Restropedia.Provides];
SELECT COUNT (*) FROM [Restropedia.Sells];
SELECT COUNT (*) FROM [Restropedia.Reviews];
SELECT COUNT(*) FROM [vw.summary];



--Which is Best Rated Thai Restaurant around the University of Maryland ?

SELECT name AS 'Best Rated Thai Resturant', address AS 'Address', carParking AS 'Car Parking', 
              outdoorSeating AS 'Outdoor Seating', freeWifi AS 'Free Wifi', cuisineName AS 'Cuisine', avgRating AS 'Rating'
FROM [vw.summary] 
WHERE cuisineName = 'Thai' AND avgRating = (SELECT MAX(avgRating) FROM [vw.summary] 
							     WHERE cuisineName = 'Thai') ; 



--Which Indian Restaurant in College Park has the Best Value for money and also has Free Wifi ?

SELECT name AS 'Indian Resturant (Best Value for Money)', cuisineName AS 'Cuisine', freeWifi AS 'Free Wifi', 
	   avgValueForMoney AS 'Value For Money'
FROM [vw.summary] 
WHERE cuisineName = 'Indian' AND 
	  avgValueForMoney = (SELECT MAX(avgValueForMoney) FROM [vw.summary] WHERE cuisineName = 'Indian' AND freeWifi = 'Y') ; 



--Which restaurants near the University of Maryland are open 24/7 and also have the facility of outdoor seating ?

SELECT restaurantID, name, [address], outDoorSeating, openingHoursWeekdays, openingHoursWeekends
FROM [Restropedia.Restaurant]
WHERE openingHoursWeekdays = '24/7' AND openingHoursWeekends = '24/7'
	AND outDoorSeating = 'Y' ;



--Which Multi-cuisine Restaurants have either an option of door delivery or situated at a distance less than 5 miles 
--from the Robert H. Smith School of Business ?

SELECT res.name AS 'Multi Cuisine Restaurant', res.doorDelivery AS 'Door Delivery', res.distance AS 'Distance' 
FROM [Restropedia.Restaurant] res,
(SELECT s.restaurantID AS multiCusineRestaurants FROM [Restropedia.Sells] s 
GROUP BY s.restaurantID HAVING COUNT(s.restaurantID) > 1) mu
WHERE mu.multiCusineRestaurants = res.restaurantID
AND res.distance < 5 AND res.doorDelivery = 'Y';



--Which Restaurant in College Park provides the Best Service and also has the facility of car parking ?

SELECT DISTINCT name AS 'Resturant (Best Service)', avgService AS 'Service'
FROM [vw.summary] 
WHERE avgService = (SELECT MAX(avgService) FROM [vw.summary] WHERE carParking = 'Y')
	  AND carParking = 'Y'  ;



--Which Chinese Restaurant near the University of Maryland has the most number of customer reviews ?

SELECT res.name AS 'Restaurant Name', c.cuisineName AS 'Cuisine', MAX(a.numberOfReviews) AS 'Number Of Reviews' 
FROM  [Restropedia.Restaurant] res, 
(SELECT COUNT(rev.restaurantId) AS numberOfReviews, rev.restaurantId FROM [Restropedia.Reviews] rev 
GROUP BY rev.restaurantId) a ,[Restropedia.Cuisine] c, [Restropedia.sells] s 
WHERE s.restaurantId = a.restaurantId AND s.cuisineId = c.cuisineId
      AND a.restaurantId = res.restaurantId 
      AND c.cuisineName = 'CHINESE' 
GROUP BY res.name, c.cuisineName ;



--Which Mexican Restaurant in College Park has the Best ambience and is providing any offer ?

SELECT * 
FROM
(SELECT res.Name AS 'Restaurant Name', res.address AS 'Address', res.freeWifi AS 'Free Wifi', 
	   res.carParking AS 'Car Parking', uu.avgAmb AS 'Ambience', c.cuisineName AS 'Cuisine', 
	   o.description AS 'Description', p.validity AS 'Validity'
FROM
(SELECT tt.restaurantID, tt.avgAmb
FROM
(SELECT ee.restaurantID, ee.avgAmb, c.cuisineName
FROM 
(SELECT restaurantID, AVG(ambience) as avgAmb
FROM [Restropedia.Reviews]
GROUP BY restaurantID) ee, [Restropedia.Cuisine] c, [Restropedia.sells] s, [Restropedia.Offers] o, 
		 [Restropedia.Provides] p
WHERE ee.restaurantID = s.restaurantID AND s.cuisineId = c.cuisineId AND o.offerID = p.offerID AND c.cuisineName = 'Mexican' 
	  AND ee.restaurantID=p.restaurantID) tt

WHERE tt.avgAmb=
(SELECT MAX(pp.avgAmb)
FROM
(
SELECT ee.restaurantID, ee.avgAmb, c.cuisineName
FROM 
(SELECT restaurantID, AVG(ambience) as avgAmb
FROM [Restropedia.Reviews]
GROUP BY restaurantID) ee, [Restropedia.Cuisine] c, [Restropedia.sells] s, [Restropedia.Offers] o, 
		 [Restropedia.Provides] p
WHERE ee.restaurantID = s.restaurantID AND s.cuisineId = c.cuisineId AND o.offerID = p.offerID AND c.cuisineName = 'Mexican' 
	  AND ee.restaurantID=p.restaurantID
) pp)) uu, [Restropedia.Restaurant] res,[Restropedia.Cuisine] c, [Restropedia.sells] s, [Restropedia.Offers] o, 
		 [Restropedia.Provides] p
WHERE uu.restaurantID = res.restaurantID AND res.restaurantID = s.restaurantID AND s.cuisineId = c.cuisineId 
	  AND o.offerID = p.offerID AND uu.restaurantID=p.restaurantID) ll
WHERE ll.Cuisine = 'Mexican' ;




--Which is the Best Rated American Restaurant near the University that is providing two or more offers 
--and has car parking available ?

SELECT res.Name AS 'Best Rated American Restaurant', c.cuisineName AS 'Cuisine', res.carParking, k.numOffers AS 'Number of Offers'
FROM
(SELECT restaurantID, COUNT(restaurantID) as numOffers 
FROM [Restropedia.Provides] 
GROUP BY restaurantID 
HAVING COUNT(restaurantID)>1) k, [Restropedia.Restaurant] res, [Restropedia.Cuisine] c, [Restropedia.sells] s 
WHERE k.restaurantID = res.restaurantID AND c.cuisineID = s.cuisineID and res.restaurantID = s.restaurantID
      AND res.carParking = 'Y' and c.cuisineName = 'American' ;
