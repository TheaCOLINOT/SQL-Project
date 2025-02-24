-- Ajout des contraintes de clé étrangère
ALTER TABLE dossiers_client
    ADD CONSTRAINT fk_dossiers_client_adresse_residence FOREIGN KEY (id_adresse_residence) REFERENCES adresses_client(id),
    ADD CONSTRAINT fk_dossiers_client_adresse_facturation FOREIGN KEY (id_adresse_facturation) REFERENCES adresses_client(id);

ALTER TABLE abonnements
    ADD CONSTRAINT fk_abonnements_support FOREIGN KEY (id_support) REFERENCES supports(id),
    ADD CONSTRAINT fk_abonnements_dossier FOREIGN KEY (id_dossier) REFERENCES dossiers_client(id),
    ADD CONSTRAINT fk_abonnements_tarification FOREIGN KEY (id_tarification) REFERENCES tarifications(id);

ALTER TABLE arrets
    ADD CONSTRAINT fk_arrets_station FOREIGN KEY (id_station) REFERENCES stations(id),
    ADD CONSTRAINT fk_arrets_ligne FOREIGN KEY (id_ligne) REFERENCES lignes(id);

ALTER TABLE horaires
    ADD CONSTRAINT fk_horaires_arret FOREIGN KEY (id_arret) REFERENCES arrets(id);

ALTER TABLE validations
    ADD CONSTRAINT fk_validations_support FOREIGN KEY (id_support) REFERENCES supports(id),
    ADD CONSTRAINT fk_validations_station FOREIGN KEY (id_station) REFERENCES stations(id);

ALTER TABLE tickets
    ADD CONSTRAINT fk_tickets_support FOREIGN KEY (id_support) REFERENCES supports(id),
    ADD CONSTRAINT fk_tickets_station FOREIGN KEY (id_station) REFERENCES stations(id);
