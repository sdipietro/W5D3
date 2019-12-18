PRAGMA foreign_keys = ON;

--how does the order work here?
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_id INTEGER, -- do we have to put a possibly null value at the end?
    --does ordering matter? for lines 34 to 37
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- Seeding the users table;
INSERT INTO
    users (fname, lname)
VALUES
    ('Stephen', 'DiPietro'), 
    ('Albert', 'Lee');

-- Seeding the questions table
INSERT INTO
    questions (title, body, user_id)
VALUES
    ('Weather?', 'How''s the weather?', (SELECT id FROM users WHERE fname = 'Stephen' AND lname = 'DiPietro')),
    ('Temperature?', 'What''s the temperature?', (SELECT id FROM users WHERE fname = 'Albert' AND lname = 'Lee')),
    ('Greeting?', 'How are you?', (SELECT id FROM users WHERE fname = 'Albert' AND lname = 'Lee'));

-- Seeding the question_folllows table
INSERT INTO
    question_follows (question_id, user_id)
VALUES
    (1, 1),
    (1, 2);

-- Seeding the replies table
INSERT INTO
    replies (body, question_id, user_id, parent_id)
VALUES
    ('The weather is good', 1, 2, NULL),
    ('Are you crazy the weather is terrible', 1, 2, 1),
    ('The temperature is 70 degrees', 2, 2, NULL);

-- Seeding the question_likes table
INSERT INTO
    question_likes (user_id, question_id)
VALUES
    (1, 1),
    (2, 1);