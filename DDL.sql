CREATE DATABASE IF NOT EXISTS ROCKING_DB;
USE ROCKING_DB;

/*-- Defininimos la función UC_Words que será empleada para normalizar la data --*/
DROP FUNCTION IF EXISTS UC_Words; 
SET GLOBAL  log_bin_trust_function_creators=TRUE; 
DELIMITER | 
CREATE FUNCTION UC_Words( str VARCHAR(128) ) 
RETURNS VARCHAR(128) 
BEGIN 
  DECLARE c CHAR(1); 
  DECLARE s VARCHAR(128); 
  DECLARE i INT DEFAULT 1; 
  DECLARE bool INT DEFAULT 1; 
  DECLARE punct CHAR(18) DEFAULT ' ()[]{},.-_\'!@;:?/';
  SET s = LCASE( str ); 
  WHILE i <= LENGTH( str ) DO 
    BEGIN 
      SET c = SUBSTRING( s, i, 1 ); 
      IF LOCATE( c, punct ) > 0 THEN 
        SET bool = 1; 
      ELSEIF bool=1 THEN  
        BEGIN 
          IF c >= 'a' AND c <= 'z' THEN  
            BEGIN 
              SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1)); 
              SET bool = 0; 
            END; 
          ELSEIF c >= '0' AND c <= '9' THEN 
            SET bool = 0; 
          END IF; 
        END; 
      END IF; 
      SET i = i+1; 
    END; 
  END WHILE; 
  RETURN s; 
END; 
| 
DELIMITER ; 

/*-- Creación e importación de las tablas de nuestro modelo --*/
CREATE TABLE IF NOT EXISTS `Movie` (
		`IdMovie`				INTEGER,
		`Platform`				VARCHAR(20),
        `Title`					VARCHAR(150),
        `DateAdded`				DATE,
        `ReleaseYear`			YEAR,
        `Rating`				VARCHAR(20),
        `Description`			VARCHAR(300),
		`Length`				INTEGER
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/movie.csv'
INTO TABLE `Movie`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdMovie,@dummy,Platform,Title,DateAdded,ReleaseYear,Rating,Description,Length);

CREATE TABLE IF NOT EXISTS `Tv_Show` (
		`IdTvShow`				INTEGER,
		`Platform`				VARCHAR(20),
        `Title`					VARCHAR(150),
        `DateAdded`				DATE,
        `ReleaseYear`			YEAR,
        `Rating`				VARCHAR(20),
        `Description`			VARCHAR(300),
		`Seasons`				INTEGER
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/tv_show.csv'
INTO TABLE `Tv_Show`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdTvShow,@dummy,Platform,Title,DateAdded,ReleaseYear,Rating,Description,Seasons);

CREATE TABLE IF NOT EXISTS `Direction` (
		`IdDirection`			INTEGER,
        `Movie`					VARCHAR(150),
        `Director`				VARCHAR(100)
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/direction.csv'
INTO TABLE `Direction`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdDirection,Movie,Director);

CREATE TABLE IF NOT EXISTS `Appearance_Mov` (
		`IdAppearanceMov`		INTEGER,
        `Movie`					VARCHAR(150),
        `Actor`					VARCHAR(150)
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/appearance_movie.csv'
INTO TABLE `Appearance_Mov`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdAppearanceMov,Movie,Actor);

CREATE TABLE IF NOT EXISTS `Appearance_Tv` (
		`IdAppearanceTv`		INTEGER,
        `TvShow`				VARCHAR(150),
        `Actor`					VARCHAR(150)
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/appearance_tv.csv'
INTO TABLE `Appearance_Tv`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdAppearanceTv,TvShow,Actor);

CREATE TABLE IF NOT EXISTS `Production_Mov` (
		`IdProductionMov`		INTEGER,
        `Movie`					VARCHAR(150),
        `Country`				VARCHAR(50)
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/production_mov.csv'
INTO TABLE `Production_Mov`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdProductionMov,Movie,Country);

CREATE TABLE IF NOT EXISTS `Production_Tv` (
		`IdProductionTv`		INTEGER,
        `TvShow`				VARCHAR(150),
        `Country`				VARCHAR(50)
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/production_tv.csv'
INTO TABLE `Production_Tv`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdProductionTv,TvShow,Country);

