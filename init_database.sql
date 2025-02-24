-- Création des types (ENUM)
CREATE TYPE moyen_transport AS ENUM ('metro', 'rer');
CREATE TYPE statut_dossier_client AS ENUM ('incomplet', 'validation', 'validé', 'rejeté');

-- Création des tables (si n'existe pas)
CREATE TABLE IF NOT EXISTS supports (
    id SERIAL PRIMARY KEY,
    identifiant VARCHAR(255) NOT NULL,
    date_achat TIMESTAMP NOT NULL
);

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

CREATE TABLE IF NOT EXISTS tarifications (
    id SERIAL PRIMARY KEY,
    nom TEXT NOT NULL,
    zone_min INT NOT NULL,
    zone_max INT NOT NULL,
    prix_centimes INT NOT NULL
);

CREATE TABLE IF NOT EXISTS adresses_client (
    id SERIAL PRIMARY KEY,
    ligne_1 TEXT NOT NULL,
    ligne_2 TEXT,
    ville CHARACTER(255),
    departement CHARACTER(255),
    code_postal CHARACTER(5),
    pays CHARACTER(255)
);

CREATE TABLE IF NOT EXISTS dossiers_client (
    id SERIAL PRIMARY KEY,
    prenoms TEXT,
    nom_famille TEXT,
    date_naissance DATE,
    id_adresse_residence INT,
    id_adresse_facturation INT,
    email CHARACTER(128),
    tel CHARACTER(15),
    iban CHARACTER(34),
    bic CHARACTER(11),
    date_creation TIMESTAMP NOT NULL,
    statut statut_dossier_client
);

CREATE TABLE IF NOT EXISTS abonnements (
    id SERIAL PRIMARY KEY,
    id_support INT,
    id_dossier INT,
    id_tarification INT,
    date_debut TIMESTAMP,
    date_fin TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS arrets (
    id SERIAL PRIMARY KEY,
    id_station INT NOT NULL,
    id_ligne INT NOT NULL
);

CREATE TABLE IF NOT EXISTS horaires (
    id SERIAL PRIMARY KEY,
    id_arret INT NOT NULL,
    horaire TIME NOT NULL
);

CREATE TABLE IF NOT EXISTS validations (
    id SERIAL PRIMARY KEY,
    id_support INT NOT NULL,
    id_station INT NOT NULL,
    date_heure_validation TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS tickets (
    id SERIAL PRIMARY KEY,
    id_support INT NOT NULL,
    date_achat TIMESTAMP NOT NULL,
    date_expiration TIMESTAMP NOT NULL,
    prix_unitaire_centimes INT NOT NULL,
    id_station INT,
    date_heure_validation TIMESTAMP
);
