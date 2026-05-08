-- ================================
-- 1. BD ESCOLAR
-- ================================
CREATE DATABASE escolar;
\c escolar;

CREATE TABLE alumno (
  matricula       VARCHAR(20) PRIMARY KEY,
  primerNombre    VARCHAR(80) NOT NULL,
  segundoNombre   VARCHAR(80),
  apellidoPaterno VARCHAR(80) NOT NULL,
  apellidoMaterno VARCHAR(80),
  correo          VARCHAR(150) UNIQUE,
  telefono        VARCHAR(20),
  carrera         VARCHAR(120)
);


-- ================================
-- 2. BD CAPITAL HUMANO
-- ================================
\c postgres;
CREATE DATABASE capital_humano;
\c capital_humano;

CREATE TABLE empleado (
  numNomina       VARCHAR(20) PRIMARY KEY,
  primerNombre    VARCHAR(80) NOT NULL,
  segundoNombre   VARCHAR(80),
  apellidoPaterno VARCHAR(80) NOT NULL,
  apellidoMaterno VARCHAR(80),
  correo          VARCHAR(150) UNIQUE,
  telefono        VARCHAR(20),
  tipoUsuario     VARCHAR(50),
  activo          BOOLEAN DEFAULT true
);

-- ================================
-- 3. BD TESORERÍA
-- ================================
\c postgres;
CREATE DATABASE tesoreria;
\c tesoreria;

CREATE TABLE pago (
  idPago       SERIAL PRIMARY KEY,
  referencia   VARCHAR(50) NOT NULL,
  tipoUsuario  VARCHAR(20) NOT NULL,
  concepto     VARCHAR(255) NOT NULL,
  monto        NUMERIC(10,2) NOT NULL,
  fechaPago    TIMESTAMP DEFAULT NOW(),
  estado       VARCHAR(20) DEFAULT 'pendiente'
);

-- ================================
-- 4. BD BIBLIOTECA
-- ================================
\c postgres;
CREATE DATABASE biblioteca;
\c biblioteca;

CREATE TABLE ROL (
  idRol       SERIAL PRIMARY KEY,
  nombre      VARCHAR(50) NOT NULL,
  descripcion TEXT
);

CREATE TABLE USUARIO (
  idUsuario        SERIAL PRIMARY KEY,
  idRol            INT REFERENCES ROL(idRol),
  nombre           VARCHAR(120) NOT NULL,
  correo           VARCHAR(350) UNIQUE NOT NULL,
  contrasena       VARCHAR(255) NOT NULL,
  activo           BOOLEAN DEFAULT true,
  tokenRecuperacion VARCHAR,
  tokenExpiracion  TIMESTAMP,
  ultimoAcceso     TIMESTAMP
);

CREATE TABLE AUTOR (
  idAutor         SERIAL PRIMARY KEY,
  nombre          VARCHAR(120) NOT NULL,
  nacionalidad    VARCHAR(90),
  fechaNacimiento DATE
);

CREATE TABLE LIBRO (
  idLibro    SERIAL PRIMARY KEY,
  titulo     VARCHAR(255) NOT NULL,
  editorial  VARCHAR(120),
  anio       SMALLINT,
  tema       VARCHAR(100),
  copias     SMALLINT,
  isbn       VARCHAR(20) UNIQUE,
  ubicacion  VARCHAR(90),
  disponible BOOLEAN DEFAULT true
);

CREATE TABLE LIBRO_AUTOR (
  idLibro INT REFERENCES LIBRO(idLibro),
  idAutor INT REFERENCES AUTOR(idAutor),
  PRIMARY KEY (idLibro, idAutor)
);

CREATE TABLE PRESTAMO (
  idPrestamo      SERIAL PRIMARY KEY,
  idLibro         INT REFERENCES LIBRO(idLibro),
  idCopia        INT REFERENCES COPIA(idCopia),
  idUsuario       INT REFERENCES USUARIO(idUsuario),
  idBibliotecario INT REFERENCES USUARIO(idUsuario),
  fechaPrestamo   TIMESTAMP DEFAULT NOW(),
  fechaDevolucion DATE,
  fechaDevReal    TIMESTAMP,
  estado          VARCHAR(20) NOT NULL,
  numRecibo       VARCHAR UNIQUE
);

CREATE TABLE RENOVACION_PRESTAMO (
  idRenovacion        SERIAL PRIMARY KEY,
  idPrestamo          INT REFERENCES PRESTAMO(idPrestamo),
  fechaRenovacion     TIMESTAMP DEFAULT NOW(),
  nuevaFechaDevolucion DATE
);

CREATE TABLE MULTA (
  idMulta    SERIAL PRIMARY KEY,
  idPrestamo INT REFERENCES PRESTAMO(idPrestamo),
  fechaMulta TIMESTAMP DEFAULT NOW(),
  motivo     VARCHAR(100),
  monto      NUMERIC(8,2),
  estado     VARCHAR(20) NOT NULL,
  fechaPago  TIMESTAMP
);

CREATE TABLE COPIA (
  idCopia    SERIAL PRIMARY KEY,
  idLibro    INT REFERENCES LIBRO(idLibro),
  numCopia   SMALLINT NOT NULL,     
  estado     VARCHAR(50) DEFAULT 'disponible', 
  fechaAlta  TIMESTAMP DEFAULT NOW()
);