CREATE TABLE IF NOT EXISTS `Categorization_Mov` (
		`IdCategorizationMov`	INTEGER,
        `Movie`					VARCHAR(150),
        `Genre`					VARCHAR(50)
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/class_mov.csv'
INTO TABLE `Categorization_Mov`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdCategorizationMov,Movie,Genre);

CREATE TABLE IF NOT EXISTS `Categorization_Tv` (
		`IdCategorizationTv`	INTEGER,
        `TvShow`				VARCHAR(150),
        `Genre`					VARCHAR(50)
);
LOAD DATA INFILE 'C:/Users/Dell/Desktop/HENRY/Rockingdata_Challenge/RockingData_Chall/class_tv.csv'
INTO TABLE `Categorization_Tv`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(IdCategorizationTv,TvShow,Genre);

/*-- Reemplazo de caracteres problemáticos --*/
UPDATE `Movie` SET Title = REPLACE(Title,'"','');
UPDATE `Movie` SET Title = REPLACE(Title,"'",'');

UPDATE `Tv_Show` SET Title = REPLACE(Title,'"','');
UPDATE `Tv_Show` SET Title = REPLACE(Title,"'",'');

UPDATE `Direction` SET Movie = REPLACE(Movie,'"','');
UPDATE `Direction` SET Movie = REPLACE(Movie,"'",'');
UPDATE `Direction` SET Director = REPLACE(Director,'"','');
UPDATE `Direction` SET Director = REPLACE(Director,"'",'');

UPDATE `Appearance_Mov` SET Movie = REPLACE(Movie,'"','');
UPDATE `Appearance_Mov` SET Movie = REPLACE(Movie,"'",'');
UPDATE `Appearance_Mov` SET Actor = REPLACE(Actor,'"','');
UPDATE `Appearance_Mov` SET Actor = REPLACE(Actor,"'",'');

UPDATE `Appearance_Tv` SET TvShow = REPLACE(TvShow,'"','');
UPDATE `Appearance_Tv` SET TvShow = REPLACE(TvShow,"'",'');
UPDATE `Appearance_Tv` SET Actor = REPLACE(Actor,'"','');
UPDATE `Appearance_Tv` SET Actor = REPLACE(Actor,"'",'');

UPDATE `Production_Mov` SET Movie = REPLACE(Movie,'"','');
UPDATE `Production_Mov` SET Movie = REPLACE(Movie,"'",'');
UPDATE `Production_Mov` SET Country = REPLACE(Country,'"','');
UPDATE `Production_Mov` SET Country = REPLACE(Country,"'",'');

UPDATE `Production_Tv` SET TvShow = REPLACE(TvShow,'"','');
UPDATE `Production_Tv` SET TvShow = REPLACE(TvShow,"'",'');
UPDATE `Production_Tv` SET Country = REPLACE(Country,'"','');
UPDATE `Production_Tv` SET Country = REPLACE(Country,"'",'');

UPDATE `Categorization_Mov` SET Movie = REPLACE(Movie,'"','');
UPDATE `Categorization_Mov` SET Movie = REPLACE(Movie,"'",'');
UPDATE `Categorization_Mov` SET Genre = REPLACE(Genre,'"','');
UPDATE `Categorization_Mov` SET Genre = REPLACE(Genre,"'",'');

UPDATE `Categorization_Tv` SET TvShow = REPLACE(TvShow,'"','');
UPDATE `Categorization_Tv` SET TvShow = REPLACE(TvShow,"'",'');
UPDATE `Categorization_Tv` SET Genre = REPLACE(Genre,'"','');
UPDATE `Categorization_Tv` SET Genre = REPLACE(Genre,"'",'');

/*-- Imputación de valores faltantes --*/
UPDATE `Movie` SET Platform = 'Not Specified' WHERE TRIM(Platform) = "" OR ISNULL(Platform);
UPDATE `Movie` SET Title = 'Not Specified' WHERE TRIM(Title) = "" OR ISNULL(Title);
UPDATE `Movie` SET Rating = 'Not Specified' WHERE TRIM(Rating) = "" OR ISNULL(Rating);
UPDATE `Movie` SET Description = 'Not Specified' WHERE TRIM(Description) = "" OR ISNULL(Description);

