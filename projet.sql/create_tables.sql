DROP TABLE IF EXISTS temps CASCADE;
DROP TABLE IF EXISTS sanctions CASCADE;
DROP TABLE IF EXISTS jeux CASCADE;
DROP TABLE IF EXISTS joueurs CASCADE;

CREATE TABLE joueurs (
    id          serial PRIMARY KEY,
    pseudo      text NOT NULL UNIQUE,
    pays      text NOT NULL
);

CREATE TABLE jeux (
    id            serial PRIMARY KEY,
    titre         text NOT NULL UNIQUE,
    annee_sortie  integer NOT NULL CHECK (annee_sortie >= 1970),
    categorie_jeu text NOT NULL,
    plateforme text NOT NULL
);

CREATE TABLE sanctions (
    id          serial PRIMARY KEY,
    joueur_id   integer NOT NULL REFERENCES joueurs(id) ON DELETE CASCADE,
    motif       text NOT NULL,
    active      boolean NOT NULL DEFAULT true
);

CREATE TABLE temps (
    id              bigserial PRIMARY KEY,
    joueur_id       integer NOT NULL REFERENCES joueurs(id) ON DELETE CASCADE,
    jeu_id          integer NOT NULL REFERENCES jeux(id) ON DELETE CASCADE,
    categorie_run       text NOT NULL,
    temps_ms        integer NOT NULL CHECK (temps_ms > 0),
    video_url       text,
    soumis_le       timestamp NOT NULL DEFAULT now()
);