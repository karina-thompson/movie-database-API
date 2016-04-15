CREATE TABLE movies (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(200),
  rated VARCHAR(6),
  genre VARCHAR(100),
  writer VARCHAR(100),
  director VARCHAR(100),
  year INTEGER,
  runtime VARCHAR(10),
  actors VARCHAR(500),
  poster_url VARCHAR(200),
  plot VARCHAR(800),
  country VARCHAR(200)
);