UPDATE `Tv_Show` SET Platform = 'Not Specified' WHERE TRIM(Platform) = "" OR ISNULL(Platform);
UPDATE `Tv_Show` SET Title = 'Not Specified' WHERE TRIM(Title) = "" OR ISNULL(Title);
UPDATE `Tv_Show` SET Rating = 'Not Specified' WHERE TRIM(Rating) = "" OR ISNULL(Rating);
UPDATE `Tv_Show` SET Description = 'Not Specified' WHERE TRIM(Description) = "" OR ISNULL(Description);

UPDATE `Direction` SET Movie = 'Not Specified' WHERE TRIM(Movie) = "" OR ISNULL(Movie);
UPDATE `Direction` SET Director = 'Not Specified' WHERE TRIM(Director) = "" OR ISNULL(Director);

UPDATE `Appearance_Mov` SET Movie = 'Not Specified' WHERE TRIM(Movie) = "" OR ISNULL(Movie);
UPDATE `Appearance_Mov` SET Actor = 'Not Specified' WHERE TRIM(Actor) = "" OR ISNULL(Actor);

UPDATE `Appearance_Tv` SET TvShow = 'Not Specified' WHERE TRIM(TvShow) = "" OR ISNULL(TvShow);
UPDATE `Appearance_Tv` SET Actor = 'Not Specified' WHERE TRIM(Actor) = "" OR ISNULL(Actor);

UPDATE `Production_Mov` SET Movie = 'Not Specified' WHERE TRIM(Movie) = "" OR ISNULL(Movie);
UPDATE `Production_Mov` SET Country = 'Not Specified' WHERE TRIM(Country) = "" OR ISNULL(Country);

UPDATE `Production_Tv` SET TvShow = 'Not Specified' WHERE TRIM(TvShow) = "" OR ISNULL(TvShow);
UPDATE `Production_Tv` SET Country = 'Not Specified' WHERE TRIM(Country) = "" OR ISNULL(Country);

UPDATE `Categorization_Mov` SET Movie = 'Not Specified' WHERE TRIM(Movie) = "" OR ISNULL(Movie);
UPDATE `Categorization_Mov` SET Genre = 'Not Specified' WHERE TRIM(Genre) = "" OR ISNULL(Genre);

UPDATE `Categorization_Tv` SET TvShow = 'Not Specified' WHERE TRIM(TvShow) = "" OR ISNULL(TvShow);
UPDATE `Categorization_Tv` SET Genre = 'Not Specified' WHERE TRIM(Genre) = "" OR ISNULL(Genre);

/*-- Normalización de campos usando la función UC_Words --*/
UPDATE `Movie` SET 				Platform = UC_Words(TRIM(Platform)),
								Title = UC_Words(TRIM(Title)),
								Rating = UC_Words(TRIM(Rating));
                    
UPDATE `Tv_Show` SET 			Platform = UC_Words(TRIM(Platform)),
								Title = UC_Words(TRIM(Title)),
								Rating = UC_Words(TRIM(Rating));
                        
UPDATE `Direction` SET 			Movie = UC_Words(TRIM(Movie)),
								Director = UC_Words(TRIM(Director));
                        
UPDATE `Appearance_Mov` SET 	Movie = UC_Words(TRIM(Movie)),
								Actor = UC_Words(TRIM(Actor));
                            
UPDATE `Appearance_Tv` SET 		TvShow = UC_Words(TRIM(TvShow)),
								Actor = UC_Words(TRIM(Actor));
                            
UPDATE `Production_Mov` SET 	Movie = UC_Words(TRIM(Movie)),
								Country = UC_Words(TRIM(Country));
                            
UPDATE `Production_Tv` SET 		TvShow = UC_Words(TRIM(TvShow)),
								Country = UC_Words(TRIM(Country));
                            
UPDATE `Categorization_Mov` SET	Movie = UC_Words(TRIM(Movie)),
								Genre = UC_Words(TRIM(Genre));
                                
UPDATE `Categorization_Tv` SET	TvShow = UC_Words(TRIM(TvShow)),
								Genre = UC_Words(TRIM(Genre));
                                
