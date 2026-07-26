# 🎵 Spotify SQL Data Analysis Project

A comprehensive SQL data analysis project built using **MySQL** to explore Spotify music data and solve real-world business problems using SQL.

This project covers everything from **database creation and data import** to **data cleaning**, **exploratory analysis**, **aggregation**, **window functions**, **Common Table Expressions (CTEs)**, and **advanced SQL queries**.

---

# 📌 Project Objectives

- Create and manage a Spotify database in MySQL.
- Import a CSV dataset using `LOAD DATA LOCAL INFILE`.
- Clean missing values during data import.
- Perform exploratory data analysis (EDA).
- Solve business questions using SQL.
- Practice advanced SQL concepts like:
  - Aggregate Functions
  - GROUP BY
  - CASE Statements
  - Window Functions
  - CTEs (Common Table Expressions)
  - Ranking Functions
  - Conditional Aggregation

---

# 🛠️ Tech Stack

- **Database:** MySQL 8.x
- **Language:** SQL
- **Tool:** MySQL Workbench

---

# 📂 Dataset

The dataset contains Spotify music information including:

- Artist
- Track
- Album
- Album Type
- Danceability
- Energy
- Loudness
- Speechiness
- Acousticness
- Instrumentalness
- Liveness
- Valence
- Tempo
- Duration
- Views
- Likes
- Comments
- Streams
- Licensed
- Official Video
- Platform (Spotify / YouTube)

---

# 🗄️ Database Creation

```sql
CREATE DATABASE spotify_db;
USE spotify_db;
```

---

# 📋 Table Structure

The dataset is stored in a table named **spotify**.
``` sql
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
```

---

# 📥 Data Import

The dataset is imported using MySQL's `LOAD DATA LOCAL INFILE`.

```sql
LOAD DATA LOCAL INFILE 'cleaned_dataset.csv'
INTO TABLE spotify
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
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

```


cleaning performed:

- Removed records with zero duration.

```sql
DELETE
FROM spotify
WHERE Duration_min = 0;
```

---

# 🔍 Exploratory Data Analysis (EDA)

Basic exploration queries include:

### Total Unique Artists

```sql
SELECT COUNT(DISTINCT Artist)
FROM spotify;
```

### Total Unique Albums

```sql
SELECT COUNT(DISTINCT Album)
FROM spotify;
```

### Album Types

```sql
SELECT DISTINCT Album_type
FROM spotify;
```

### Minimum Track Duration

```sql
SELECT MIN(Duration_min)
FROM spotify;
```

---

# 📊 Business Problems Solved

## 🟢 Easy Level

### 1. Tracks with More Than 1 Billion Streams

```sql
SELECT Track
FROM spotify
WHERE Stream > 1000000000;
```

---

### 2. List Albums with Their Artists

```sql
SELECT DISTINCT Album, Artist
FROM spotify;
```

---

### 3. Total Comments for Licensed Tracks

```sql
SELECT SUM(Comments) AS total_comments
FROM spotify
WHERE Licensed = 'TRUE';
```

---

### 4. Tracks Belonging to Single Albums

```sql
SELECT Track, Album_type
FROM spotify
WHERE Album_type = 'single';
```

---

### 5. Number of Tracks by Each Artist

```sql
SELECT
    Artist,
    COUNT(Track) AS total_tracks
FROM spotify
GROUP BY Artist;
```

---

# 🟡 Medium Level

### 6. Average Danceability of Each Album

```sql
SELECT
    Album,
    AVG(Danceability) AS avg_danceability
FROM spotify
GROUP BY Album;
```

---

### 7. Top 5 Highest Energy Tracks

```sql
SELECT
    Track,
    MAX(Energy) AS Energy
FROM spotify
GROUP BY Track
ORDER BY Energy DESC
LIMIT 5;
```

---

### 8. Views and Likes of Official Videos

```sql
SELECT
    Track,
    SUM(Views) AS total_views,
    SUM(Likes) AS total_likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY Track;
```

---

### 9. Total Views for Each Album

```sql
SELECT
    Album,
    Track,
    SUM(Views) AS total_views
FROM spotify
GROUP BY Album, Track;
```

---

### 10. Tracks Streamed More on Spotify than YouTube

```sql
SELECT *
FROM
(
    SELECT
        Track,
        COALESCE(
            SUM(
                CASE
                    WHEN most_playedon = 'Youtube'
                    THEN Stream
                END
            ),0
        ) AS streamed_on_youtube,

        COALESCE(
            SUM(
                CASE
                    WHEN most_playedon = 'Spotify'
                    THEN Stream
                END
            ),0
        ) AS streamed_on_spotify

    FROM spotify
    GROUP BY Track

) t

WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <> 0;
```

---

# 🔴 Advanced Level

### 11. Top 3 Most Viewed Tracks for Every Artist

```sql
WITH ranking_table AS
(
    SELECT
        Artist,
        Track,
        SUM(Views) AS Views,

        DENSE_RANK() OVER
        (
            PARTITION BY Artist
            ORDER BY SUM(Views) DESC
        ) AS rank_

    FROM spotify

    GROUP BY Artist, Track
)

SELECT *
FROM ranking_table
WHERE rank_ <= 3;
```

---

### 12. Tracks with Above Average Liveness

```sql
SELECT
    Track,
    Liveness
FROM spotify
WHERE Liveness >
(
    SELECT AVG(Liveness)
    FROM spotify
);
```

---

### 13. Difference Between Highest and Lowest Energy in Each Album

```sql
WITH energy_cte AS
(
    SELECT
        Album,
        MAX(Energy) AS highest_energy,
        MIN(Energy) AS lowest_energy
    FROM spotify
    GROUP BY Album
)

SELECT
    Album,
    highest_energy - lowest_energy AS energy_difference
FROM energy_cte
ORDER BY energy_difference DESC;
```

---

### 14. Tracks with Energy-to-Liveness Ratio Greater Than 1.2

```sql
WITH ratio_find AS
(
    SELECT
        Track,
        AVG(Energy) AS energy,
        AVG(Liveness) AS liveness
    FROM spotify
    GROUP BY Track
)

SELECT
    Track,
    energy,
    liveness,
    energy / liveness AS ratio
FROM ratio_find
WHERE energy / liveness > 1.2;
```

---

### 15. Cumulative Likes Based on Views

```sql
SELECT
    Track,
    Views,
    Likes,

    SUM(Likes) OVER
    (
        ORDER BY Views DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_likes

FROM spotify
ORDER BY Views DESC;
```

---

# 📚 SQL Concepts Used

- Database Creation
- Table Creation
- Data Import
- Data Cleaning
- NULL Handling
- Aggregate Functions
- GROUP BY
- ORDER BY
- DISTINCT
- CASE WHEN
- COALESCE()
- Common Table Expressions (CTEs)
- Window Functions
- DENSE_RANK()
- SUM() OVER()
- Conditional Aggregation
- DELETE Operations

---

# 🎯 Learning Outcomes

Through this project, I gained hands-on experience with:

- Importing large datasets into MySQL.
- Cleaning data during the loading process.
- Writing optimized SQL queries.
- Performing exploratory data analysis (EDA).
- Solving real-world business questions using SQL.
- Using CTEs and Window Functions for advanced analytics.
- Applying ranking and cumulative calculations.
- Building an end-to-end SQL analytics project.

---

