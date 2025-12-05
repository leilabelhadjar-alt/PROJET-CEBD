
CREATE VIEW LesAgesSportifs AS 
SELECT 
    num_adherent,
    nom_sportif,
    prenom_sportif,
    pays_sportif,
    categorie_sportif,
    date_sportif,
    (julianday(date_epreuve) - julianday(date_sportif)) / 365.25 AS age_sportif
FROM Sportifs 
JOIN AdherentEpreuves USING(num_adherent)
JOIN Epreuves USING(num_epreuve);


CREATE VIEW LesNbsEquipiers AS
SELECT 
    e.num_adherent AS numEquipe,
    COUNT(a.num_sportif) AS nbEquipiers
FROM Equipes e
LEFT JOIN AppartientA a ON e.num_adherent = a.num_equipe
GROUP BY e.num_adherent;



CREATE VIEW AgeMoyenEquipesOr AS
SELECT 
    e.num_adherent AS num_equipe,
    AVG(
        (julianday(ep.date_epreuve) - julianday(s.date_sportif)) / 365.25
    ) AS age_moyen
FROM ResultatG r
JOIN Epreuves ep ON ep.num_epreuve = r.num_epreuve
JOIN AppartientA a ON a.num_sportif = r.num_adherent
JOIN Equipes e ON e.num_adherent = a.num_equipe
JOIN Sportifs s ON s.num_adherent = r.num_adherent
WHERE r.medaille = 'or'
GROUP BY e.num_adherent;


CREATE VIEW ClassementPays AS
SELECT 
    s.pays_sportif AS pays,
    SUM(CASE WHEN r.medaille = 'or' THEN 1 ELSE 0 END) AS nbOr,
    SUM(CASE WHEN r.medaille = 'argent' THEN 1 ELSE 0 END) AS nbArgent,
    SUM(CASE WHEN r.medaille = 'bronze' THEN 1 ELSE 0 END) AS nbBronze
FROM ResultatG r
JOIN Sportifs s ON s.num_adherent = r.num_adherent
GROUP BY s.pays_sportif
ORDER BY nbOr DESC, nbArgent DESC, nbBronze DESC;
