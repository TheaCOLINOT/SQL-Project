-- stations doubles
SELECT s.nom AS station FROM stations s JOIN arrets a ON s.id = a.id_station JOIN lignes l ON a.id_ligne = l.id WHERE l.type = 'metro' AND s.id IN (SELECT s2.id FROM stations s2 JOIN arrets a2 ON s2.id = a2.id_station JOIN lignes l2 ON a2.id_ligne = l2.id WHERE l2.type = 'rer') ORDER BY s.nom;

-- forfaits populaires
SELECT t.nom AS nom_forfait, COUNT(a.id) AS nb_abonnements FROM abonnements a JOIN tarifications t ON a.id_tarification = t.id WHERE a.date_fin > CURRENT_TIMESTAMP  AND a.date_debut <= CURRENT_TIMESTAMP GROUP BY t.nom ORDER BY nb_abonnements DESC LIMIT 3;

--capacité moyenne de chaque station
SELECT s.nom AS station, SUM(l.capacite_max) / COUNT(DISTINCT a.id_ligne) AS capacite_moy FROM stations s JOIN arrets a ON s.id = a.id_station JOIN lignes l ON a.id_ligne = l.id GROUP BY s.nom ORDER BY s.nom;

-- nombre d'abonnés par département
CREATE VIEW abonnes_par_departement AS SELECT ac.departement, ac.code_postal, COUNT(dc.id) AS nb_abonnes FROM dossiers_client dc JOIN adresses_client ac ON dc.id_adresse_residence = ac.id GROUP BY ac.departement, ac.code_postal ORDER BY ac.code_postal; SELECT * FROM abonnes_par_departement;

-- usagers par tranches d'âge
SELECT
    COUNT(CASE WHEN AGE(CURRENT_DATE, date_naissance) < INTERVAL '18 years' THEN 1 END) AS moins_18,
    COUNT(CASE WHEN AGE(CURRENT_DATE, date_naissance) BETWEEN INTERVAL '18 years' AND INTERVAL '24 years' THEN 1 END) AS "18_24",
    COUNT(CASE WHEN AGE(CURRENT_DATE, date_naissance) BETWEEN INTERVAL '25 years' AND INTERVAL '40 years' THEN 1 END) AS "25_40",
    COUNT(CASE WHEN AGE(CURRENT_DATE, date_naissance) BETWEEN INTERVAL '40 years' AND INTERVAL '60 years' THEN 1 END) AS "40_60",
    COUNT(CASE WHEN AGE(CURRENT_DATE, date_naissance) > INTERVAL '60 years' THEN 1 END) AS plus_60
FROM dossiers_client;

-- stations les plus fréquentées
CREATE OR REPLACE VIEW frequentation_stations AS SELECT s.nom AS station, COUNT(v.id) AS frequentation
FROM validations v
JOIN stations s ON v.id_station = s.id
GROUP BY s.nom
ORDER BY frequentation DESC
LIMIT 10;
