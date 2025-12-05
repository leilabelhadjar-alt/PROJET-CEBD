CREATE TABLE IF NOT EXISTS Disciplines(
    nom_discipline  TEXT NOT NULL,
    CONSTRAINT pk_nom_di PRIMARY KEY (nom_discipline)
);

CREATE TABLE IF NOT EXISTS Epreuves(
    num_epreuve INTEGER NOT NULL,
    nom_epreuve TEXT NOT NULL,
    form_epreuve TEXT NOT NULL,
    categorie_epreuve TEXT NOT NULL,
    date_epreuve DATE,
    nom_discipline TEXT NOT NULL,
    CONSTRAINT pk_num_ep PRIMARY KEY(num_epreuve),
    CONSTRAINT fk_nom_di FOREIGN KEY (nom_discipline) REFERENCES Disciplines(nom_discipline),
    CONSTRAINT form_epreuve_enum CHECK (form_epreuve IN ('individuelle','couple','equipe')),
    CONSTRAINT categorie_epreuve_enum CHECK (categorie_epreuve IN ('feminine','masculine','mixte')),
    CONSTRAINT ck_ep_num_epreuve CHECK (num_epreuve > 0)
 
);

CREATE TABLE IF NOT EXISTS Adherent(
    num_adherent INTEGER NOT NULL,
    CONSTRAINT pk_num_par PRIMARY KEY (num_adherent),
    CONSTRAINT ck_adh_num_adherent CHECK (num_adherent > 0)

);

CREATE TABLE IF NOT EXISTS Sportifs(
    num_adherent INTEGER NOT NULL,
    nom_sportif TEXT NOT NULL,
    prenom_sportif TEXT NOT NULL,
    pays_sportif TEXT NOT NULL,
    categorie_sportif TEXT NOT NULL,
    date_sportif DATE ,
    CONSTRAINT pk_num_sp PRIMARY KEY (num_adherent),
    CONSTRAINT fk_sp_num_ad FOREIGN KEY (num_adherent) REFERENCES Adherent(num_adherent),
    CONSTRAINT range_sp_num_adherent CHECK (num_adherent BETWEEN 1000 AND 1500),
    CONSTRAINT categorie_sportif_enum CHECK (categorie_sportif IN ('feminine','masculine','mixte')),
    CONSTRAINT unique_nom_prenom UNIQUE (nom_sportif, prenom_sportif)


);

CREATE TABLE IF NOT EXISTS Equipes(
    num_adherent INTEGER NOT NULL,
    CONSTRAINT pk_num_eq PRIMARY KEY  (num_adherent),
    CONSTRAINT fk_eq_num_ad FOREIGN KEY (num_adherent) REFERENCES Adherent(num_adherent),
    CONSTRAINT ck_eq_num_adherent CHECK (num_adherent > 0),
    CONSTRAINT range_eq_num_adherent CHECK (num_adherent BETWEEN 1 AND 100)


);

CREATE TABLE IF NOT EXISTS AdherentEpreuves(
    num_adherent INTEGER NOT NULL,
    num_epreuve INTEGER NOT NULL,
    CONSTRAINT pk_num_ep_num_par PRIMARY KEY (num_epreuve, num_adherent),
    CONSTRAINT fk_adep_num_ep FOREIGN KEY (num_epreuve) REFERENCES Epreuves(num_epreuve),
    CONSTRAINT fk_adep_num_ad FOREIGN KEY (num_adherent) REFERENCES Adherent(num_adherent),
    CONSTRAINT ck_adeq_num_adherent CHECK (num_adherent > 0),
    CONSTRAINT ck_adeq_num_epreuve CHECK (num_epreuve > 0)

);

CREATE TABLE IF NOT EXISTS ResultatG(
    num_epreuve INTEGER NOT NULL,
    num_adherent INTEGER NOT NULL,
    medaille TEXT NOT NULL,
    CONSTRAINT pk_num_ep_num_par PRIMARY KEY (num_epreuve, num_adherent),
    CONSTRAINT fk_res_num_ep FOREIGN KEY (num_epreuve) REFERENCES Epreuves(num_epreuve),
    CONSTRAINT fk_res_num_ad FOREIGN KEY (num_adherent) REFERENCES Adherent(num_adherent),
    CONSTRAINT ck_res_num_epreuve CHECK (num_epreuve > 0),
    CONSTRAINT ck_res_num_adherent CHECK (num_adherent > 0),
    CONSTRAINT medaille_enum CHECK (medaille IN ('or','argent','bronze'))

);


CREATE TABLE AppartientA(
    num_sportif INTEGER NOT NULL,
    num_equipe INTEGER NOT NULL,
    PRIMARY KEY (num_sportif, num_equipe),
    FOREIGN KEY (num_sportif) REFERENCES Sportifs(num_adherent),
    FOREIGN KEY (num_equipe) REFERENCES Equipes(num_adherent),
    CONSTRAINT positive_num_sportif CHECK (num_sportif > 0),
    CONSTRAINT positive_num_equipe CHECK (num_equipe > 0)
);
