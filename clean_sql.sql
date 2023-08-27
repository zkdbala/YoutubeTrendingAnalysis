
-- Display first 10 records
SELECT *
FROM youtube_stats
LIMIT 10;

-- Date Cleaning and Transformation

-- Extracting trending_day from trending_date
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(trending_date, '.', 2), '.', -1)
FROM youtube_stats
GROUP BY SUBSTRING_INDEX(SUBSTRING_INDEX(trending_date, '.', 2), '.', -1);

-- Extracting trending_month from trending_date
SELECT SUBSTRING_INDEX(trending_date, '.', -1)
FROM youtube_stats
GROUP BY SUBSTRING_INDEX(trending_date, '.', -1);

-- Extracting publishing_year (which is also used for trending_year)
SELECT SUBSTRING_INDEX(publish_time, '-', 1)
FROM youtube_stats;

-- Extracting publishing_month from publish_time
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, '-', 2), '-', -1)
FROM youtube_stats;

-- Extracting publishing_day from publish_time
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, 'T', 1), '-', -1)
FROM youtube_stats;

-- Extracting publishing_hour from publish_time
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, 'T', -1), ':', 1), ':', 1)
FROM youtube_stats;

-- Extracting publishing_minute from publish_time
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, ':', 2), ':', -1), '.', 1)
FROM youtube_stats;

-- Extracting publishing_second from publish_time
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, '.', 1), ':', -1)
FROM youtube_stats;

-- Region Transformation
SELECT 
	CASE
		WHEN region = 'CA' THEN 'Canada'
		WHEN region = 'US' THEN 'United States'
		WHEN region = 'GB' THEN 'Great Britain'
		WHEN region = 'DE' THEN 'Germany'
		WHEN region = 'FR' THEN 'France'
		WHEN region = 'RU' THEN 'Russia'
		WHEN region = 'MX' THEN 'Mexico'
		WHEN region = 'KR' THEN 'South Korea'
		WHEN region = 'JP' THEN 'Japan'
		WHEN region = 'IN' THEN 'India'
		ELSE NULL
	END AS region
FROM youtube_stats;

-- Inserting cleaned data into clean_youtube_stats table
CREATE TABLE clean_youtube_stats AS
SELECT 
    video_id,
    SUBSTRING_INDEX(publish_time, '-', 1) AS trending_publishing_year,
    SUBSTRING_INDEX(SUBSTRING_INDEX(trending_date, '.', 2), '.', -1) AS trending_day,
    SUBSTRING_INDEX(trending_date, '.', -1) AS trending_month,
    SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, '-', 2), '-', -1) AS publishing_month,
    SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, 'T', 1), '-', -1) AS publishing_day,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, 'T', -1), ':', 1), ':', 1) AS publishing_hour,
    SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, ':', 2), ':', -1), '.', 1) AS publishing_minute,
    SUBSTRING_INDEX(SUBSTRING_INDEX(publish_time, '.', 1), ':', -1) AS publishing_second,
    channel_title, 
    category_id, 
    views, 
    likes, 
    dislikes, 
    comment_count, 
    comments_disabled, 
    ratings_disabled, 
    video_error_or_removed, 
    CASE
        WHEN region = 'CA' THEN 'Canada'
        WHEN region = 'US' THEN 'United States'
        WHEN region = 'GB' THEN 'Great Britain'
        WHEN region = 'DE' THEN 'Germany'
        WHEN region = 'FR' THEN 'France'
        WHEN region = 'RU' THEN 'Russia'
        WHEN region = 'MX' THEN 'Mexico'
        WHEN region = 'KR' THEN 'South Korea'
        WHEN region = 'JP' THEN 'Japan'
        WHEN region = 'IN' THEN 'India'
        ELSE NULL
    END AS region,
    category_title
FROM youtube_stats;

-- Display first 10 records from clean_youtube_stats
SELECT *
FROM clean_youtube_stats
LIMIT 10;