/*-- Normalización de las tablas `Movie` y `Tv_Show` --*/
CREATE TABLE `Platform` (
		`IdPlatform` 			INT NOT NULL AUTO_INCREMENT,
        `Platform`				VARCHAR(20) NOT NULL,
        PRIMARY KEY (`IdPlatform`)
);
INSERT INTO Platform (Platform) SELECT DISTINCT Platform FROM Movie ORDER BY 1;

CREATE TABLE `Rating` (
		`IdRating` 				INT NOT NULL AUTO_INCREMENT,
        `Rating` 					VARCHAR(30),
        PRIMARY KEY (`IdRating`)
);
INSERT INTO Rating (Rating) SELECT DISTINCT Rating FROM Movie ORDER BY 1;
    
ALTER TABLE `Movie` 	ADD `IdPlatform` INT NOT NULL AFTER `Platform`,
						ADD `IdRating` INT NOT NULL AFTER `Rating`;
                    
ALTER TABLE `Tv_Show` 	ADD `IdPlatform` INT NOT NULL AFTER `Platform`,
						ADD `IdRating` INT NOT NULL AFTER `Rating`;

UPDATE Movie mov JOIN Platform p ON (mov.Platform = p.Platform) SET mov.IdPlatform = p.IdPlatform;
UPDATE Movie mov JOIN Rating r ON (mov.Rating = r.Rating) SET mov.IdRating = r.IdRating;

UPDATE Tv_Show tv JOIN Platform p ON (tv.Platform = p.Platform) SET tv.IdPlatform = p.IdPlatform;
UPDATE Tv_Show tv JOIN Rating r ON (tv.Rating = r.Rating) SET tv.IdRating = r.IdRating;

ALTER TABLE `Movie` DROP Platform;
ALTER TABLE `Movie` DROP Rating;

ALTER TABLE `Tv_Show` DROP Platform;
ALTER TABLE `Tv_Show` DROP Rating;

/*-- Normalización de la tabla `Direction` --*/
CREATE TABLE `Director` (
		`IdDirector` 			INT NOT NULL AUTO_INCREMENT,
        `Name`					VARCHAR(100) NOT NULL,
        PRIMARY KEY (`IdDirector`)
);
INSERT INTO Director (Name) SELECT DISTINCT Director FROM Direction ORDER BY 1;

ALTER TABLE `Direction`	ADD `IdDirector` INT NOT NULL AFTER `Director`,
						ADD `IdMovie` INT NOT NULL AFTER `Movie`;

CREATE INDEX Movie_Title ON Movie(Title);
CREATE INDEX Director_Name ON Director(Name);
CREATE INDEX Movie_Title ON Direction(Movie);
CREATE INDEX Director_Name ON Direction(Director);
UPDATE Direction dn JOIN Movie mov ON (dn.Movie = mov.Title) SET dn.IdMovie = mov.IdMovie;
UPDATE Direction dn JOIN Director dr ON (dn.Director = dr.Name) SET dn.IdDirector = dr.IdDirector;

ALTER TABLE `Direction` DROP INDEX Movie_Title;
ALTER TABLE `Direction` DROP INDEX Director_Name;
ALTER TABLE `Direction` DROP Movie;
ALTER TABLE `Direction` DROP Director;

/*-- Normalización de las tablas `Appearance_Mov` y `Appearance_Tv` --*/
CREATE TABLE `Actor` (
		`IdActor` 				INT NOT NULL AUTO_INCREMENT,
        `Name`					VARCHAR(150) NOT NULL,
        PRIMARY KEY (`IdActor`)
);
INSERT INTO Actor (Name) SELECT DISTINCT Actor FROM (
	SELECT Actor FROM Appearance_Mov 
    UNION ALL
    SELECT Actor FROM Appearance_Tv) as k
ORDER BY 1;

ALTER TABLE `Appearance_Mov`	ADD `IdMovie` INT NOT NULL AFTER `Movie`,
								ADD `IdActor` INT NOT NULL AFTER `Actor`;
                                
ALTER TABLE `Appearance_Tv`		ADD `IdTvShow` INT NOT NULL AFTER `TvShow`,
								ADD `IdActor` INT NOT NULL AFTER `Actor`;

