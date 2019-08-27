	
	CREATE VIEW [vw.summary]
	AS
	SELECT res.restaurantID, res.name, res.address, res.freeWifi, res.carParking, res.outdoorSeating, c.cuisineName, 
		   AVG(rev.ambience) AS avgAmbience, AVG(rev.foodQuality) AS avgfoodQuality, 
           AVG(rev.service) AS avgService, AVG(rev.valueForMoney) AS avgValueForMoney,
	       (AVG(rev.ambience + rev.foodQuality + rev.service + rev.valueForMoney)/4)
	       AS avgRating
	FROM [Restropedia.Restaurant] res,[Restropedia.Reviews] rev,[Restropedia.Cuisine] c,
		 [Restropedia.Sells] s
	WHERE res.restaurantID = rev.restaurantID AND res.restaurantID = s.restaurantID
          AND c.cuisineID = s.cuisineID
	GROUP BY res.restaurantID, res.name, res.address, res.freeWifi, res.carParking, res.outdoorSeating, c.cuisineName ;