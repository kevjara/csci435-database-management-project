DROP DATABASE IF EXISTS social;

CREATE DATABASE social;

USE social;

-- Relation Creation

CREATE TABLE User(
	user_id INTEGER PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    password VARCHAR (50),
    date_joined VARCHAR(50),
    location VARCHAR(100),
    privacy_setting enum('Public', 'Private') DEFAULT 'Public'
);

CREATE TABLE Post(
	post_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    media VARCHAR(255),
    created_at DATETIME,
    location_tag VARCHAR(100),
    privacy_setting enum('Public', 'Private') DEFAULT 'Public',
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Comment(
	comment_id INTEGER PRIMARY KEY,
    post_id INTEGER,
    user_id INTEGER,
    comment VARCHAR(255),
    FOREIGN KEY (post_id) REFERENCES Post(post_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Friend (
	friendship_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    friend_id INTEGER,
    request_status enum('Accepted','Rejected','Pending') DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (friend_id) REFERENCES User(user_id),
    UNIQUE (user_id, friend_id)
);

CREATE TABLE Message (
	message_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    receiver_id INTEGER,
    message VARCHAR(255),
    timestamp DATETIME,
    message_status enum('Unread','Read') DEFAULT 'Unread',
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (receiver_id) REFERENCES User(user_id),
    UNIQUE (user_id, receiver_id)
);

CREATE TABLE Likes (
	like_id INTEGER PRIMARY KEY,
    liked BOOLEAN,
    user_id INTEGER,
    post_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (post_id) REFERENCES Post(post_id)
);

CREATE TABLE Notification (
	notification_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    notification VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Community (
	community_id INTEGER PRIMARY KEY,
    community_name VARCHAR(255),
	privacy_setting enum('Public', 'Private') DEFAULT 'Public'
);

CREATE TABLE Membership (
	membership_id INTEGER PRIMARY KEY,
    community_id INTEGER,
    user_id INTEGER,
    role VARCHAR(50),
    FOREIGN KEY (community_id) REFERENCES Community(community_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

CREATE TABLE Follow (
	follow_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    following_id INTEGER,
    is_following BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (following_id) REFERENCES User(user_id),
    UNIQUE (user_id, following_id)
);

-- Populating the relations

INSERT INTO User (user_id, username, email, password, date_joined, location, privacy_setting)
VALUES 
(1, 'MichealDouglas', 'micheal.douglas@gmail.com', 'password', '2015-12-09', 'New Jersey, USA', 'Public'),
(2, 'MichealJordan', 'MJ@gmail.com', '123456789', '2020-09-09', 'New York, USA', 'Private'),
(3, 'MichealJackson', 'jackson@gmail.com', 'jackson5', '2024-11-04', 'Indiana, USA', 'Public');


INSERT INTO Post (post_id, user_id, media, timestamp, location_tag, privacy_setting)
VALUES 
(1, 1, 'photo1.jpg', '2024-11-01 13:00:00', 'Paris, France', 'Public'),
(2, 2, 'video1.mp4', '2024-11-02 00:30:00', 'Santa Monica Beach, California', 'Private'),
(3, 1, 'photo2.jpg', '2024-11-03 08:45:00', 'Times Square, New York', 'Public');

INSERT INTO Comment (comment_id, post_id, user_id, comment)
VALUES 
(1, 1, 2, 'Nice!'),
(2, 1, 3, 'Looks great'),
(3, 2, 1, 'Very cool');

INSERT INTO Friend (friendship_id, user_id, friend_id, request_status)
VALUES 
(1, 1, 2, 'Accepted'),
(2, 2, 3, 'Pending'),
(3, 1, 3, 'Rejected');

INSERT INTO Message (message_id, user_id, receiver_id, message, timestamp, message_status)
VALUES  
(1, 1, 2, 'Yo', '2023-11-01 12:00:00', 'Read'),
(2, 2, 1, 'Whats up brother', '2023-11-01 12:05:00', 'Read'),
(3, 3, 1, 'Good morning!', '2024-12-09 09:00:00', 'Unread');

INSERT INTO Likes (like_id, liked, user_id, post_id)
VALUES 
(1, TRUE, 2, 1),
(2, TRUE, 3, 1),
(3, TRUE, 1, 2);

INSERT INTO Notification (notification_id, user_id, notification)
VALUES 
(1, 1, 'MichealJackson liked your post.'),
(2, 2, 'You have a new friend request.'),
(3, 3, 'MichealJordan commented on your post.');

INSERT INTO Community (community_id, community_name, privacy_setting)
VALUES 
(1, 'SAG AFTRA', 'Public'),
(2, 'Music', 'Private');

INSERT INTO Membership (membership_id, community_id, user_id, role)
VALUES 
(1, 1, 1, 'admin'),
(2, 1, 2, 'member'),
(3, 2, 3, 'member');

INSERT INTO Follow (follow_id, user_id, following_id, is_following)
VALUES 
(1, 1, 2, TRUE),
(2, 2, 3, TRUE),
(3, 3, 1, TRUE);

-- Queries

SELECT * FROM User
WHERE username = 'MichealJackson';

SELECT * FROM Post
WHERE user_id = 1;

SELECT comment FROM Comment
WHERE post_id = 1;

SELECT COUNT(*) FROM Likes
WHERE post_id = 1 AND liked = TRUE;

SELECT User.username FROM Friend
JOIN User ON Friend.friend_id = User.user_id
WHERE friend.user_id = 1 AND friend.request_status = 'Accepted';

SELECT message FROM Message
WHERE user_id = 1 AND message_status = 'Unread';

SELECT notification FROM Notification
WHERE user_id = 1;

SELECT User.username FROM Membership
JOIN User ON User.user_id = Membership.user_id
WHERE community_id = 1;

SELECT Post.post_id FROM Post
JOIN Likes ON Likes.post_id = Post.post_id
WHERE Likes.liked = TRUE 
GROUP BY Post.post_id HAVING COUNT(Likes.like_id) > 1;

SELECT * FROM Post
WHERE location_tag = 'Times Square, New York';
