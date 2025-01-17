CREATE TABLE Aluno (
    CPF VARCHAR,
    Estado VARCHAR,
    Idade INT,
    PCD VARCHAR,
    Sexo CHAR,
    Raca VARCHAR,
    Num_ID INT PRIMARY KEY
);

CREATE TABLE Bolsa (
    ID INT PRIMARY KEY,
    Tipo VARCHAR,
    fk_Universidade_Codigo_EMEC_IES INT
);

CREATE TABLE Universidade (
    Codigo_EMEC_IES INT PRIMARY KEY,
    Nome VARCHAR
);

CREATE TABLE Curso (
    Nome VARCHAR,
    Modalidade VARCHAR,
    Turno VARCHAR,
    fk_Universidade_Codigo_EMEC_IES INT,
    PRIMARY KEY (Nome, fk_Universidade_Codigo_EMEC_IES)
);

CREATE TABLE Estuda (
    fk_Curso_Nome VARCHAR,
    fk_Aluno_Num_ID INT,
    Ano_concessao YEAR
);
 
ALTER TABLE Bolsa ADD CONSTRAINT FK_Bolsa_2
    FOREIGN KEY (fk_Universidade_Codigo_EMEC_IES)
    REFERENCES Universidade (Codigo_EMEC_IES)
    ON DELETE SET NULL;
 
ALTER TABLE Curso ADD CONSTRAINT FK_Curso_2
    FOREIGN KEY (fk_Universidade_Codigo_EMEC_IES)
    REFERENCES Universidade (Codigo_EMEC_IES)
    ON DELETE SET NULL;
 
ALTER TABLE Estuda ADD CONSTRAINT FK_Estuda_1
    FOREIGN KEY (fk_Curso_Nome)
    REFERENCES Curso (Nome)
    ON DELETE RESTRICT;
 
ALTER TABLE Estuda ADD CONSTRAINT FK_Estuda_2
    FOREIGN KEY (fk_Aluno_Num_ID)
    REFERENCES Aluno (Num_ID)
    ON DELETE SET RESTRICT;
