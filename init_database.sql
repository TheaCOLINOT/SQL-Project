-- Création des types (ENUM)
CREATE TYPE moyen_transport AS ENUM ('metro', 'rer');
CREATE TYPE statut_dossier_client AS ENUM ('incomplet', 'validation', 'validé', 'rejeté');


-- Création des tables (si n'existent pas déjà)
CREATE TABLE IF NOT EXISTS stations (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    zone INT NOT NULL
);

CREATE TABLE IF NOT EXISTS lignes (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(32) NOT NULL,
    type moyen_transport NOT NULL,
    capacite_max INT NOT NULL
);

CREATE TABLE IF NOT EXISTS arrets (
    id SERIAL PRIMARY KEY,
    id_station INT NOT NULL REFERENCES stations(id),
    id_ligne INT NOT NULL REFERENCES lignes(id)
);

CREATE TABLE IF NOT EXISTS horaires (
    id SERIAL PRIMARY KEY,
    id_arret INT NOT NULL REFERENCES arrets(id),
    horaire TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS supports (
    id SERIAL PRIMARY KEY,
    identifiant VARCHAR(12) NOT NULL,
    date_achat TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS adresses_client (
    id SERIAL PRIMARY KEY,
    ligne_1 TEXT NOT NULL,
    ligne_2 TEXT,
    ville VARCHAR(255),
    departement VARCHAR(255),
    code_postal VARCHAR(5),
    pays VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS tarifications (
    id SERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    zone_min INT NOT NULL,
    zone_max INT NOT NULL,
    prix_centimes INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dossiers_client (
    id SERIAL PRIMARY KEY,
    statut statut_dossier_client,
    prenoms TEXT,
    nom_famille TEXT,
    date_naissance DATE,
    id_adresse_residence INT REFERENCES adresses_client(id),
    id_adresse_facturation INT REFERENCES adresses_client(id),
    email VARCHAR(128),
    tel VARCHAR(15),
    iban VARCHAR(34),
    bic VARCHAR(11),
    date_creation TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS abonnements (
    id SERIAL PRIMARY KEY,
    id_support INT REFERENCES supports(id),
    id_dossier INT REFERENCES dossiers_client(id),
    id_tarification INT REFERENCES tarifications(id),
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS tickets (
    id SERIAL PRIMARY KEY,
    id_support INT NOT NULL REFERENCES supports(id),
    date_achat TIMESTAMP NOT NULL,
    date_expiration TIMESTAMP NOT NULL,
    prix_unitaire_centimes INT NOT NULL,
    id_station INT NOT NULL REFERENCES stations(id),
    date_heure_validation TIMESTAMP
);

CREATE TABLE IF NOT EXISTS validations (
    id SERIAL PRIMARY KEY,
    id_support INT NOT NULL REFERENCES supports(id),
    id_station INT NOT NULL REFERENCES stations(id),
    date_heure_validation TIMESTAMP NOT NULL
);
