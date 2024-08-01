CREATE TABLE EDUCATIONAL_PORTAL.PUBLIC.users (
 	usuario_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password TEXT NOT NULL, -- Armazene hashes de senha, não senhas em texto plano.
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE EDUCATIONAL_PORTAL.PUBLIC.categories (
	categoria_id SERIAL PRIMARY KEY,
	name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE EDUCATIONAL_PORTAL.PUBLIC.resources (
	resource_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    publish_date DATE,
    author VARCHAR(255),
    archive BYTEA,
    categoria_id INTEGER REFERENCES public.categories(categoria_id),
    date_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE EDUCATIONAL_PORTAL.PUBLIC.metadata (
	metadata_id SERIAL PRIMARY KEY,
	resource_id INTEGER REFERENCES resources(resource_id),
	KEY VARCHAR(255),
	VALUE TEXT
);

CREATE TABLE EDUCATIONAL_PORTAL.PUBLIC.access_history (
	acess_id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES EDUCATIONAL_PORTAL.PUBLIC.users(usuario_id),
	resource_id INTEGER REFERENCES EDUCATIONAL_PORTAL.PUBLIC.resources(resource_id),
	date_access TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO EDUCATIONAL_PORTAL.public.categories (name) VALUES ('Ciência'), ('Tecnologia'), ('Humanidades'), ('Matemática');

INSERT INTO EDUCATIONAL_PORTAL.public.resources (title, description, publish_date, author, archive, categoria_id) 
VALUES 
('Estudo sobre Física Quântica', 'Uma pesquisa detalhada sobre os princípios da física quântica.', '2024-07-01', 'Dr. João Silva', NULL, 1),
('Introdução à Programação em Python', 'Material didático para iniciantes em Python.', '2024-06-15', 'Prof. Ana Costa', NULL, 2),
('História da Filosofia', 'Uma análise das principais correntes filosóficas ao longo da história.', '2024-05-20', 'Dr. Roberto Lima', NULL, 3),
('Teoria dos Números', 'Um estudo aprofundado sobre teoria dos números.', '2024-04-10', 'Prof. Maria Oliveira', NULL, 4);

INSERT INTO EDUCATIONAL_PORTAL.public.metadata (resource_id, key, value) 
VALUES 
(1, 'Tipo', 'Artigo'),
(2, 'Formato', 'PDF'),
(3, 'Idioma', 'Português'),
(4, 'Nível', 'Avançado');

INSERT INTO EDUCATIONAL_PORTAL.public.ACCESS_HISTORY  (acess_id , RESOURCE_ID) 
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO EDUCATIONAL_PORTAL.public.users (name, email, password) 
VALUES 
('Carlos Almeida', 'carlos@dominio.com', 'senhaHash1'),
('Laura Pereira', 'laura@dominio.com', 'senhaHash2'),
('Pedro Santos', 'pedro@dominio.com', 'senhaHash3'),
('Fernanda Silva', 'fernanda@dominio.com', 'senhaHash4');


-- Visualize todo os recursos com seus metadados
SELECT r.resource_id, r.title, r.description, r.publish_date, r.author, r.archive, c.name AS category, m.key, m.value
FROM public.resources r
JOIN public.categories c ON r.CATEGORIA_ID  = c.CATEGORIA_ID
LEFT JOIN public.METADATA m ON r.resource_id = m.resource_id;


-- Visualize todos os recursos por categoria
SELECT r.resource_id, r.title, r.description, r.publish_date, r.author
FROM public.resources r
JOIN public.categories c ON r.category_id = c.category_id
WHERE c.name = 'Ciência';

SELECT u.name AS usuario, r.title AS recurso, ha.DATE_ACCESS 
FROM public.ACCESS_HISTORY ha
JOIN public.users u ON ha.user_id = u.usuario_id
JOIN public.resources r ON ha.resource_id = r.resource_id
ORDER BY u.name, ha.DATE_ACCESS;