CREATE INDEX Actor_Name ON Appearance_Mov (Actor);
CREATE INDEX Movie_Title ON Appearance_Mov (Movie);
CREATE INDEX Actor_Name ON Actor (Name);
UPDATE Appearance_Mov ap_m JOIN Movie mov ON (ap_m.Movie = mov.Title) SET ap_m.IdMovie = mov.IdMovie;
UPDATE Appearance_Mov ap_m JOIN Actor a ON (ap_m.Actor = a.Name) SET ap_m.IdActor = a.IdActor;
 

CREATE INDEX Actor_Name ON Appearance_Tv (Actor);
CREATE INDEX TvShow_Title ON Appearance_Tv (TvShow);
CREATE INDEX TvShow_title ON Tv_Show (Title);
UPDATE Appearance_Tv ap_tv JOIN Tv_Show tv ON (ap_tv.TvShow = tv.Title) SET ap_tv.IdTvShow = tv.IdTvShow;
UPDATE Appearance_Tv ap_tv JOIN Actor a ON (ap_tv.Actor = a.Name) SET ap_tv.IdActor = a.IdActor;

ALTER TABLE `Appearance_Mov` DROP INDEX Movie_Title;
ALTER TABLE `Appearance_Mov` DROP INDEX Actor_Name;
ALTER TABLE `Appearance_Mov` DROP Movie;
ALTER TABLE `Appearance_Mov` DROP Actor;

ALTER TABLE `Appearance_Tv` DROP INDEX TvShow_Title;
ALTER TABLE `Appearance_Tv` DROP INDEX Actor_Name;
ALTER TABLE `Appearance_Tv` DROP TvShow;
ALTER TABLE `Appearance_Tv` DROP Actor;

/*-- Normalización de las tablas `Production_Mov` y `Production_Tv` --*/
CREATE TABLE `Country` (
		`IdCountry` 			INT NOT NULL AUTO_INCREMENT,
        `Name`					VARCHAR(150) NOT NULL,
        PRIMARY KEY (`IdCountry`)
);
INSERT INTO Country (Name) SELECT DISTINCT Country FROM (
	SELECT Country FROM Production_Mov 
    UNION ALL
    SELECT Country FROM Production_Tv) as k
ORDER BY 1;

ALTER TABLE `Production_Mov`	ADD `IdMovie` INT NOT NULL AFTER `Movie`,
								ADD `IdCountry` INT NOT NULL AFTER `Country`;
                                
ALTER TABLE `Production_Tv`		ADD `IdTvShow` INT NOT NULL AFTER `TvShow`,
								ADD `IdCountry` INT NOT NULL AFTER `Country`;

CREATE INDEX Movie_Title ON Production_Mov (Movie);
CREATE INDEX Country_Name ON Production_Mov (Country);
CREATE INDEX Country_Name ON Country (Name);
UPDATE Production_Mov p_m JOIN Movie mov ON (p_m.Movie = mov.Title) SET p_m.IdMovie = mov.IdMovie;
UPDATE Production_Mov p_m JOIN Country c ON (p_m.Country = c.Name) SET p_m.IdCountry = c.IdCountry;
 
CREATE INDEX TvShow_Title ON Production_Tv (TvShow);
CREATE INDEX Country_Name ON Production_Tv (Country);
UPDATE Production_Tv p_tv JOIN Tv_Show tv ON (p_tv.TvShow = tv.Title) SET p_tv.IdTvShow = tv.IdTvShow;
UPDATE Production_Tv p_tv JOIN Country c ON (p_tv.Country = c.Name) SET p_tv.IdCountry = c.IdCountry;

ALTER TABLE `Production_Mov` DROP INDEX Movie_Title;
ALTER TABLE `Production_Mov` DROP INDEX Country_Name;
ALTER TABLE `Production_Mov` DROP Movie;
ALTER TABLE `Production_Mov` DROP Country;

ALTER TABLE `Production_Tv` DROP INDEX TvShow_Title;
ALTER TABLE `Production_Tv` DROP INDEX Country_Name;
ALTER TABLE `Production_Tv` DROP TvShow;
ALTER TABLE `Production_Tv` DROP Country;

