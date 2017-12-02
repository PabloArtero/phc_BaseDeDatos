-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema phc
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `phc` ;

-- -----------------------------------------------------
-- Schema phc
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `phc` DEFAULT CHARACTER SET utf8 ;
USE `phc` ;

-- -----------------------------------------------------
-- Table `phc`.`t_empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_empleado` (
  `idEmpleado` INT NOT NULL AUTO_INCREMENT,
  `apellido` VARCHAR(45) NULL,
  `nombre` VARCHAR(45) NULL,
  `legajo` VARCHAR(45) NOT NULL,
  `fechaIngreso` DATE NULL,
  `dni` INT NULL,
  `cuil` VARCHAR(45) NULL,
  `fechaNacimiento` DATE NULL,
  `esActivo` BIT NULL,
  `telefono` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `domicilio` VARCHAR(100) NULL,
  `sexo` ENUM('M', 'F') NULL DEFAULT 'M',
  PRIMARY KEY (`idEmpleado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_nivel_puesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_nivel_puesto` (
  `idNivelPuesto` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(200) NULL,
  PRIMARY KEY (`idNivelPuesto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_nivel_departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_nivel_departamento` (
  `idNivelDepartamento` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  PRIMARY KEY (`idNivelDepartamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_departamento` (
  `idDepartamento` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL,
  `idNivelDepartamento` INT NOT NULL,
  PRIMARY KEY (`idDepartamento`),
  INDEX `fk_Departamento_NivelDepartamento1_idx` (`idNivelDepartamento` ASC),
  CONSTRAINT `fk_Departamento_NivelDepartamento1`
    FOREIGN KEY (`idNivelDepartamento`)
    REFERENCES `phc`.`t_nivel_departamento` (`idNivelDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_usuario` (
  `idEmpleado` INT NOT NULL,
  `nombreUsuario` VARCHAR(45) NOT NULL,
  `contrasenia` VARCHAR(45) NOT NULL,
  `esAdministrador` BIT NOT NULL DEFAULT 0,
  `habilitado` BIT NOT NULL DEFAULT 1,
  `contraseniaRestaurada` BIT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idEmpleado`),
  INDEX `fk_Usuario_Empleado1_idx` (`idEmpleado` ASC),
  CONSTRAINT `fk_Usuario_Empleado1`
    FOREIGN KEY (`idEmpleado`)
    REFERENCES `phc`.`t_empleado` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_puesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_puesto` (
  `idPuesto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(200) NULL,
  `idDepartamento` INT NOT NULL,
  `idNivelPuesto` INT NOT NULL COMMENT 'Jerarquía que tiene el Puesto dentro de un Departamento. Solo puede haber un Puesto responsable del Departamento por cada Departamento. Esto significa que solo puede haber un puesto con idNivelPuesto = 1 por Departamento y ese puesto es el del responsable del Dpto.',
  PRIMARY KEY (`idPuesto`),
  INDEX `fk_Puesto_Departamento1_idx` (`idDepartamento` ASC),
  INDEX `fk_Puesto_NivelPuesto1_idx` (`idNivelPuesto` ASC),
  CONSTRAINT `fk_Puesto_Departamento1`
    FOREIGN KEY (`idDepartamento`)
    REFERENCES `phc`.`t_departamento` (`idDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Puesto_NivelPuesto1`
    FOREIGN KEY (`idNivelPuesto`)
    REFERENCES `phc`.`t_nivel_puesto` (`idNivelPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_historial_empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_historial_empleado` (
  `idHistorialEmpleado` INT NOT NULL AUTO_INCREMENT,
  `fechaIngreso` DATE NULL,
  `fechaEgreso` DATE NULL,
  `idEmpleado` INT NOT NULL,
  `idPuesto` INT NOT NULL,
  PRIMARY KEY (`idHistorialEmpleado`),
  INDEX `fk_HistorialEmpleado_Puesto1_idx` (`idPuesto` ASC),
  INDEX `fk_HistorialEmpleado_Empleado1_idx` (`idEmpleado` ASC),
  CONSTRAINT `fk_HistorialEmpleado_Puesto1`
    FOREIGN KEY (`idPuesto`)
    REFERENCES `phc`.`t_puesto` (`idPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HistorialEmpleado_Empleado1`
    FOREIGN KEY (`idEmpleado`)
    REFERENCES `phc`.`t_empleado` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_requerimiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_requerimiento` (
  `idRequerimiento` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(200) NULL,
  PRIMARY KEY (`idRequerimiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_tarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_tarea` (
  `idTarea` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(200) NULL,
  PRIMARY KEY (`idTarea`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_requerimiento_puesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_requerimiento_puesto` (
  `idRequerimiento` INT NOT NULL,
  `idPuesto` INT NOT NULL,
  PRIMARY KEY (`idRequerimiento`, `idPuesto`),
  INDEX `fk_Requerimiento_has_Puesto_Puesto1_idx` (`idPuesto` ASC),
  INDEX `fk_Requerimiento_has_Puesto_Requerimiento1_idx` (`idRequerimiento` ASC),
  CONSTRAINT `fk_Requerimiento_has_Puesto_Requerimiento1`
    FOREIGN KEY (`idRequerimiento`)
    REFERENCES `phc`.`t_requerimiento` (`idRequerimiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Requerimiento_has_Puesto_Puesto1`
    FOREIGN KEY (`idPuesto`)
    REFERENCES `phc`.`t_puesto` (`idPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_puesto_tarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_puesto_tarea` (
  `idPuesto` INT NOT NULL,
  `idTarea` INT NOT NULL,
  PRIMARY KEY (`idPuesto`, `idTarea`),
  INDEX `fk_Puesto_has_Tarea_Tarea1_idx` (`idTarea` ASC),
  INDEX `fk_Puesto_has_Tarea_Puesto1_idx` (`idPuesto` ASC),
  CONSTRAINT `fk_Puesto_has_Tarea_Puesto1`
    FOREIGN KEY (`idPuesto`)
    REFERENCES `phc`.`t_puesto` (`idPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Puesto_has_Tarea_Tarea1`
    FOREIGN KEY (`idTarea`)
    REFERENCES `phc`.`t_tarea` (`idTarea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `phc`.`t_bitacora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`t_bitacora` (
  `idBitacora` INT NOT NULL AUTO_INCREMENT,
  `operacion` VARCHAR(10) NOT NULL,
  `usuario` VARCHAR(40) NOT NULL,
  `host` VARCHAR(45) NOT NULL,
  `fechahora` DATETIME NOT NULL,
  `tabla` VARCHAR(45) NOT NULL,
  `columna` VARCHAR(45) NOT NULL,
  `id` VARCHAR(45) NOT NULL,
  `valorViejo` VARCHAR(200) NULL,
  `valorNuevo` VARCHAR(200) NULL,
  PRIMARY KEY (`idBitacora`))
ENGINE = InnoDB;

USE `phc` ;

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_consulta2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_consulta2` (`'Departamento'` INT, `'Nivel del Departamento'` INT, `'Nombre Responsable'` INT, `'Apellido Responsable'` INT, `'Puesto'` INT, `'Nivel del Puesto'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_consulta3`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_consulta3` (`'Departamento'` INT, `'Cantidad de Puestos'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_consulta4`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_consulta4` (`'Departamento'` INT, `'Cantidad de empleados'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_consulta1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_consulta1` (`'Cantidad de departamentos en la organizacion'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_id_empleados_que_trabajan_en_mas_de_un_dpto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_id_empleados_que_trabajan_en_mas_de_un_dpto` (`idEmpleado` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_consulta5`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_consulta5` (`'id'` INT, `'Nombre'` INT, `'Apellido'` INT, `'Puesto'` INT, `'Departamento'` INT, `'Anos'` INT, `'Meses'` INT, `'Anos-Meses'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_departamento` (`idDepartamento` INT, `nombre` INT, `idNivelDepartamento` INT, `nombreNivel` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_puesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_puesto` (`idPuesto` INT, `nombre` INT, `descripcion` INT, `idDepartamento` INT, `nombreDepartamento` INT, `idNivelDepartamento` INT, `nombreNivelDepartamento` INT, `idNivelPuesto` INT, `descripcionNivelPuesto` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_empleado` (`idEmpleado` INT, `apellido` INT, `nombre` INT, `legajo` INT, `fechaIngreso` INT, `dni` INT, `cuil` INT, `fechaNacimiento` INT, `esActivo` INT, `telefono` INT, `email` INT, `domicilio` INT, `sexo` INT, `nombreUsuario` INT, `contrasenia` INT, `esAdministrador` INT, `habilitado` INT, `contraseniaRestaurada` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_usuario` (`idEmpleado` INT, `nombreUsuario` INT, `contrasenia` INT, `esAdministrador` INT, `habilitado` INT, `contraseniaRestaurada` INT, `apellido` INT, `nombre` INT, `legajo` INT, `fechaIngreso` INT, `dni` INT, `cuil` INT, `fechaNacimiento` INT, `esActivo` INT, `telefono` INT, `email` INT, `domicilio` INT, `sexo` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_historial_empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_historial_empleado` (`idHistorialEmpleado` INT, `fechaIngresoAlPuesto` INT, `fechaEgresoDelPuesto` INT, `idPuesto` INT, `nombrePuesto` INT, `descripcionPuesto` INT, `idNivelPuesto` INT, `descripcionNivelPuesto` INT, `idDepartamento` INT, `nombreDepartamento` INT, `idNivelDepartamento` INT, `nombreNivelDepartamento` INT, `idEmpleado` INT, `apellido` INT, `nombre` INT, `legajo` INT, `fechaIngresoALaEmpresa` INT, `dni` INT, `cuil` INT, `fechaNacimiento` INT, `esActivo` INT, `telefono` INT, `email` INT, `domicilio` INT, `sexo` INT, `nombreUsuario` INT, `contrasenia` INT, `esAdministrador` INT, `habilitado` INT, `contraseniaRestaurada` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_empleado_puesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_empleado_puesto` (`id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_requerimiento_puesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_requerimiento_puesto` (`descripcionRequerimiento` INT, `idRequerimiento` INT, `idPuesto` INT, `nombrePuesto` INT, `descripcionPuesto` INT);

-- -----------------------------------------------------
-- Placeholder table for view `phc`.`v_puesto_tarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `phc`.`v_puesto_tarea` (`descripcionTarea` INT, `idTarea` INT, `idPuesto` INT, `nombrePuesto` INT, `descripcionPuesto` INT);

-- -----------------------------------------------------
-- procedure sp_consulta5
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
-- 5-LISTADO DE EMPLEADOS QUE TRABAJAN EN MÁS DE UN DEPARTAMENTO
-- Detallando:
-- 	Los puestos que ocupa.
-- 	A qué depto. pertenece cada puesto
-- 	La ontiguedad en la ocupación de cada puesto.
-- Nota: la hice como procedimiento almacenado porque MySQL no admite subconsultas en las VIEW
-- pero sí en sp.
CREATE PROCEDURE `sp_consulta5` ()
BEGIN
	SELECT
		t_empleado.idEmpleado AS 'id',
		t_empleado.nombre AS 'Nombre',
		t_empleado.apellido AS 'Apellido',
		t_puesto.nombre AS 'Puesto',
		t_departamento.nombre AS 'Departamento',
		DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) DIV 365 AS 'Anos',
		(DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) MOD 365) DIV 30 AS 'Meses',
		CONCAT( DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) DIV 365,'-', (DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) MOD 365) DIV 30) AS 'Anos-Meses'

	FROM 
		t_empleado, 
		t_historial_empleado, 
		t_puesto, 
		t_departamento, 
		v_id_empleados_que_trabajan_en_mas_de_un_dpto

	WHERE t_empleado.idEmpleado = v_id_empleados_que_trabajan_en_mas_de_un_dpto.idEmpleado
	AND t_historial_empleado.idEmpleado = t_empleado.idEmpleado
	AND t_historial_empleado.idPuesto = t_puesto.idPuesto
	AND t_puesto.idDepartamento = t_departamento.idDepartamento
	AND t_historial_empleado.fechaEgreso IS NULL
	;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_departamento
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE `sp_insert_departamento` (IN xnombre VARCHAR(100))
BEGIN

	INSERT INTO t_departamento(nombre) VALUES(xnombre);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_puesto
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
-- Importante: este sp ya no funciona correctamente ya que la columna esResponsableDpto ya no existe.
-- En su lugar el resposable del dpto es el puesto que tienen idNivelPuesto = 1. Y solo puede haber un puesto
-- Responsable por departamento.
CREATE PROCEDURE sp_insert_puesto 
(
	IN xnombre VARCHAR(100),
	IN xdescripcion VARCHAR(200), 
	IN xesResponsableDpto BIT, -- Sólo puede haber un responsable por departamento. No sé qué conviene más: si implementar esa restricción aquí o mediante un trigger en la tabla Puesto.
	IN xidDepartamento INT, 
	IN xidNivel INT
)
BEGIN

	INSERT INTO t_puesto
	(
		nombre, 
		descripcion, 
		esResponsableDpto, 
		idDepartamento, 
		idNivel
	)
	VALUES
	(
		xnombre, 
		xdescripcion, 
		xesResponsableDpto, 
		xidDepartamento, 
		xidNivel
	);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_nivel
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE sp_insert_nivel (IN xnombre VARCHAR(45))
BEGIN

	INSERT INTO t_nivel(nombre) VALUES(xnombre);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_puesto_tarea
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE sp_insert_puesto_tarea (IN xidPuesto INT, IN xidTarea INT)
BEGIN

	INSERT INTO t_puesto_tarea(idPuesto, idTarea) VALUES(xidPuesto, xidTarea);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_requerimiento_puesto
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE sp_insert_requerimiento_puesto (IN xidRequerimiento INT, IN xidPuesto INT)
BEGIN

	INSERT INTO t_requerimiento_puesto(idRequerimiento, idPuesto) VALUES(xidRequerimiento, xidPuesto);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_asignar_puesto_a_empleado
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE sp_asignar_puesto_a_empleado
	(
		IN xidPuesto INT,
		IN xidEmpleado INT 
	)
BEGIN
	
	IF -- asigno el puesto al empleado solo si no está ocupando ya el puesto
	(
		SELECT COUNT(*) FROM t_historial_empleado
		WHERE t_historial_empleado.idPuesto = xidPuesto
		AND t_historial_empleado.idEmpleado = xidEmpleado
		AND t_historial_empleado.fechaEgreso IS NULL
	) = 0
	THEN
		INSERT INTO t_historial_empleado
		(
			idPuesto,
			idEmpleado,
			fechaIngreso	
		) 
		VALUES
		(
			xidPuesto,
			xidEmpleado,
			NOW()
		);
	END IF;
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_requerimiento
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE sp_insert_requerimiento (IN xdescripcion VARCHAR(200))
BEGIN

	INSERT INTO t_requerimiento(descripcion) VALUES(xdescripcion);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_tarea
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE sp_insert_tarea (IN xdescripcion VARCHAR(200))
BEGIN

	INSERT INTO t_tarea(descripcion) VALUES(xdescripcion);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta1
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
-- 1-CANTIDAD DE DEPARTAMENTOS EN LA ORGANIZACION
CREATE PROCEDURE `sp_consulta1` ()
BEGIN
	SELECT COUNT(*) AS 'Cantidad de departamentos en la organizacion'
	FROM t_departamento
    ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta2
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
-- 2-RESPONSABLES POR CADA DEPARTAMENTO (NIVEL DEL PUESTO, DEPARTAMENTO)
CREATE PROCEDURE `sp_consulta2` ()
BEGIN
	
	SELECT 
	d.nombre AS 'Departamento',
	nd.nombre AS 'Nivel del Departamento',
	e.nombre AS 'Nombre Responsable',
	e.apellido AS 'Apellido Responsable',
	p.nombre AS 'Puesto',
	np.descripcion AS 'Nivel del Puesto'
	FROM t_historial_empleado h
	JOIN t_empleado e ON h.idEmpleado = e.idEmpleado
	JOIN t_puesto p ON p.idPuesto = h.idPuesto
	JOIN t_departamento d ON p.idDepartamento = d.idDepartamento
	JOIN t_nivel_puesto np ON p.idNivelPuesto = np.idNivelPuesto
	JOIN t_nivel_departamento nd ON d.idNivelDepartamento = nd.idNivelDepartamento
	WHERE h.fechaEgreso IS NULL -- Todabía ocupa el puesto
	AND p.idNivelPuesto = 1 
	AND e.esActivo = 1
	;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta3
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
-- 3-CANTIDAD DE PUESTOS POR DEPARTAMENTO
CREATE PROCEDURE `sp_consulta3` ()
BEGIN
	SELECT
	 t_departamento.nombre AS 'Departamento',
	 COUNT(t_puesto.idPuesto) AS 'Cantidad de Puestos'
	FROM t_puesto
	JOIN t_departamento ON t_puesto.idDepartamento = t_departamento.idDepartamento
	GROUP BY t_departamento.idDepartamento
;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_consulta4
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
-- 4-CANTIDAD DE POSICIONES POR DEPARTAMENTO (CANTIDAD DE PERSONAS POR DPTO.)
CREATE PROCEDURE `sp_consulta4` ()
BEGIN
	SELECT
	 t_departamento.nombre AS 'Departamento',
	 COUNT(t_empleado.idEmpleado) AS 'Cantidad de empleados'
	FROM t_historial_empleado
	JOIN t_empleado ON t_historial_empleado.idEmpleado = t_empleado.idEmpleado
	JOIN t_puesto ON t_historial_empleado.idPuesto = t_puesto.idPuesto
	JOIN t_departamento ON t_puesto.idDepartamento = t_departamento.idDepartamento
	WHERE t_empleado.esActivo = 1
	AND t_historial_empleado.fechaEgreso IS NULL -- todabía ocupa el puesto
	GROUP BY t_departamento.idDepartamento
;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_sacar_empleado_del_puesto
-- -----------------------------------------------------

DELIMITER $$
USE `phc`$$
CREATE PROCEDURE sp_sacar_empleado_del_puesto
	(
		IN xidEmpleado INT,
		IN xidPuesto INT 
	)
BEGIN
	
	IF -- saco al empleado del puesto solo si está ocupando el puesto
	(
		SELECT COUNT(*) FROM t_historial_empleado
		WHERE t_historial_empleado.idPuesto = xidPuesto
		AND t_historial_empleado.idEmpleado = xidEmpleado
		AND t_historial_empleado.fechaEgreso IS NULL
	) = 1
	THEN
		UPDATE t_historial_empleado
		SET fechaEgreso = NOW()
		WHERE idEmpleado = xidEmpleado
		AND idPuesto = xidPuesto
		AND fechaEgreso IS NULL;
	END IF;
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `phc`.`v_consulta2`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_consulta2`;
USE `phc`;
-- 2-RESPONSABLES POR CADA DEPARTAMENTO (NIVEL DEL PUESTO, DEPARTAMENTO, NIVEL DEL DEPARTAMENTO)
CREATE OR REPLACE VIEW v_consulta2 AS

SELECT 
	d.nombre AS 'Departamento',
	nd.nombre AS 'Nivel del Departamento',
	e.nombre AS 'Nombre Responsable',
	e.apellido AS 'Apellido Responsable',
	p.nombre AS 'Puesto',
	np.descripcion AS 'Nivel del Puesto'
FROM t_historial_empleado h
JOIN t_empleado e ON h.idEmpleado = e.idEmpleado
JOIN t_puesto p ON p.idPuesto = h.idPuesto
JOIN t_departamento d ON p.idDepartamento = d.idDepartamento
JOIN t_nivel_puesto np ON p.idNivelPuesto = np.idNivelPuesto
JOIN t_nivel_departamento nd ON d.idNivelDepartamento = nd.idNivelDepartamento
WHERE h.fechaEgreso IS NULL -- Todabía ocupa el puesto
AND p.idNivelPuesto = 1 
AND e.esActivo = 1
;
-- SELECT * FROM v_consulta2;

-- -----------------------------------------------------
-- View `phc`.`v_consulta3`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_consulta3`;
USE `phc`;
-- 3-CANTIDAD DE PUESTOS POR DEPARTAMENTO
CREATE OR REPLACE VIEW `v_consulta3` AS

SELECT
 t_departamento.nombre AS 'Departamento',
 COUNT(t_puesto.idPuesto) AS 'Cantidad de Puestos'
FROM t_puesto
JOIN t_departamento ON t_puesto.idDepartamento = t_departamento.idDepartamento
GROUP BY t_departamento.idDepartamento
;
-- SELECT * FROM v_consulta3;

-- -----------------------------------------------------
-- View `phc`.`v_consulta4`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_consulta4`;
USE `phc`;
-- 4-CANTIDAD DE POSICIONES POR DEPARTAMENTO (CANTIDAD DE PERSONAS POR DPTO.)
CREATE OR REPLACE VIEW `v_consulta4` AS

SELECT
 t_departamento.nombre AS 'Departamento',
 COUNT(t_empleado.idEmpleado) AS 'Cantidad de empleados'
FROM t_historial_empleado
JOIN t_empleado ON t_historial_empleado.idEmpleado = t_empleado.idEmpleado
JOIN t_puesto ON t_historial_empleado.idPuesto = t_puesto.idPuesto
JOIN t_departamento ON t_puesto.idDepartamento = t_departamento.idDepartamento
WHERE t_empleado.esActivo = 1
AND t_historial_empleado.fechaEgreso IS NULL -- todabía ocupa el puesto
GROUP BY t_departamento.idDepartamento
;
-- SELECT * FROM v_consulta4;

-- -----------------------------------------------------
-- View `phc`.`v_consulta1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_consulta1`;
USE `phc`;
-- 1-CANTIDAD DE DEPARTAMENTOS EN LA ORGANIZACION
CREATE OR REPLACE VIEW `v_consulta1` AS

SELECT COUNT(*) AS 'Cantidad de departamentos en la organizacion'
FROM t_departamento
;
-- SELECT * FROM v_consulta1;

-- -----------------------------------------------------
-- View `phc`.`v_id_empleados_que_trabajan_en_mas_de_un_dpto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_id_empleados_que_trabajan_en_mas_de_un_dpto`;
USE `phc`;
CREATE OR REPLACE VIEW v_id_empleados_que_trabajan_en_mas_de_un_dpto AS

SELECT t_empleado.idEmpleado
FROM 
	t_empleado, 
	t_historial_empleado, 
	t_puesto, 
	t_departamento
WHERE t_empleado.idEmpleado = t_historial_empleado.idEmpleado
AND t_historial_empleado.fechaEgreso IS NULL -- Aún está en el Puesto
AND t_historial_empleado.idPuesto = t_puesto.idPuesto
AND t_puesto.idDepartamento = t_departamento.idDepartamento
GROUP BY t_empleado.idEmpleado
HAVING COUNT(t_departamento.idDepartamento) > 1
;
-- SELECT * FROM v_id_empleados_que_trabajan_en_mas_de_un_dpto;

-- -----------------------------------------------------
-- View `phc`.`v_consulta5`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_consulta5`;
USE `phc`;
CREATE OR REPLACE VIEW `v_consulta5` AS
SELECT
	t_empleado.idEmpleado AS 'id',
	t_empleado.nombre AS 'Nombre',
	t_empleado.apellido AS 'Apellido',
	t_puesto.nombre AS 'Puesto',
	t_departamento.nombre AS 'Departamento',
	DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) DIV 365 AS 'Anos',
	(DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) MOD 365) DIV 30 AS 'Meses',
	CONCAT( DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) DIV 365,'-', (DATEDIFF(CURDATE(), t_historial_empleado.fechaIngreso) MOD 365) DIV 30) AS 'Anos-Meses'

FROM 
	t_empleado, 
    t_historial_empleado, 
    t_puesto, 
    t_departamento, 
    v_id_empleados_que_trabajan_en_mas_de_un_dpto

WHERE t_empleado.idEmpleado = v_id_empleados_que_trabajan_en_mas_de_un_dpto.idEmpleado
AND t_historial_empleado.idEmpleado = t_empleado.idEmpleado
AND t_historial_empleado.idPuesto = t_puesto.idPuesto
AND t_puesto.idDepartamento = t_departamento.idDepartamento
AND t_historial_empleado.fechaEgreso IS NULL
;
-- SELECT * FROM v_consulta5;

-- -----------------------------------------------------
-- View `phc`.`v_departamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_departamento`;
USE `phc`;
CREATE OR REPLACE VIEW v_departamento AS

SELECT
	t_departamento.idDepartamento,
	t_departamento.nombre,
	t_departamento.idNivelDepartamento,
	t_nivel_departamento.nombre AS nombreNivel
FROM
	t_departamento,
	t_nivel_departamento
WHERE t_departamento.idNivelDepartamento = t_nivel_departamento.idNivelDepartamento;

-- -----------------------------------------------------
-- View `phc`.`v_puesto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_puesto`;
USE `phc`;
CREATE OR REPLACE VIEW v_puesto AS

SELECT
	t_puesto.idPuesto,
	t_puesto.nombre,
	t_puesto.descripcion,
	
	t_puesto.idDepartamento,
	t_departamento.nombre AS nombreDepartamento,	
	
	t_departamento.idNivelDepartamento,
	t_nivel_departamento.nombre AS nombreNivelDepartamento,
	
	t_puesto.idNivelPuesto,
	t_nivel_puesto.descripcion AS descripcionNivelPuesto
FROM
	t_puesto,
	t_nivel_puesto,
	t_departamento,
	t_nivel_departamento
WHERE t_puesto.idNivelPuesto = t_nivel_puesto.idNivelPuesto
AND t_puesto.idDepartamento = t_departamento.idDepartamento
AND t_departamento.idNivelDepartamento = t_nivel_departamento.idNivelDepartamento;

-- -----------------------------------------------------
-- View `phc`.`v_empleado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_empleado`;
USE `phc`;
CREATE OR REPLACE VIEW v_empleado AS

SELECT
	-- columnas del empleado
	t_empleado.idEmpleado,
	t_empleado.apellido,
	t_empleado.nombre,
	t_empleado.legajo,
	t_empleado.fechaIngreso,
	t_empleado.dni,
	t_empleado.cuil,
	t_empleado.fechaNacimiento,
	t_empleado.esActivo,
	t_empleado.telefono,
	t_empleado.email,
	t_empleado.domicilio,
	t_empleado.sexo,
	
	-- columnas del usuario
	t_usuario.nombreUsuario,
	t_usuario.contrasenia,
	t_usuario.esAdministrador,
	t_usuario.habilitado,
	t_usuario.contraseniaRestaurada

FROM t_empleado 
LEFT JOIN	t_usuario ON t_usuario.idEmpleado = t_empleado.idEmpleado;

-- -----------------------------------------------------
-- View `phc`.`v_usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_usuario`;
USE `phc`;
CREATE OR REPLACE VIEW v_usuario AS

SELECT
-- columnas del usuario
	t_usuario.idEmpleado,
	t_usuario.nombreUsuario,
	t_usuario.contrasenia,
	t_usuario.esAdministrador,
	t_usuario.habilitado,
	t_usuario.contraseniaRestaurada,
	
-- columnas del empleado
	t_empleado.apellido,
	t_empleado.nombre,
	t_empleado.legajo,
	t_empleado.fechaIngreso,
	t_empleado.dni,
	t_empleado.cuil,
	t_empleado.fechaNacimiento,
	t_empleado.esActivo,
	t_empleado.telefono,
	t_empleado.email,
	t_empleado.domicilio,
	t_empleado.sexo
FROM
	t_usuario,
	t_empleado
WHERE t_usuario.idEmpleado = t_empleado.idEmpleado;

-- -----------------------------------------------------
-- View `phc`.`v_historial_empleado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_historial_empleado`;
USE `phc`;
CREATE OR REPLACE VIEW v_historial_empleado AS

SELECT
	t_historial_empleado.idHistorialEmpleado,
	t_historial_empleado.fechaIngreso AS fechaIngresoAlPuesto,
	t_historial_empleado.fechaEgreso AS fechaEgresoDelPuesto,

	t_historial_empleado.idPuesto,
	v_puesto.nombre AS nombrePuesto,
	v_puesto.descripcion AS descripcionPuesto,
	
	v_puesto.idNivelPuesto,
	v_puesto.descripcionNivelPuesto,
	
	v_puesto.idDepartamento,
	v_puesto.nombreDepartamento,
	
	v_puesto.idNivelDepartamento,
	v_puesto.nombreNivelDepartamento,

	t_historial_empleado.idEmpleado,
	v_empleado.apellido,
	v_empleado.nombre,
	v_empleado.legajo,
	v_empleado.fechaIngreso AS fechaIngresoALaEmpresa,
	v_empleado.dni,
	v_empleado.cuil,
	v_empleado.fechaNacimiento,
	v_empleado.esActivo,
	v_empleado.telefono,
	v_empleado.email,
	v_empleado.domicilio,
	v_empleado.sexo,
	
	v_empleado.nombreUsuario,
	v_empleado.contrasenia,
	v_empleado.esAdministrador,
	v_empleado.habilitado,
	v_empleado.contraseniaRestaurada
FROM
	t_historial_empleado,
	v_puesto,
	v_empleado
WHERE t_historial_empleado.idPuesto = v_puesto.idPuesto
AND t_historial_empleado.idEmpleado = v_empleado.idEmpleado;

-- -----------------------------------------------------
-- View `phc`.`v_empleado_puesto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_empleado_puesto`;
USE `phc`;
-- EMPLEADOS Y LOS PUESTOS QUE OCUPA ACTUALMENTE
CREATE OR REPLACE VIEW `v_empleado_puesto` AS

SELECT * FROM v_historial_empleado
WHERE v_historial_empleado.fechaEgresoDelPuesto IS NULL
;
-- SELECT * FROM v_empleado_puesto;

-- -----------------------------------------------------
-- View `phc`.`v_requerimiento_puesto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_requerimiento_puesto`;
USE `phc`;
CREATE OR REPLACE VIEW `v_requerimiento_puesto` AS

SELECT
	t_requerimiento.descripcion AS descripcionRequerimiento,
	t_requerimiento.idRequerimiento,
	t_requerimiento_puesto.idPuesto,
	t_puesto.nombre AS nombrePuesto,
	t_puesto.descripcion AS descripcionPuesto
FROM t_requerimiento, t_requerimiento_puesto, t_puesto
WHERE t_requerimiento.idRequerimiento = t_requerimiento_puesto.idRequerimiento
AND t_puesto.idPuesto = t_requerimiento_puesto.idPuesto
;
-- SELECT * FROM v_requerimiento_puesto;

-- -----------------------------------------------------
-- View `phc`.`v_puesto_tarea`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `phc`.`v_puesto_tarea`;
USE `phc`;
CREATE OR REPLACE VIEW `v_puesto_tarea` AS

SELECT
	t_tarea.descripcion AS descripcionTarea,
	t_puesto_tarea.idTarea,
	t_puesto_tarea.idPuesto,
	t_puesto.nombre AS nombrePuesto,
	t_puesto.descripcion AS descripcionPuesto
FROM t_tarea, t_puesto_tarea, t_puesto
WHERE t_puesto_tarea.idTarea = t_tarea.idTarea
AND t_puesto_tarea.idPuesto = t_puesto.idPuesto
;
-- SELECT * FROM v_puesto_tarea;
USE `phc`;

DELIMITER $$
USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER tg_nivel_puesto_bitacora_insert AFTER INSERT ON `t_nivel_puesto` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF NEW.idNivelPuesto IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_nivel_puesto", -- tabla
			"idNivelPuesto", -- columna
			NEW.idNivelPuesto, -- id
			NULL, -- valorViejo
			NEW.idNivelPuesto -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_nivel_puesto", -- tabla
			"descripcion", -- columna
			NEW.idNivelPuesto, -- id
			NULL, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER tg_nivel_puesto_bitacora_update AFTER UPDATE ON `t_nivel_puesto` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF NEW.idNivelPuesto != OLD.idNivelPuesto THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_nivel_puesto", -- tabla
			"idNivelPuesto", -- columna
			OLD.idNivelPuesto, -- id
			OLD.idNivelPuesto, -- valorViejo
			NEW.idNivelPuesto -- valorNuevo
		); 	
   END IF;

   IF NEW.descripcion != OLD.descripcion THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_nivel_puesto", -- tabla
			"descripcion", -- columna
			OLD.idNivelPuesto, -- id
			OLD.descripcion, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER tg_nivelPuesto_bitacora_delete AFTER DELETE ON `t_nivel_puesto` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF OLD.idNivelPuesto IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada campo que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_nivel_puesto", -- tabla
			"idNivelPuesto", -- columna
			OLD.idNivelPuesto, -- id
			OLD.idNivelPuesto, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
	IF OLD.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada campo que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_nivel_puesto", -- tabla
			"descripcion", -- columna
			OLD.idNivelPuesto, -- id
			OLD.descripcion, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_departamento_bitacora_insert` AFTER INSERT ON `t_departamento` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF NEW.idDepartamento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_departamento", -- tabla
			"idDepartamento", -- columna
			NEW.idDepartamento, -- id
			NULL, -- valorViejo
			NEW.idDepartamento -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.nombre IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_departamento", -- tabla
			"nombre", -- columna
			NEW.idDepartamento, -- id
			NULL, -- valorViejo
			NEW.nombre -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_departamento_bitacora_update` AFTER UPDATE ON `t_departamento` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF NEW.idDepartamento != OLD.idDepartamento THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_departamento", -- tabla
			"idDepartamento", -- columna
			OLD.idDepartamento, -- id
			OLD.idDepartamento, -- valorViejo
			NEW.idDepartamento -- valorNuevo
		); 	
   END IF;

   IF NEW.nombre != OLD.nombre THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_departamento", -- tabla
			"nombre", -- columna
			OLD.idDepartamento, -- id
			OLD.nombre, -- valorViejo
			NEW.nombre -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_departamento_bitacora_delete` AFTER DELETE ON `t_departamento` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF OLD.idDepartamento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_departamento", -- tabla
			"idDepartamento", -- columna
			OLD.idDepartamento, -- id
			OLD.idDepartamento, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
 	IF OLD.nombre IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_departamento", -- tabla
			"nombre", -- columna
			OLD.idDepartamento, -- id
			OLD.nombre, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_requerimiento_bitacora_insert` AFTER INSERT ON `t_requerimiento` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF NEW.idRequerimiento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_requerimiento", -- tabla
			"idRequerimiento", -- columna
			NEW.idRequerimiento, -- id
			NULL, -- valorViejo
			NEW.idRequerimiento -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_requerimiento", -- tabla
			"descripcion", -- columna
			NEW.idRequerimiento, -- id
			NULL, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_requerimiento_bitacora_update` AFTER UPDATE ON `t_requerimiento` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF NEW.idRequerimiento != OLD.idRequerimiento THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_requerimiento", -- tabla
			"idRequerimiento", -- columna
			OLD.idRequerimiento, -- id
			OLD.idRequerimiento, -- valorViejo
			NEW.idRequerimiento -- valorNuevo
		); 	
   END IF;

   IF NEW.descripcion != OLD.descripcion THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_requerimiento", -- tabla
			"descripcion", -- columna
			OLD.idRequerimiento, -- id
			OLD.descripcion, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_requerimiento_bitacora_delete` AFTER DELETE ON `t_requerimiento` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF OLD.idRequerimiento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_requerimiento", -- tabla
			"idRequerimiento", -- columna
			OLD.idRequerimiento, -- id
			OLD.idRequerimiento, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
 	IF OLD.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_requerimiento", -- tabla
			"descripcion", -- columna
			OLD.idRequerimiento, -- id
			OLD.descripcion, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_tarea_bitacora_insert` AFTER INSERT ON `t_tarea` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/
	IF NEW.idTarea IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_tarea", -- tabla
			"idTarea", -- columna
			NEW.idTarea, -- id
			NULL, -- valorViejo
			NEW.idTarea -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"t_tarea", -- tabla
			"descripcion", -- columna
			NEW.idTarea, -- id
			NULL, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_tarea_bitacora_update` AFTER UPDATE ON `t_tarea` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF NEW.idTarea != OLD.idTarea THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_tarea", -- tabla
			"idTarea", -- columna
			OLD.idTarea, -- id
			OLD.idTarea, -- valorViejo
			NEW.idTarea -- valorNuevo
		); 	
   END IF;

   IF NEW.descripcion != OLD.descripcion THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"t_tarea", -- tabla
			"descripcion", -- columna
			OLD.idTarea, -- id
			OLD.descripcion, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `phc`$$
CREATE DEFINER = CURRENT_USER TRIGGER `phc`.`tg_tarea_bitacora_delete` AFTER DELETE ON `t_tarea` FOR EACH ROW
BEGIN
/*MANTENIMIENTO DE LA BITÁCORA PARA AUDITORÍAS
Comportamiento: Se inserta en la tabla Bitacora un registro por cada campo insertado en esta tabla
*/	
	IF OLD.idTarea IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_tarea", -- tabla
			"idTarea", -- columna
			OLD.idTarea, -- id
			OLD.idTarea, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
 	IF OLD.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO t_bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"t_tarea", -- tabla
			"descripcion", -- columna
			OLD.idTarea, -- id
			OLD.descripcion, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `phc`.`t_empleado`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (1, 'Maturana', 'Julieta', '4265784', '2007-06-12', 45976135, '27-45976135-1', '1991-06-20', 1, '4215789', 'jmaturana@hotmail.com', 'Av. Francisco de Aguirre 1234', 'F');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (2, 'Fogliato', 'Luca', '4254662', '2015-09-21', 35116746, '20-35116746-1', '1994-02-03', 1, '4567812', 'lucafogliato@gmail.com', 'Junin 253', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (3, 'Grosse', 'Ivan', '4123793', '2009-03-25', 12354813, '20-12354813-1', '1994-04-09', 1, '4567812', 'ivangrosse@gmail.com', 'Santiago 4053', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (4, 'Arias', 'Martin', '5124354', '2012-03-14', 36459787, '20-36459787-1', '1983-06-02', 1, '4235678', 'martinarias@gmail.com', 'San Juan 387', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (5, 'Artero', 'Pablo', '4568794', '2009-03-25', 45876123, '20-45876123-1', '1994-02-19', 1, '4612357', 'pabloartero@hotmail.com', 'Emilio Castelar 386', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (6, 'Gordillo ', 'Mariano', '4657891', '2009-03-25', 4444444, '20-4444444-1', '1992-03-22', 1, '4612357', 'marianogordillo@gmail.com', 'Saavedra 1564', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (7, 'Gramajo', 'Melisa', '9546874', '2007-06-12', 45421642, '27-45421642-1', '1991-03-22', 1, '4561384', 'melisagramajo@hotmail.com', 'Chacabuco 327', 'F');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (8, 'Salas', 'Benjamin', '3546751', '2009-03-25', 15485615, '20-15485615-1', '1976-04-25', 1, '4613798', 'benjaminsalas@gmail.com', 'Santa fe 234', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (9, 'Cerutti', 'Facundo', '6452134', '2015-09-21', 46081345, '20-46081345-1', '1995-03-15', 1, '4745812', 'facundocerutti@gmail.com', 'Laprida 761', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (10, 'Yapura', 'Jose', '4521345', '2012-03-14', 45621355, '20-45621355-1', '1993-02-17', 1, '4457812', 'daniyapura@gmail.com', 'Ayacucho 451', 'M');
INSERT INTO `phc`.`t_empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (11, 'Dominguez', 'Juan', '5364311', '2007-06-12', 46891354, '20-46891354-1', '1992-03-19', 0, '4199851', 'juandominguez@hotmail.com', 'Necochea 2604', 'M');

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_nivel_puesto`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_nivel_puesto` (`idNivelPuesto`, `descripcion`) VALUES (1, 'Resp. Dpto.');
INSERT INTO `phc`.`t_nivel_puesto` (`idNivelPuesto`, `descripcion`) VALUES (2, 'No resp.');

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_nivel_departamento`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_nivel_departamento` (`idNivelDepartamento`, `nombre`) VALUES (1, 'Estrategico');
INSERT INTO `phc`.`t_nivel_departamento` (`idNivelDepartamento`, `nombre`) VALUES (2, 'Tactico');
INSERT INTO `phc`.`t_nivel_departamento` (`idNivelDepartamento`, `nombre`) VALUES (3, 'Operativo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_departamento`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (1, 'Direccion General', 1);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (2, 'Direccion del Area de Negocios', 2);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (3, 'Direccion del Area de Producción', 2);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (4, 'Direccion del Area de I+D+i', 2);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (5, 'Direccion del Area de Administracion', 2);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (6, 'Marketing', 3);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (7, 'Ventas', 3);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (8, 'Analisis y Diseno', 3);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (9, 'Desarrollo y calidad', 3);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (10, 'Implementacion y Pruebas', 3);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (11, 'Administracion del Conocimiento', 3);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (12, 'Recursos Humanos', 3);
INSERT INTO `phc`.`t_departamento` (`idDepartamento`, `nombre`, `idNivelDepartamento`) VALUES (13, 'Finanzas', 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_usuario`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_usuario` (`idEmpleado`, `nombreUsuario`, `contrasenia`, `esAdministrador`, `habilitado`, `contraseniaRestaurada`) VALUES (10, 'jose', md5('jose'), 1, 1, 0);
INSERT INTO `phc`.`t_usuario` (`idEmpleado`, `nombreUsuario`, `contrasenia`, `esAdministrador`, `habilitado`, `contraseniaRestaurada`) VALUES (1, 'julieta', md5('julieta'), 0, 1, 0);
INSERT INTO `phc`.`t_usuario` (`idEmpleado`, `nombreUsuario`, `contrasenia`, `esAdministrador`, `habilitado`, `contraseniaRestaurada`) VALUES (4, 'jesus', md5('jesus'), 0, 1, 0);
INSERT INTO `phc`.`t_usuario` (`idEmpleado`, `nombreUsuario`, `contrasenia`, `esAdministrador`, `habilitado`, `contraseniaRestaurada`) VALUES (11, 'juan', md5('juan'), 1, 0, 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_puesto`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (1, 'Director General', 'Direccion general', 1, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (2, 'Gerente del Area de Negocios', NULL, 2, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (3, 'Gerente del Area de Produccion', NULL, 3, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (4, 'Gerente del Area de I+D-i', NULL, 4, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (5, 'Gerente del Area de Administracion', NULL, 5, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (6, 'Encargado de Marketing', NULL, 6, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (7, 'Encargado de ventas', NULL, 7, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (8, 'Encargado de analisis y diseno', NULL, 8, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (9, 'Encargado de desarrollo y calidad', NULL, 9, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (10, 'Encargado de Implementación y pruebas', NULL, 10, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (11, 'Encargado de la Administracion del conocimiento', NULL, 11, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (12, 'Encargado de Recursos Humanos', NULL, 12, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (13, 'Encargado de Finanzas', NULL, 13, 1);
INSERT INTO `phc`.`t_puesto` (`idPuesto`, `nombre`, `descripcion`, `idDepartamento`, `idNivelPuesto`) VALUES (14, 'Programador Senior', NULL, 9, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_historial_empleado`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (1, '2007-06-12', '2015-09-21', 1, 1);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (2, '2007-06-12', NULL, 1, 2);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (3, '2007-06-12', '2009-03-25', 1, 6);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (4, '2007-06-12', '2009-03-25', 1, 7);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (5, '2007-06-12', '2012-03-14', 11, 3);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (6, '2007-06-12', '2009-03-25', 11, 8);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (7, '2007-06-12', '2009-03-25', 11, 9);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (8, '2007-06-12', '2009-03-25', 11, 10);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (9, '2007-06-12', '2012-03-14', 11, 5);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (10, '2007-06-12', '2012-03-14', 7, 12);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (11, '2007-06-12', '2012-03-14', 7, 13);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (12, '2009-03-25', NULL, 6, 6);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (13, '2009-03-25', NULL, 8, 7);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (14, '2009-03-25', '2012-03-14', 5, 8);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (15, '2009-03-25', '2012-03-14', 3, 9);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (16, '2009-03-25', NULL, 3, 10);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (17, '2012-03-14', '2015-09-21', 7, 5);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (18, '2012-03-14', NULL, 10, 12);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (19, '2012-03-14', NULL, 4, 13);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (20, '2012-03-14', NULL, 5, 3);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (21, '2012-03-14', NULL, 10, 8);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (22, '2012-03-14', NULL, 8, 9);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (23, '2015-09-21', NULL, 6, 1);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (24, '2015-09-21', NULL, 7, 4);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (25, '2015-09-21', NULL, 9, 11);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (26, '2015-09-21', NULL, 2, 5);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (27, '2015-09-21 ', NULL, 9, 14);
INSERT INTO `phc`.`t_historial_empleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (28, '2015-09-21', NULL, 3, 14);

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_requerimiento`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_requerimiento` (`idRequerimiento`, `descripcion`) VALUES (1, 'Estudios secundarios completos');
INSERT INTO `phc`.`t_requerimiento` (`idRequerimiento`, `descripcion`) VALUES (2, 'Dominio de multiples lenguajes');
INSERT INTO `phc`.`t_requerimiento` (`idRequerimiento`, `descripcion`) VALUES (3, 'Titulo en administracion de empresas');

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_tarea`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_tarea` (`idTarea`, `descripcion`) VALUES (1, 'Se encarga de administrar, coordinar, dirigir y supervisar las actividades administrativas de la empresa');
INSERT INTO `phc`.`t_tarea` (`idTarea`, `descripcion`) VALUES (2, 'Planificar las actividades tecnicas de la Unidad a cargo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_requerimiento_puesto`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 1);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 2);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 3);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 4);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 5);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 6);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 7);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 8);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 9);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 10);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 11);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 12);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 13);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 14);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (2, 14);
INSERT INTO `phc`.`t_requerimiento_puesto` (`idRequerimiento`, `idPuesto`) VALUES (3, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `phc`.`t_puesto_tarea`
-- -----------------------------------------------------
START TRANSACTION;
USE `phc`;
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (1, 1);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (1, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (2, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (3, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (4, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (5, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (6, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (7, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (8, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (9, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (10, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (11, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (12, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (13, 2);
INSERT INTO `phc`.`t_puesto_tarea` (`idPuesto`, `idTarea`) VALUES (14, 2);

COMMIT;

