CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "Brooklyn NYC"), (2, "Queens NYC");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Qin", "Zhu", 1),
  (2, "Joe", "Shmoe", 1),
  (3, "John", "Smith", 2);


INSERT INTO
  dogs (id, name, owner_id)
VALUES
  (1, "Roger", 1),
  (2, "Buddy", 2),
  (3, "Ruby", 3),
  (4, "Biscuit", 3),
  (5, "Ownerless", NULL);
