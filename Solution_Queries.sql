-- EASY LEVEL Business problems
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT Track FROM spotify WHERE Stream > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT 
DISTINCT Album,Artist 
FROM spotify;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT * FROM spotify;
SELECT 
	SUM(Comments) as total_Comments 
FROM spotify 
WHERE Licensed = 'TRUE';
-- 4. Find all tracks that belong to the album type single.
SELECT
	Track,Album_type
FROM spotify
WHERE Album_type = 'single';

-- 5. Count the total number of tracks by each artist. 

SELECT
	Artist,
    COUNT(Track) AS total_tracks
FROM spotify
GROUP BY 1;

/* Medium level problems*/

-- 6. Calculate the average danceability of tracks in each album.
SELECT 
	Album,
	AVG(Danceability) AS avg_danceability
FROM spotify
GROUP BY 1;

-- 7. Find the top 5 tracks with the highest energy values.
SELECT 
	Track,
    MAX(Energy) as Energy
FROM spotify 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT
	Track,
    SUM(Views) AS total_Views,
    SUM(Likes) AS total_Likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY 1;
-- 9. For each album, calculate the total views of all associated tracks.
SELECT
	Album,
    Track,
    SUM(Views) as Total_view
FROM spotify
GROUP BY 1,2
ORDER BY 2 DESC;
-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(SELECT 
	Track,
	COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN Stream END),0) AS streamed_on_youtube,
    COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN Stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY 1
) AS t1
WHERE 
	streamed_on_spotify > streamed_on_youtube
    AND
    streamed_on_youtube <> 0;

/* Advance level */
-- 11.Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_table
AS
(
SELECT
	Artist,
    Track,
    SUM(Views) as views,
    DENSE_RANK() OVER(PARTITION BY Artist ORDER BY SUM(Views) DESC) AS rank_
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_table
WHERE rank_ <= 3;
-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT
	Track,
    Liveness
FROM spotify
WHERE Liveness>(SELECT AVG(Liveness) FROM spotify);

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(
SELECT 
	Album,
    MAX(Energy) as highest_energy,
    MIN(Energy) as lowest_energy
FROM spotify
GROUP BY Album
)
SELECT 
	Album,
    highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC;
-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
WITH ratio_find
AS
(
SELECT
	Track,
    AVG(Energy) AS T_Energy,
    AVG(Liveness) AS T_Liveness
FROM spotify
GROUP BY 1
)
SELECT 
	TRACK,
    T_Energy,
    T_Liveness,
    T_Energy/T_Liveness AS ratio
FROM ratio_find
WHERE T_Energy/T_Liveness > 1.2
ORDER BY 4;

-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT
    Track,
    Views,
    Likes,
    SUM(Likes) OVER (
						ORDER BY Views DESC
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
					) AS Cumulative_Likes
FROM spotify
ORDER BY Views DESC;

