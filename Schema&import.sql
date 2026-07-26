CREATE DATABASE spotify_db;
USE spotify_db;

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify 
(
	Artist VARCHAR(255),
	Track VARCHAR(255),
	Album VARCHAR(255),
	Album_type VARCHAR(50),
    Danceability FLOAT,
	Energy FLOAT,
	Loudness FLOAT,
	Speechiness FLOAT,
	Acousticness FLOAT,
	Instrumentalness FLOAT,
	Liveness FLOAT,
	Valence FLOAT,
	Tempo FLOAT,
	Duration_min FLOAT,
	Title VARCHAR(255),
	Channel VARCHAR(255),
	Views FLOAT,
	Likes BIGINT,
	Comments BIGINT,
	Licensed VARCHAR(5),
	official_video VARCHAR(5),
	Stream BIGINT,
	EnergyLiveness FLOAT,
	most_playedon VARCHAR(50)
);

SET GLOBAL local_infile = ON;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'E:/MYSQL/Spotify_P4/cleaned_dataset.csv'
INTO TABLE spotify
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
	@Artist,
	@Track,
	@Album,
	@Album_type,	
    @Danceability,	
    @Energy,
	@Loudness,	
    @Speechiness,	
    @Acousticness,	
    @Instrumentalness,	
    @Liveness,
	@Valence,
	@Tempo,
	@Duration_min,
	@Title,
	@Channel,
	@Views,
	@Likes,
	@Comments,
	@Licensed,
	@official_video,
	@Stream,
	@EnergyLiveness,
	@most_playedon
)
SET
Artist = NULLIF(@Artist,''),
Track =	NULLIF(@Track,''),
Album = NULLIF(@Album,''),
Album_type = NULLIF(@Album_type,''),	
Danceability = NULLIF(@Danceability,''),	
Energy = NULLIF(@Energy,''),
Loudness = NULLIF(@Loudness,''),
Speechiness = NULLIF(@Speechiness,''),
Acousticness = NULLIF(@Acousticness,''),
Instrumentalness = NULLIF(@Instrumentalness,''),
Liveness = NULLIF(@Liveness,''),
Valence = NULLIF(@Valence,''),
Tempo = NULLIF(@Tempo,''),
Duration_min = NULLIF(@Duration_min,''),
Title = NULLIF(@Title,''),
Channel = NULLIF(@Channel,''),
Views = NULLIF(@Views,''),
Likes = NULLIF(@Likes,''),
Comments = NULLIF(@Comments,''),
Licensed = NULLIF(@Licensed,''),
official_video = NULLIF(@official_video,''),
Stream = NULLIF(@Stream,''),
EnergyLiveness = NULLIF(@EnergyLiveness,''),
most_playedon = NULLIF(@most_playedon,'');

SELECT * FROM spotify LIMIT 20;

SELECT COUNT(DISTINCT Artist) FROM spotify;
SELECT COUNT(DISTINCT Album) FROM spotify;
SELECT DISTINCT Album_type FROM spotify;
SELECT * FROM spotify WHERE Album = 0.396;

SELECT MIN(Duration_min) FROM spotify;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM spotify WHERE Duration_min = 0;
SET SQL_SAFE_UPDATES = 1;


