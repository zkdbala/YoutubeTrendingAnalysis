USE YouTubeAPI;

DROP TABLE IF EXISTS youtube_stats;
CREATE TABLE youtube_stats(
	video_id VARCHAR(255),
	trending_date VARCHAR(255), 
	channel_title VARCHAR(255),
	category_id INT, 
	publish_time VARCHAR(255),
	views INT,
	likes INT, 
	dislikes INT, 
	comment_count INT,
	comments_disabled BOOLEAN,
	ratings_disabled BOOLEAN,
	video_error_or_removed BOOLEAN,
	region VARCHAR(255),
	category_title VARCHAR(255)
);
