-- 1. Quelques joueurs de base (10 joueurs)
INSERT INTO joueurs (pseudo, pays) VALUES
    ('ShadowRunner', 'FR'),
    ('SpeedyGonzales', 'MX'),
    ('GlitchMaster', 'US'),
    ('RetroGamer', 'JP'),
    ('FastestAlive', 'DE'),
    ('PixelHero', 'CA'),
    ('NoClipGuy', 'UK'),
    ('TasBot', 'US'),
    ('MarioSpeed', 'IT'),
    ('ZeldaRunner', 'FR');

-- 2. Quelques jeux de base (5 jeux)
INSERT INTO jeux (titre, annee_sortie, categorie_jeu, plateforme) VALUES
    ('Super Mario 64', 1996, 'Plateforme 3D', 'Nintendo 64'),
    ('The Legend of Zelda: Ocarina of Time', 1998, 'Action-Aventure', 'Nintendo 64'),
    ('Celeste', 2018, 'Plateforme 2D', 'PC'),
    ('Hollow Knight', 2017, 'Metroidvania', 'PC'),
    ('Elden Ring', 2022, 'Action-RPG', 'PlayStation 5');

-- 3. Un joueur sanctionné pour vos futurs tests de trigger
-- (Le joueur 10 "ZeldaRunner" a une sanction active)
INSERT INTO sanctions (joueur_id, motif, active) VALUES
    (10, 'Utilisation de cheats / macros interdites', true);

-- 4. Génération automatique de 10 000 runs dans la table 'temps'
INSERT INTO temps (joueur_id, jeu_id, categorie_run, temps_ms, video_url, soumis_le)
SELECT 
    -- Joueur ID entre 1 et 9 (on exclut le joueur 10 pour ne pas déclencher le trigger lors de l'init)
    1 + (i % 9),

    -- Jeu ID entre 1 et 5
    1 + (i % 5),

    -- Une catégorie parmi la liste
    (ARRAY['Any%', '100%', 'Glitchless', 'Low%', 'Warpless'])[1 + (i % 5)],

    -- Durée déterministe entre ~10 min et ~1h20
    600000 + ((i * 37) % 4200000),

    'https://youtu.be/run_' || i,

    now() - ((i % 365) || ' days')::interval
FROM generate_series(1, 10000) AS i;