

CREATE TABLE [Restropedia.Restaurant] (
	restaurantID INTEGER IDENTITY (1001,1) NOT NULL, 
	name VARCHAR (50),
	phoneNo CHAR (10),
	[address] VARCHAR (100), 
	distance DECIMAL (4,2), 
	doorDelivery CHAR, 
	carParking CHAR, 
	outdoorSeating CHAR, 
	freeWifi CHAR, 
	openingHoursWeekdays VARCHAR (20),
	openingHoursWeekends VARCHAR (20),
	CONSTRAINT pk_Restaurant_restaurantID PRIMARY KEY (restaurantID)
	);

CREATE TABLE [Restropedia.Customer] (
	customerID INTEGER IDENTITY (10001,1) NOT NULL, 
	customerFirstName VARCHAR (20), 
	customerMiddleName VARCHAR (20), 
	customerLastName VARCHAR (20), 
	location VARCHAR (20),
	gender CHAR,
	CONSTRAINT pk_Restropedia_Customer_customerID PRIMARY KEY (customerID)
	);

CREATE TABLE [Restropedia.Offers] (
	offerID INTEGER IDENTITY (101,1) NOT NULL, 
	[description] VARCHAR (100)
	CONSTRAINT pk_Offers_offerID PRIMARY KEY (offerID) 
	);

CREATE TABLE [Restropedia.Cuisine] (
	cuisineID INTEGER IDENTITY (1,1) NOT NULL, 
	cuisineName VARCHAR (20)
	CONSTRAINT pk_Cuisine_cuisineID PRIMARY KEY (cuisineID)
	);

CREATE TABLE [Restropedia.Provides] (
	restaurantID INTEGER NOT NULL,
	offerID INTEGER NOT NULL, 
	validity DATE,
	CONSTRAINT pk_Provides_restaurantID_offerID PRIMARY KEY (restaurantID, offerID),
	CONSTRAINT fk_Provides_restaurantID FOREIGN KEY (restaurantID)
	REFERENCES [Restropedia.Restaurant] (restaurantID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Provides_offerID FOREIGN KEY (offerID)
	REFERENCES [Restropedia.Offers] (offerID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	);

CREATE TABLE [Restropedia.Sells] (
	restaurantID INTEGER NOT NULL, 
	cuisineID INTEGER NOT NULL,
	CONSTRAINT pk_Sells_restaurantID_cuisineID PRIMARY KEY (restaurantID, cuisineID),
	CONSTRAINT fk_Sells_restaurantID FOREIGN KEY (restaurantID)
	REFERENCES [Restropedia.Restaurant] (restaurantID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Sells_cuisineID FOREIGN KEY (cuisineID)
	REFERENCES [Restropedia.Cuisine] (cuisineID)
	ON DELETE CASCADE ON UPDATE CASCADE,
	);

CREATE TABLE [Restropedia.Reviews] (
	restaurantID INTEGER NOT NULL,
	customerID INTEGER NOT NULL, 
	ambience DECIMAL (3,2), 
	foodQuality DECIMAL (3,2), 
	[service] DECIMAL (3,2), 
	valueForMoney DECIMAL (3,2), 
	comments VARCHAR (200),
	CONSTRAINT pk_Reviews_restaurantID_customerID PRIMARY KEY (restaurantID, customerID),
	CONSTRAINT fk_Reviews_restaurantID FOREIGN KEY (restaurantID)
	REFERENCES [Restropedia.Restaurant] (restaurantID)	
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Reviews_customerID FOREIGN KEY (customerID)
	REFERENCES [Restropedia.Customer] (customerID)	
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT rng_Reviews_ambience CHECK (ambience >= 1 AND ambience <= 5),
	CONSTRAINT rng_Reviews_foodQuality CHECK (foodQuality >= 1 AND foodQuality <= 5),
	CONSTRAINT rng_Reviews_service CHECK ([service] >= 1 AND [service] <= 5),
	CONSTRAINT rng_Reviews_valueForMoney CHECK (valueForMoney >= 1 AND valueForMoney <= 5)
	);


