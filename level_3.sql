-- chiffre d'affaires des ventes de tickets par mois sur l'année 2024
SELECT 
    TO_CHAR(date_achat, 'Month') AS mois, 
    SUM(prix) AS chiffre_affaires
FROM tickets
WHERE EXTRACT(YEAR FROM date_achat) = 2024
GROUP BY mois
ORDER BY TO_DATE(mois, 'Month');

-- lignes de transports à Nation à 172816 +- 4 minutes
SELECT DISTINCT l.nom_ligne, t.heure_passage
FROM trajets t
JOIN stations s ON t.id_station = s.id
JOIN lignes l ON t.id_ligne = l.id
WHERE s.nom = 'Nation'
AND t.heure_passage BETWEEN '17:24:16' AND '17:32:16'
ORDER BY t.heure_passage;

-- nombre moyen de validation par mois par type d’abonnement
SELECT 
    a.nom_tarification AS abonnement, 
    ROUND(AVG(COUNT(v.id)) OVER (PARTITION BY a.nom_tarification)) AS moy_validation
FROM validations v
JOIN abonnements a ON v.id_abonnement = a.id
WHERE EXTRACT(YEAR FROM v.date_validation) = 2024
GROUP BY a.nom_tarification
ORDER BY moy_validation DESC, abonnement ASC;

-- moyenne des passages par jour de la semaine sur les 12 derniers mois
CREATE VIEW moy_passagers_par_jour AS
SELECT 
    TO_CHAR(date_validation, 'Day') AS jour_semaine, 
    ROUND(AVG(COUNT(v.id)) OVER (PARTITION BY TO_CHAR(date_validation, 'Day'))) AS moy_passagers
FROM validations v
WHERE date_validation >= NOW() - INTERVAL '12 months'
GROUP BY jour_semaine
ORDER BY jour_semaine;

-- taux de remplissage moyen des lignes
CREATE VIEW taux_remplissage_lignes AS
WITH train_par_jour AS (
    SELECT id_ligne, 
           CASE 
               WHEN moyen_transport = 'metro' THEN 19 * 10  -- Un métro toutes les 6 min entre 5h00 et 1h30
               WHEN moyen_transport = 'rer' THEN 19 * 4  -- Un RER toutes les 15 min entre 5h00 et 1h30
           END AS nb_trains
    FROM lignes
)
SELECT 
    l.nom_ligne, 
    ROUND(AVG(v.nb_passagers) / t.nb_trains / l.capacite_max * 100, 2) AS taux_remplissage
FROM lignes l
JOIN train_par_jour t ON l.id = t.id_ligne
JOIN validations v ON l.id = v.id_ligne
GROUP BY l.nom_ligne, t.nb_trains, l.capacite_max
ORDER BY taux_remplissage DESC;