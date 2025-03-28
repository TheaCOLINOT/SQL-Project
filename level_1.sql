-- nombre de dossiers incomplets
SELECT COUNT(*) AS nb_dossiers_incomplets 
FROM dossiers_client 
WHERE statut = 'incomplet';

-- stations desservies par chaque ligne
SELECT l.nom AS ligne, s.nom AS station 
FROM lignes l
JOIN arrets a ON l.id = a.id_ligne
JOIN stations s ON a.id_station = s.id
ORDER BY l.nom ASC, s.nom ASC;

-- nombre de stations par moyen de transport
SELECT l.type AS moyen_transport, 
       COUNT(DISTINCT a.id_station) AS nb_stations 
FROM arrets a
JOIN lignes l ON a.id_ligne = l.id
GROUP BY l.type
ORDER BY nb_stations DESC;

-- abonnements qui expirent à la fin de janvier 2025
SELECT t.nom AS nom_tarification, 
       COUNT(a.id) AS nb_abonnements 
FROM abonnements a
JOIN tarifications t ON a.id_tarification = t.id
WHERE a.date_fin BETWEEN '2025-01-01' AND '2025-01-31 23:59:59'
GROUP BY t.nom
ORDER BY nb_abonnements ASC;

-- dossiers_en_validation
CREATE VIEW dossiers_en_validation AS 
SELECT * 
FROM dossiers_client 
WHERE statut = 'validation' 
ORDER BY date_creation ASC;
SELECT * FROM dossiers_en_validation;
