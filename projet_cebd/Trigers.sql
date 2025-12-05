
--Empêcher un sportif de participer à une épreuve incompatible avec son sexe
CREATE TRIGGER verif_categorie_sportif_epreuve
BEFORE INSERT ON AdherentEpreuves
FOR EACH ROW
BEGIN
    SELECT
        CASE
            WHEN (
                (SELECT categorie_epreuve 
                 FROM Epreuves 
                 WHERE num_epreuve = NEW.num_epreuve) 
                IN ('masculine', 'feminine')
                AND
                (SELECT categorie_sportif
                 FROM Sportifs 
                 WHERE num_adherent = NEW.num_adherent)
                != (
                    SELECT categorie_epreuve 
                    FROM Epreuves 
                    WHERE num_epreuve = NEW.num_epreuve
                )
            )
            THEN RAISE(ABORT, 'Catégorie incompatible avec le sportif')
        END;
END;

--Empêcher qu’un sportif gagne plusieurs médailles dans la même épreuve
CREATE TRIGGER verif_medaille_unique
BEFORE INSERT ON ResultatG
FOR EACH ROW
BEGIN
    SELECT
        CASE
            WHEN (
                SELECT COUNT(*)
                FROM ResultatG
                WHERE num_epreuve = NEW.num_epreuve
                  AND num_adherent = NEW.num_adherent
            ) > 0
            THEN RAISE(ABORT,'Un sportif ne peut pas gagner deux médailles dans la même épreuve')
        END;
END;

--Interdire les ex-æquo
CREATE TRIGGER verif_pas_exaequo
BEFORE INSERT ON ResultatG
FOR EACH ROW
BEGIN
    SELECT
        CASE
            WHEN (
                SELECT COUNT(*)
                FROM ResultatG
                WHERE num_epreuve = NEW.num_epreuve
                  AND medaille = NEW.medaille
            ) > 0
            THEN RAISE(ABORT, 'Pas d’ex-aequo : cette médaille est déjà attribuée pour cette épreuve')
        END;
END;


--Empêcher une épreuve d’avoir plus de 3 médailles attribuées
CREATE TRIGGER verif_max_3_medailles
BEFORE INSERT ON ResultatG
FOR EACH ROW
BEGIN
    SELECT
        CASE 
            WHEN (
                SELECT COUNT(*)
                FROM ResultatG
                WHERE num_epreuve = NEW.num_epreuve
            ) >= 3
            THEN RAISE(ABORT,'Cette épreuve a déjà 3 médailles attribuées')
        END;
END;

