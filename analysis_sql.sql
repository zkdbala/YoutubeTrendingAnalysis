
-- 1. Does the hour at which the video gets published have anything to do with the number of views and comment_count?

-- We can use temporary tables instead of CTEs in MySQL

DROP TEMPORARY TABLE IF EXISTS time_band_temp;
CREATE TEMPORARY TABLE time_band_temp AS
SELECT
    views,
    comment_count,
    CASE
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 0 AND 4 THEN 'Middle of the Night'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 5 AND 7 THEN 'Early Morning'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 8 AND 11 THEN 'Morning'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 17 AND 19 THEN 'Evening'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 20 AND 23 THEN 'Night'
        ELSE NULL
    END AS time_band
FROM clean_youtube_stats;

SELECT
    time_band,
    AVG(views) AS avg_views,
    AVG(comment_count) AS avg_comments
FROM time_band_temp
GROUP BY time_band
ORDER BY avg_views DESC;


-- 2. What category of videos are people liking or disliking?

SELECT
    category_title,
    SUM(likes) AS sum_likes,
    SUM(dislikes) AS sum_dislikes
FROM clean_youtube_stats
GROUP BY category_title
ORDER BY sum_likes DESC;


-- 3. What category of videos are people watching in different time bands?

-- Reusing the temporary table time_band_temp, we add the 'category_title' column.

DROP TEMPORARY TABLE IF EXISTS time_band_temp2;
CREATE TEMPORARY TABLE time_band_temp2 AS
SELECT
    views,
    comment_count,
    category_title,
    CASE
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 0 AND 4 THEN 'Middle of the Night'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 5 AND 7 THEN 'Early Morning'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 8 AND 11 THEN 'Morning'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 17 AND 19 THEN 'Evening'
        WHEN CAST(publishing_hour AS SIGNED) BETWEEN 20 AND 23 THEN 'Night'
        ELSE NULL
    END AS time_band
FROM clean_youtube_stats;

SELECT
    category_title,
    SUM(CASE WHEN time_band = 'Middle of the Night' THEN 1 ELSE 0 END) AS middle_of_the_night_count,
    SUM(CASE WHEN time_band = 'Early Morning' THEN 1 ELSE 0 END) AS early_morning_count,
    SUM(CASE WHEN time_band = 'Morning' THEN 1 ELSE 0 END) AS morning_count,
    SUM(CASE WHEN time_band = 'Afternoon' THEN 1 ELSE 0 END) AS afternoon_count,
    SUM(CASE WHEN time_band = 'Evening' THEN 1 ELSE 0 END) AS evening_count,
    SUM(CASE WHEN time_band = 'Night' THEN 1 ELSE 0 END) AS night_count
FROM time_band_temp2
GROUP BY category_title;


-- 4. How does disabling the comments and ratings affect the views and dislikes?

SELECT
    comments_disabled,
    SUM(views) AS views,
    SUM(dislikes) AS dislikes
FROM clean_youtube_stats
GROUP BY comments_disabled;

SELECT
    ratings_disabled,
    SUM(views) AS views,
    SUM(dislikes) AS dislikes
FROM clean_youtube_stats
GROUP BY ratings_disabled;


-- 5. How many videos have encountered an error or have been removed per region?

SELECT
    region,
    SUM(video_error_or_removed) AS faulty_videos
FROM clean_youtube_stats
GROUP BY region
ORDER BY region;

-- 6. Amount of Days taken for videos to get trending per category?

DROP TEMPORARY TABLE IF EXISTS days_to_trending;
CREATE TEMPORARY TABLE days_to_trending AS
SELECT 
    CASE 
        WHEN DATEDIFF(CONCAT(trending_publishing_year, '-', trending_month, '-', trending_day), CONCAT(trending_publishing_year, '-', publishing_month, '-', publishing_day)) < 0
            THEN DATEDIFF(CONCAT(trending_publishing_year, '-', trending_month, '-', trending_day), CONCAT(trending_publishing_year, '-', publishing_month, '-', publishing_day)) + 365
        ELSE
            DATEDIFF(CONCAT(trending_publishing_year, '-', trending_month, '-', trending_day), CONCAT(trending_publishing_year, '-', publishing_month, '-', publishing_day))
    END AS required_days_to_trending,
    region,
    category_title
FROM clean_youtube_stats;

SELECT
    category_title,
    AVG(required_days_to_trending) AS avg_days
FROM days_to_trending
GROUP BY category_title;
