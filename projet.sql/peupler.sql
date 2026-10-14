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

INSERT INTO jeux (titre, annee_sortie, categorie_jeu, plateforme) VALUES
    ('Super Mario 64', 1996, 'Plateforme 3D', 'Nintendo 64'),
    ('The Legend of Zelda: Ocarina of Time', 1998, 'Action-Aventure', 'Nintendo 64'),
    ('Celeste', 2018, 'Plateforme 2D', 'PC'),
    ('Hollow Knight', 2017, 'Metroidvania', 'PC'),
    ('Elden Ring', 2022, 'Action-RPG', 'PlayStation 5');

INSERT INTO sanctions (joueur_id, motif, active) VALUES
    (10, 'Utilisation de cheats / macros interdites', true);

INSERT INTO temps (joueur_id, jeu_id, categorie_run, temps_ms, video_url, soumis_le)
SELECT 
    1 + (i % 9),

    1 + (i % 5),

    (ARRAY['Any%', '100%', 'Glitchless', 'Low%', 'Warpless'])[1 + (i % 5)],

    600000 + ((i * 37) % 4200000),

    'https://youtu.be/run_' || i,

    now() - ((i % 365) || ' days')::interval
FROM generate_series(1, 10000) AS i;