/*-- Normalización de las tablas `Categorization_Mov` y `Categorization_Tv` --*/
CREATE TABLE `Genre` (
		`IdGenre` 			INT NOT NULL AUTO_INCREMENT,
        `Genre`				VARCHAR(150) NOT NULL,
        PRIMARY KEY (`IdGenre`)
);
INSERT INTO Genre (Genre) SELECT DISTINCT Genre FROM (
	SELECT Genre FROM Categorization_Mov 
    UNION ALL
    SELECT Genre FROM Categorization_Tv) as k
ORDER BY 1;

ALTER TABLE `Categorization_Mov`	ADD `IdMovie` INT NOT NULL AFTER `Movie`,
									ADD `IdGenre` INT NOT NULL AFTER `Genre`;
                                
ALTER TABLE `Categorization_Tv`		ADD `IdTvShow` INT NOT NULL AFTER `TvShow`,
									ADD `IdGenre` INT NOT NULL AFTER `Genre`;

CREATE INDEX Movie_Title ON Categorization_Mov (Movie);
CREATE INDEX Genre_Name ON Categorization_Mov (Genre);
CREATE INDEX Genre_Name ON Genre (Genre);
UPDATE Categorization_Mov cat_m JOIN Movie mov ON (cat_m.Movie = mov.Title) SET cat_m.IdMovie = mov.IdMovie;
UPDATE Categorization_Mov cat_m JOIN Genre g ON (cat_m.Genre = g.Genre) SET cat_m.IdGenre = g.IdGenre;
 
CREATE INDEX TvShow_Title ON Categorization_Tv (TvShow);
CREATE INDEX Genre_Name ON Categorization_Tv (Genre);
UPDATE Categorization_Tv cat_tv JOIN Tv_Show tv ON (cat_tv.TvShow = tv.Title) SET cat_tv.IdTvShow = tv.IdTvShow;
UPDATE Categorization_Tv cat_tv JOIN Genre g ON (cat_tv.Genre = g.Genre) SET cat_tv.IdGenre = g.IdGenre;

ALTER TABLE `Categorization_Mov` DROP INDEX Movie_Title;
ALTER TABLE `Categorization_Mov` DROP INDEX Genre_Name;
ALTER TABLE `Categorization_Mov` DROP Movie;
ALTER TABLE `Categorization_Mov` DROP Genre;

ALTER TABLE `Categorization_Tv` DROP INDEX TvShow_Title;
ALTER TABLE `Categorization_Tv` DROP INDEX Genre_Name;
ALTER TABLE `Categorization_Tv` DROP TvShow;
ALTER TABLE `Categorization_Tv` DROP Genre;

/*-- Creación de índices y declaración de Primary Keys --*/
ALTER TABLE `Movie` ADD PRIMARY KEY(`IdMovie`);
ALTER TABLE `Movie` ADD INDEX(`IdPlatform`);
ALTER TABLE `Movie` ADD INDEX(`DateAdded`);
ALTER TABLE `Movie` ADD INDEX(`ReleaseYear`);
ALTER TABLE `Movie` ADD INDEX(`IdRating`);

ALTER TABLE `Tv_Show` ADD PRIMARY KEY(`IdTvShow`);
ALTER TABLE `Tv_Show` ADD INDEX(`IdPlatform`);
ALTER TABLE `Tv_Show` ADD INDEX(`DateAdded`);
ALTER TABLE `Tv_Show` ADD INDEX(`ReleaseYear`);
ALTER TABLE `Tv_Show` ADD INDEX(`IdRating`);

ALTER TABLE `Direction` ADD PRIMARY KEY(`IdDirection`);
ALTER TABLE `Direction` ADD INDEX(`IdMovie`);
ALTER TABLE `Direction` ADD INDEX(`IdDirector`);

ALTER TABLE `Appearance_Mov` ADD PRIMARY KEY(`IdAppearanceMov`);
ALTER TABLE `Appearance_Mov` ADD INDEX(`IdMovie`);
ALTER TABLE `Appearance_Mov` ADD INDEX(`IdActor`);

ALTER TABLE `Appearance_Tv` ADD PRIMARY KEY(`IdAppearanceTv`);
ALTER TABLE `Appearance_Tv` ADD INDEX(`IdTvShow`);
ALTER TABLE `Appearance_Tv` ADD INDEX(`IdActor`);

