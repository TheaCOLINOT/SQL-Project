-- nombre de dossiers incomplets
SELECT count(*) AS nb_dossiers_incomplets FROM dossiers_client WHERE statut = 'incomplet';

-- stations desservies par chaque ligne
SELECT lignes.nom AS lignes, stations.nom AS stations FROM lignes, stations ORDER BY lignes ASC;