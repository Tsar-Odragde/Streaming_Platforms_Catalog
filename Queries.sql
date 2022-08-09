USE ROCKING_DB;

/*-- 1. Considerando únicamente la plataforma de Netflix, ¿qué actor aparece más veces? --*/
SELECT d.IdActor, ac.Name, COUNT(*) as Appearances FROM (
		SELECT a.IdActor, m.IdPlatform FROM Appearance_Mov a, Movie m
		WHERE m.IdMovie = a.IdMovie AND IdPlatform = 2 AND IdActor != 26660
	UNION ALL
		SELECT a.IdActor, t.IdPlatform FROM Appearance_Tv a, Tv_Show t
		WHERE t.IdTvShow = a.IdTvShow AND IdPlatform = 2 AND IdActor != 26660) d,
	Actor ac
WHERE ac.IdActor = d.IdActor
GROUP BY IdActor
ORDER BY Appearances DESC
LIMIT 1;

/*-- Top 10 de actores participantes considerando ambas plataformas en el año actual. Se aprecia flexibilidad. --*/

DELIMITER $$
CREATE PROCEDURE topActors(IN SelectedYear INT)
BEGIN
	SELECT a.IdActor, ac.Name, COUNT(*) as Appearances FROM (
			SELECT a.IdActor, YEAR(m.DateAdded) as YearAdded FROM Appearance_Mov a, Movie m
			WHERE m.IdMovie = a.IdMovie AND IdActor != 26660
		UNION ALL
			SELECT a.IdActor, YEAR(t.DateAdded) as YearAdded FROM Appearance_Tv a, Tv_Show t
			WHERE t.IdTvShow = a.IdTvShow AND IdActor != 26660) a,
		Actor ac
	WHERE (a.IdActor = ac.IdActor) AND YearAdded <= SelectedYear
	GROUP BY IdActor
	ORDER BY Appearances DESC
LIMIT 10;
END $$

DELIMITER ;

CALL topActors(2021);

/*-- Crear un Stored Proceadure que tome como parámetro un año y devuelva una tabla con las 5 películas con mayor duración en minutos. --*/
DELIMITER $$
CREATE PROCEDURE longerMovies(IN SelectedYear INT)
BEGIN
	SELECT IdMovie, IdPlatform, Title, ReleaseYear, Length, Description FROM Movie
	WHERE ReleaseYear = SelectedYear
	ORDER BY Length DESC
	LIMIT 5;
END $$

DELIMITER ;

CALL longerMovies(2021);