ALTER TABLE `Production_Mov` ADD PRIMARY KEY(`IdProductionMov`);
ALTER TABLE `Production_Mov` ADD INDEX(`IdMovie`);
ALTER TABLE `Production_Mov` ADD INDEX(`IdCountry`);

ALTER TABLE `Production_Tv` ADD PRIMARY KEY(`IdProductionTv`);
ALTER TABLE `Production_Tv` ADD INDEX(`IdTvShow`);
ALTER TABLE `Production_Tv` ADD INDEX(`IdCountry`);

ALTER TABLE `Categorization_Mov` ADD PRIMARY KEY(`IdCategorizationMov`);
ALTER TABLE `Categorization_Mov` ADD INDEX(`IdMovie`);
ALTER TABLE `Categorization_Mov` ADD INDEX(`IdGenre`);

ALTER TABLE `Categorization_Tv` ADD PRIMARY KEY(`IdCategorizationTv`);
ALTER TABLE `Categorization_Tv` ADD INDEX(`IdTvShow`);
ALTER TABLE `Categorization_Tv` ADD INDEX(`IdGenre`);

/*-- Creación de relaciones, declaración de Foreign Keys y restricciones --*/
ALTER TABLE `Movie` ADD CONSTRAINT `Movie_fk_Platform` FOREIGN KEY (IdPlatform) REFERENCES Platform (IdPlatform) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Movie` ADD CONSTRAINT `Movie_fk_Rating` FOREIGN KEY (IdRating) REFERENCES Rating (IdRating) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Tv_Show` ADD CONSTRAINT `Tv_Show_fk_Platform` FOREIGN KEY (IdPlatform) REFERENCES Platform (IdPlatform) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Tv_Show` ADD CONSTRAINT `Tv_Show_fk_Rating` FOREIGN KEY (IdRating) REFERENCES Rating (IdRating) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Direction` ADD CONSTRAINT `Direction_fk_Movie` FOREIGN KEY (IdMovie) REFERENCES Movie (IdMovie) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Direction` ADD CONSTRAINT `Direction_fk_Director` FOREIGN KEY (IdDirector) REFERENCES Director (IdDirector) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Appearance_Mov` ADD CONSTRAINT `Appearance_Mov_fk_Movie` FOREIGN KEY (IdMovie) REFERENCES Movie (IdMovie) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Appearance_Mov` ADD CONSTRAINT `Appearance_Mov_fk_Actor` FOREIGN KEY (IdActor) REFERENCES Actor (IdActor) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Appearance_Tv` ADD CONSTRAINT `Appearance_Tv_fk_Tv_Show` FOREIGN KEY (IdTvShow) REFERENCES Tv_Show (IdTvShow) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Appearance_Tv` ADD CONSTRAINT `Appearance_Tv_fk_Actor` FOREIGN KEY (IdActor) REFERENCES Actor (IdActor) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Production_Mov` ADD CONSTRAINT `Production_Mov_fk_Movie` FOREIGN KEY (IdMovie) REFERENCES Movie (IdMovie) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Production_Mov` ADD CONSTRAINT `Production_Mov_fk_Country` FOREIGN KEY (IdCountry) REFERENCES Country (IdCountry) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Production_Tv` ADD CONSTRAINT `Production_Tv_fk_Tv_Show` FOREIGN KEY (IdTvShow) REFERENCES Tv_Show (IdTvShow) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Production_Tv` ADD CONSTRAINT `Production_Tv_fk_Country` FOREIGN KEY (IdCountry) REFERENCES Country (IdCountry) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Categorization_Mov` ADD CONSTRAINT `Categorization_Mov_fk_Movie` FOREIGN KEY (IdMovie) REFERENCES Movie (IdMovie) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Categorization_Mov` ADD CONSTRAINT `Categorization_Mov_fk_Genre` FOREIGN KEY (IdGenre) REFERENCES Genre (IdGenre) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE `Categorization_Tv` ADD CONSTRAINT `Categorization_Tv_fk_Tv_Show` FOREIGN KEY (IdTvShow) REFERENCES Tv_Show (IdTvShow) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `Categorization_Tv` ADD CONSTRAINT `Categorization_Tv_fk_Genre` FOREIGN KEY (IdGenre) REFERENCES Genre (IdGenre) ON DELETE RESTRICT ON UPDATE RESTRICT;
