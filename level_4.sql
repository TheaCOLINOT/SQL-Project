-- parts des passagers ayant un abonnement, contre ceux voyageant avec des tickets (supports)
SELECT 
    ROUND((COUNT(DISTINCT id_abonnement) * 100.0 / COUNT(DISTINCT id_support)), 2) AS part_abonnement, 
    ROUND((COUNT(DISTINCT id_ticket) * 100.0 / COUNT(DISTINCT id_support)), 2) AS part_ticket
FROM supports;

-- nombre de nouveaux abonnements par mois en 2024
SELECT 
    TO_CHAR(date_debut, 'Month') AS mois, 
    COUNT(*) AS nb_nvx_abo
FROM abonnements
WHERE EXTRACT(YEAR FROM date_debut) = 2024
AND id_support NOT IN (SELECT DISTINCT id_support FROM abonnements WHERE date_debut < '2024-01-01')
GROUP BY mois
ORDER BY TO_DATE(mois, 'Month');

-- montant total économisé par les usagers ayant un abonnement s'ils avaient dû acheter un ticket
SELECT 
    ROUND(SUM(GREATEST(0, (v.nb_validations * t.prix) - a.prix_mensuel)), 2) AS montant_economise_euros
FROM abonnements a
JOIN validations v ON a.id = v.id_abonnement
JOIN tickets t ON v.id_ticket = t.id;

-- heure la plus affluante par station
CREATE VIEW heure_affluence_station AS
SELECT 
    s.nom AS nom_station, 
    TO_CHAR(v.date_validation, 'HH24:MI') AS heure_affluante, 
    COUNT(*) AS nb_validations
FROM validations v
JOIN stations s ON v.id_station = s.id
GROUP BY s.nom, heure_affluante
ORDER BY nb_validations DESC;

-- nombre d'abonnements actifs par tranche de zone
CREATE VIEW abonnements_par_zone AS
SELECT 
    a.zone_min, 
    a.zone_max, 
    COUNT(*) AS nb_abonnements
FROM abonnements a
WHERE a.date_fin > NOW()
GROUP BY a.zone_min, a.zone_max
ORDER BY nb_abonnements DESC, a.zone_min, a.zone_max;