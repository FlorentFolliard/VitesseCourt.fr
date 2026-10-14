CREATE ROLE speedrun_moderateur;
CREATE ROLE speedrun_visiteur;

CREATE OR REPLACE VIEW vue_moderation AS
SELECT 
    t.id AS run_id,
    j.pseudo,
    g.titre AS jeu,
    t.categorie_run,
    t.temps_ms,
    t.video_url,
    t.soumis_le
FROM temps t
JOIN joueurs j ON j.id = t.joueur_id
JOIN jeux g ON g.id = t.jeu_id;

CREATE OR REPLACE VIEW vue_leaderboard_public AS
SELECT 
    g.titre AS jeu,
    t.categorie_run,
    j.pseudo,
    t.temps_ms,
    t.soumis_le
FROM temps t
JOIN joueurs j ON j.id = t.joueur_id
JOIN jeux g ON g.id = t.jeu_id;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM speedrun_moderateur, speedrun_visiteur;
GRANT SELECT ON vue_moderation TO speedrun_moderateur;
GRANT SELECT ON vue_leaderboard_public TO speedrun_visiteur;


CREATE INDEX idx_temps_jeu ON temps (jeu_id);
CREATE INDEX idx_temps_jeu_chrono ON temps (jeu_id, temps_ms ASC)