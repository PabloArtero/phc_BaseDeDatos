-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema PHC
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `PHC` ;

-- -----------------------------------------------------
-- Schema PHC
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `PHC` DEFAULT CHARACTER SET utf8 ;
USE `PHC` ;

-- -----------------------------------------------------
-- Table `PHC`.`Empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Empleado` (
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
  `sexo` CHAR(1) NULL DEFAULT 'M',
  PRIMARY KEY (`idEmpleado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`Nivel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Nivel` (
  `idNivel` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idNivel`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`Departamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Departamento` (
  `idDepartamento` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL,
  PRIMARY KEY (`idDepartamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Usuario` (
  `idEmpleado` INT NOT NULL,
  `nombreUsuario` VARCHAR(45) NOT NULL,
  `contrasena` VARCHAR(45) NOT NULL,
  `esAdministrador` BIT NOT NULL DEFAULT 0,
  `habilitado` BIT NOT NULL DEFAULT 1,
  `contrasenaRestaurada` BIT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idEmpleado`),
  INDEX `fk_Usuario_Empleado1_idx` (`idEmpleado` ASC),
  CONSTRAINT `fk_Usuario_Empleado1`
    FOREIGN KEY (`idEmpleado`)
    REFERENCES `PHC`.`Empleado` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`Puesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Puesto` (
  `idPuesto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(200) NULL,
  `esResponsableDpto` BIT NOT NULL DEFAULT 0,
  `idDepartamento` INT NOT NULL,
  `idNivel` INT NOT NULL,
  PRIMARY KEY (`idPuesto`),
  INDEX `fk_Puesto_Departamento1_idx` (`idDepartamento` ASC),
  INDEX `fk_Puesto_Nivel1_idx` (`idNivel` ASC),
  CONSTRAINT `fk_Puesto_Departamento1`
    FOREIGN KEY (`idDepartamento`)
    REFERENCES `PHC`.`Departamento` (`idDepartamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Puesto_Nivel1`
    FOREIGN KEY (`idNivel`)
    REFERENCES `PHC`.`Nivel` (`idNivel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`HistorialEmpleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`HistorialEmpleado` (
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
    REFERENCES `PHC`.`Puesto` (`idPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_HistorialEmpleado_Empleado1`
    FOREIGN KEY (`idEmpleado`)
    REFERENCES `PHC`.`Empleado` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`Requerimiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Requerimiento` (
  `idRequerimiento` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(200) NULL,
  PRIMARY KEY (`idRequerimiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`Tarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Tarea` (
  `idTarea` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(200) NULL,
  PRIMARY KEY (`idTarea`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`RequerimientoPuesto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`RequerimientoPuesto` (
  `idRequerimiento` INT NOT NULL,
  `idPuesto` INT NOT NULL,
  PRIMARY KEY (`idRequerimiento`, `idPuesto`),
  INDEX `fk_Requerimiento_has_Puesto_Puesto1_idx` (`idPuesto` ASC),
  INDEX `fk_Requerimiento_has_Puesto_Requerimiento1_idx` (`idRequerimiento` ASC),
  CONSTRAINT `fk_Requerimiento_has_Puesto_Requerimiento1`
    FOREIGN KEY (`idRequerimiento`)
    REFERENCES `PHC`.`Requerimiento` (`idRequerimiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Requerimiento_has_Puesto_Puesto1`
    FOREIGN KEY (`idPuesto`)
    REFERENCES `PHC`.`Puesto` (`idPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`PuestoTarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`PuestoTarea` (
  `idPuesto` INT NOT NULL,
  `idTarea` INT NOT NULL,
  PRIMARY KEY (`idPuesto`, `idTarea`),
  INDEX `fk_Puesto_has_Tarea_Tarea1_idx` (`idTarea` ASC),
  INDEX `fk_Puesto_has_Tarea_Puesto1_idx` (`idPuesto` ASC),
  CONSTRAINT `fk_Puesto_has_Tarea_Puesto1`
    FOREIGN KEY (`idPuesto`)
    REFERENCES `PHC`.`Puesto` (`idPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Puesto_has_Tarea_Tarea1`
    FOREIGN KEY (`idTarea`)
    REFERENCES `PHC`.`Tarea` (`idTarea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `PHC`.`Bitacora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`Bitacora` (
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

USE `PHC` ;

-- -----------------------------------------------------
-- Placeholder table for view `PHC`.`v_consulta1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`v_consulta1` (`'Cantidad de departamentos en la organización'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHC`.`v_consulta2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`v_consulta2` (`'Departamento'` INT, `'Nivel'` INT, `'Nombre Responsable'` INT, `'Apellido Responsable'` INT, `'Puesto Responsable'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHC`.`v_consulta3`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`v_consulta3` (`'Departamento'` INT, `'Cantidad de Puestos'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `PHC`.`v_consulta4`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `PHC`.`v_consulta4` (`'Departamento'` INT, `'Cantidad de empleados'` INT);

-- -----------------------------------------------------
-- procedure sp_consulta5
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
-- 5-LISTADO DE EMPLEADOS QUE TRABAJAN EN MÁS DE UN DEPARTAMENTO
-- Detallando:
-- 	Los puestos que ocupa.
-- 	A qué depto. pertenece cada puesto
-- 	La ontiguedad en la ocupación de cada puesto.
-- Nota: la hice como procedimiento almacenado porque MySQL no admite subconsultas el las VIEW
CREATE PROCEDURE `sp_consulta5` ()
BEGIN
 
SELECT
	Empleado.idEmpleado AS 'id',
	Empleado.nombre AS 'Nombre',
	Empleado.apellido AS 'Apellido',
	Puesto.nombre AS 'Puesto',
	Departamento.nombre AS 'Departamento',
	DATEDIFF(CURDATE(), HistorialEmpleado.fechaIngreso) DIV 365 AS 'Años',
	(DATEDIFF(CURDATE(), HistorialEmpleado.fechaIngreso) MOD 365) DIV 30 AS 'Meses',
	CONCAT( DATEDIFF(CURDATE(), HistorialEmpleado.fechaIngreso) DIV 365,'-', (DATEDIFF(CURDATE(), HistorialEmpleado.fechaIngreso) MOD 365) DIV 30) AS 'Años-Meses'
FROM
	Empleado, HistorialEmpleado, Puesto, Departamento,
 	(SELECT -- Empleados que trabajan en más de un Departamento
		Empleado.idEmpleado
	FROM Empleado, HistorialEmpleado,Puesto,Departamento
	WHERE Empleado.idEmpleado = HistorialEmpleado.idEmpleado
	AND HistorialEmpleado.fechaEgreso IS NULL -- Aún está en el Puesto
	AND HistorialEmpleado.idPuesto = Puesto.idPuesto
	AND Puesto.idDepartamento = Departamento.idDepartamento
	GROUP BY Empleado.idEmpleado
	HAVING COUNT(Departamento.idDepartamento) > 1
	) AS EmplTrabajaEnMasDeUnDpto
WHERE Empleado.idEmpleado = EmplTrabajaEnMasDeUnDpto.idEmpleado
AND HistorialEmpleado.idEmpleado = Empleado.idEmpleado
AND HistorialEmpleado.idPuesto = Puesto.idPuesto
AND Puesto.idDepartamento = Departamento.idDepartamento
AND HistorialEmpleado.fechaEgreso IS NULL
;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_departamento
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
CREATE PROCEDURE `sp_insert_departamento` (IN xnombre VARCHAR(100))
BEGIN

	INSERT INTO Departamento(nombre) VALUES(xnombre);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_puesto
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
CREATE PROCEDURE sp_insert_puesto 
(
	IN xnombre VARCHAR(100),
	IN xdescripcion VARCHAR(200), 
	IN xesResponsableDpto BIT, -- Sólo puede haber un responsable por departamento. No sé si conviene más implementar esa restricción aquí o mediante un trigger en la tabla Puesto.
	IN xidDepartamento INT, 
	IN xidNivel INT
)
BEGIN

	INSERT INTO Puesto
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
USE `PHC`$$
CREATE PROCEDURE sp_insert_nivel (IN xnombre VARCHAR(45))
BEGIN

	INSERT INTO Nivel(nombre) VALUES(xnombre);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_puesto_tarea
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
CREATE PROCEDURE sp_insert_puesto_tarea (IN xidPuesto INT, IN xidTarea INT)
BEGIN

	INSERT INTO PuestoTarea(idPuesto, idTarea) VALUES(xidPuesto, xidTarea);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_requerimiento_puesto
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
CREATE PROCEDURE sp_insert_requerimiento_puesto (IN xidRequerimiento INT, IN xidPuesto INT)
BEGIN

	INSERT INTO RequerimientoPuesto(idRequerimiento, idPuesto) VALUES(xidRequerimiento, xidPuesto);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_empleado_puesto
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
CREATE PROCEDURE sp_insert_empleado_puesto 
(
	IN xidEmpleado INT,
	IN xidPuesto INT 
)
BEGIN

	INSERT INTO HistorialEmpleado
	(
		fechaIngreso,
		idEmpleado, 
		idPuesto
	) 
	VALUES
	(
		NOW(),
		xidEmpleado, 
		xidPuesto
	);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_requerimiento
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
CREATE PROCEDURE sp_insert_requerimiento (IN xdescripcion VARCHAR(200))
BEGIN

	INSERT INTO Requerimiento(descripcion) VALUES(xdescripcion);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insert_tarea
-- -----------------------------------------------------

DELIMITER $$
USE `PHC`$$
CREATE PROCEDURE sp_insert_tarea (IN xdescripcion VARCHAR(200))
BEGIN

	INSERT INTO Tarea(descripcion) VALUES(xdescripcion);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `PHC`.`v_consulta1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHC`.`v_consulta1`;
USE `PHC`;
-- 1-CANTIDAD DE DEPARTAMENTOS EN LA ORGANIZACION
CREATE  OR REPLACE VIEW `v_consulta1` AS

SELECT COUNT(*) AS 'Cantidad de departamentos en la organización'
FROM Departamento;

-- -----------------------------------------------------
-- View `PHC`.`v_consulta2`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHC`.`v_consulta2`;
USE `PHC`;
-- 2-RESPONSABLES POR CADA DEPARTAMENTO (NIVEL DEL PUESTO, DEPARTAMENTO)
CREATE  OR REPLACE VIEW `v_consulta2` AS

SELECT 
 d.nombre AS 'Departamento',
 n.nombre AS 'Nivel',
 e.nombre AS 'Nombre Responsable',
 e.apellido AS 'Apellido Responsable',
 p.nombre AS 'Puesto Responsable'
FROM HistorialEmpleado h
JOIN Empleado e ON h.idEmpleado = e.idEmpleado
JOIN Puesto p ON p.idPuesto = h.idPuesto
JOIN Departamento d ON p.idDepartamento = d.idDepartamento
JOIN Nivel n ON p.idNivel = n.idNivel
WHERE h.fechaEgreso IS NULL -- Todabía ocupa el puesto
AND p.esResponsableDpto = 1 AND e.esActivo = 1;

-- -----------------------------------------------------
-- View `PHC`.`v_consulta3`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHC`.`v_consulta3`;
USE `PHC`;
-- 3-CANTIDAD DE PUESTOS POR DEPARTAMENTO
CREATE  OR REPLACE VIEW `v_consulta3` AS

SELECT
 Departamento.nombre AS 'Departamento',
 COUNT(Puesto.idPuesto) AS 'Cantidad de Puestos'
FROM Puesto
JOIN Departamento ON Puesto.idDepartamento = Departamento.idDepartamento
GROUP BY Departamento.idDepartamento;

-- -----------------------------------------------------
-- View `PHC`.`v_consulta4`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `PHC`.`v_consulta4`;
USE `PHC`;
-- 4-CANTIDAD DE POSICIONES POR DEPARTAMENTO (CANTIDAD DE PERSONAS POR DPTO.)
CREATE  OR REPLACE VIEW `v_consulta4` AS

SELECT
 Departamento.nombre AS 'Departamento',
 COUNT(Empleado.idEmpleado) AS 'Cantidad de empleados'
FROM HistorialEmpleado
JOIN Empleado ON HistorialEmpleado.idEmpleado = Empleado.idEmpleado
JOIN Puesto ON HistorialEmpleado.idPuesto = Puesto.idPuesto
JOIN Departamento ON Puesto.idDepartamento = Departamento.idDepartamento
WHERE Empleado.esActivo = 1
AND Historialempleado.fechaEgreso IS NULL -- todabía ocupa el puesto
GROUP BY Departamento;
USE `PHC`;

DELIMITER $$
USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER tg_nivel_bitacora_insert AFTER INSERT ON `Nivel` FOR EACH ROW
BEGIN
	
	IF NEW.idNivel IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada campo que se quiera auditar)
		INSERT INTO bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"nivel", -- tabla
			"idNivel", -- columna
			NEW.idNivel, -- id
			NULL, -- valorViejo
			NEW.idNivel -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.nombre IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada campo que se quiera auditar)
		INSERT INTO bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"nivel", -- tabla
			"nombre", -- columna
			NEW.idNivel, -- id
			NULL, -- valorViejo
			NEW.nombre -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER tg_nivel_bitacora_update AFTER UPDATE ON `Nivel` FOR EACH ROW
BEGIN
	
	IF NEW.idNivel != OLD.idNivel THEN -- si cambió el valor del campo... (hacer un IF como éste por cada campo que se quiera auditar)
   	INSERT INTO bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"nivel", -- tabla
			"idNivel", -- columna
			OLD.idNivel, -- id
			OLD.idNivel, -- valorViejo
			NEW.idNivel -- valorNuevo
		); 	
   END IF;

   IF NEW.nombre != OLD.nombre THEN -- si cambió el valor del campo... (hacer un IF como éste por cada campo que se quiera auditar)
   	INSERT INTO bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"nivel", -- tabla
			"nombre", -- columna
			OLD.idNivel, -- id
			OLD.nombre, -- valorViejo
			NEW.nombre -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER tg_nivel_bitacora_delete AFTER DELETE ON `Nivel` FOR EACH ROW
BEGIN
	
	IF OLD.idNivel IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada campo que se quiera auditar)
		INSERT INTO bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"nivel", -- tabla
			"idNivel", -- columna
			OLD.idNivel, -- id
			OLD.idNivel, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
	IF OLD.nombre IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada campo que se quiera auditar)
		INSERT INTO bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"carrera", -- tabla
			"nombre", -- columna
			OLD.idNivel, -- id
			OLD.nombre, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_departamento_bitacora_insert` AFTER INSERT ON `Departamento` FOR EACH ROW
BEGIN
	
	IF NEW.idDepartamento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"Departamento", -- tabla
			"idDepartamento", -- columna
			NEW.idDepartamento, -- id
			NULL, -- valorViejo
			NEW.idDepartamento -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.nombre IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"Departamento", -- tabla
			"nombre", -- columna
			NEW.idDepartamento, -- id
			NULL, -- valorViejo
			NEW.nombre -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_departamento_bitacora_update` AFTER UPDATE ON `Departamento` FOR EACH ROW
BEGIN
	
	IF NEW.idDepartamento != OLD.idDepartamento THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"Departamento", -- tabla
			"idDepartamento", -- columna
			OLD.idDepartamento, -- id
			OLD.idDepartamento, -- valorViejo
			NEW.idDepartamento -- valorNuevo
		); 	
   END IF;

   IF NEW.nombre != OLD.nombre THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"Departamento", -- tabla
			"nombre", -- columna
			OLD.idDepartamento, -- id
			OLD.nombre, -- valorViejo
			NEW.nombre -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_departamento_bitacora_delete` AFTER DELETE ON `Departamento` FOR EACH ROW
BEGIN
	
	IF OLD.idDepartamento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"Departamento", -- tabla
			"idDepartamento", -- columna
			OLD.idDepartamento, -- id
			OLD.idDepartamento, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
 	IF OLD.nombre IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"Departamento", -- tabla
			"nombre", -- columna
			OLD.idDepartamento, -- id
			OLD.nombre, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_requerimiento_bitacora_insert` AFTER INSERT ON `Requerimiento` FOR EACH ROW
BEGIN
	
	IF NEW.idRequerimiento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"Requerimiento", -- tabla
			"idRequerimiento", -- columna
			NEW.idRequerimiento, -- id
			NULL, -- valorViejo
			NEW.idRequerimiento -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"Requerimiento", -- tabla
			"descripcion", -- columna
			NEW.idRequerimiento, -- id
			NULL, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_requerimiento_bitacora_update` AFTER UPDATE ON `Requerimiento` FOR EACH ROW
BEGIN
	
	IF NEW.idRequerimiento != OLD.idRequerimiento THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"Requerimiento", -- tabla
			"idRequerimiento", -- columna
			OLD.idRequerimiento, -- id
			OLD.idRequerimiento, -- valorViejo
			NEW.idRequerimiento -- valorNuevo
		); 	
   END IF;

   IF NEW.descripcion != OLD.descripcion THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"Requerimiento", -- tabla
			"descripcion", -- columna
			OLD.idRequerimiento, -- id
			OLD.descripcion, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_requerimiento_bitacora_delete` AFTER DELETE ON `Requerimiento` FOR EACH ROW
BEGIN
	
	IF OLD.idRequerimiento IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"Requerimiento", -- tabla
			"idRequerimiento", -- columna
			OLD.idRequerimiento, -- id
			OLD.idRequerimiento, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
 	IF OLD.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"Requerimiento", -- tabla
			"descripcion", -- columna
			OLD.idRequerimiento, -- id
			OLD.descripcion, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_tarea_bitacora_insert` AFTER INSERT ON `Tarea` FOR EACH ROW
BEGIN
	
	IF NEW.idTarea IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"Tarea", -- tabla
			"idTarea", -- columna
			NEW.idTarea, -- id
			NULL, -- valorViejo
			NEW.idTarea -- valorNuevo
		); 	
   END IF;
   
 	IF NEW.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"INSERT", -- operación
			NOW(), -- fecha y hora actual
			"Tarea", -- tabla
			"descripcion", -- columna
			NEW.idTarea, -- id
			NULL, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_tarea_bitacora_update` AFTER UPDATE ON `Tarea` FOR EACH ROW
BEGIN
	
	IF NEW.idTarea != OLD.idTarea THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"Tarea", -- tabla
			"idTarea", -- columna
			OLD.idTarea, -- id
			OLD.idTarea, -- valorViejo
			NEW.idTarea -- valorNuevo
		); 	
   END IF;

   IF NEW.descripcion != OLD.descripcion THEN -- si cambió el valor del campo... (hacer un IF como éste por cada columna que se quiera auditar)
   	INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"UPDATE", -- operación
			NOW(), -- fecha y hora actual
			"Tarea", -- tabla
			"descripcion", -- columna
			OLD.idTarea, -- id
			OLD.descripcion, -- valorViejo
			NEW.descripcion -- valorNuevo
		); 	
   END IF;
   
END$$

USE `PHC`$$
CREATE DEFINER = CURRENT_USER TRIGGER `PHC`.`tg_tarea_bitacora_delete` AFTER DELETE ON `Tarea` FOR EACH ROW
BEGIN
	
	IF OLD.idTarea IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"Tarea", -- tabla
			"idTarea", -- columna
			OLD.idTarea, -- id
			OLD.idTarea, -- valorViejo
			NULL -- valorNuevo
		); 	
   END IF;
   
 	IF OLD.descripcion IS NOT NULL THEN -- Si el campo no es NULL (hacer un IF como éste por cada columna que se quiera auditar)
		INSERT INTO Bitacora(host, usuario, operacion, fechaHora, tabla, columna, id, valorViejo, valorNuevo)
		VALUES (
			SUBSTRING(USER(), (INSTR(USER(),'@')+1)), -- host
			SUBSTRING(USER(), 1, (instr(user(),'@')-1)), -- usuario
			"DELETE", -- operación
			NOW(), -- fecha y hora actual
			"Tarea", -- tabla
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
-- Data for table `PHC`.`Empleado`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (1, 'Maturana', 'Julieta', '4265784', '2007-06-12', 45976135, '27-45976135-1', '1991-06-20', 1, '4215789', 'jmaturana@hotmail.com', 'Av. Francisco de Aguirre 1234', 'F');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (2, 'Fogliato', 'Luca', '4254662', '2015-09-21', 35116746, '20-35116746-1', '1994-02-03', 1, '4567812', 'lucafogliato@gmail.com', 'Junin 253', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (3, 'Grosse', 'Ivan', '4123793', '2009-03-25', 12354813, '20-12354813-1', '1994-04-09', 1, '4567812', 'ivangrosse@gmail.com', 'Santiago 4053', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (4, 'Arias', 'Martín', '5124354', '2012-03-14', 36459787, '20-36459787-1', '1983-06-02', 1, '4235678', 'martinarias@gmail.com', 'San Juan 387', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (5, 'Artero', 'Pablo', '4568794', '2009-03-25', 45876123, '20-45876123-1', '1994-02-19', 1, '4612357', 'pabloartero@hotmail.com', 'Emilio Castelar 386', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (6, 'Gordillo ', 'Mariano', '4657891', '2009-03-25', 4444444, '20-4444444-1', '1992-03-22', 1, '4612357', 'marianogordillo@gmail.com', 'Saavedra 1564', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (7, 'Gramajo', 'Melisa', '9546874', '2007-06-12', 45421642, '27-45421642-1', '1991-03-22', 1, '4561384', 'melisagramajo@hotmail.com', 'Chacabuco 327', 'F');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (8, 'Salas', 'Benjamín', '3546751', '2009-03-25', 15485615, '20-15485615-1', '1976-04-25', 1, '4613798', 'benjaminsalas@gmail.com', 'Santa fé 234', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (9, 'Cerutti', 'Facundo', '6452134', '2015-09-21', 46081345, '20-46081345-1', '1995-03-15', 1, '4745812', 'facundocerutti@gmail.com', 'Laprida 761', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (10, 'Yapura', 'José', '4521345', '2012-03-14', 45621355, '20-45621355-1', '1993-02-17', 1, '4457812', 'daniyapura@gmail.com', 'Ayacucho 451', 'M');
INSERT INTO `PHC`.`Empleado` (`idEmpleado`, `apellido`, `nombre`, `legajo`, `fechaIngreso`, `dni`, `cuil`, `fechaNacimiento`, `esActivo`, `telefono`, `email`, `domicilio`, `sexo`) VALUES (11, 'Dominguez', 'Juan', '5364311', '2007-06-12', 46891354, '20-46891354-1', '1992-03-19', 0, '4199851', 'juandominguez@hotmail.com', 'Necochea 2604', 'M');

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`Nivel`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`Nivel` (`idNivel`, `nombre`) VALUES (1, 'Estratégico');
INSERT INTO `PHC`.`Nivel` (`idNivel`, `nombre`) VALUES (2, 'Táctico');
INSERT INTO `PHC`.`Nivel` (`idNivel`, `nombre`) VALUES (3, 'Operativo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`Departamento`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (1, 'Dirección General');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (2, 'Dirección del Área de Negocios');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (3, 'Dirección del Área de Producción');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (4, 'Dirección del Área de Investigación, Desarrollo e Innovación');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (5, 'Dirección del Área de Administración');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (6, 'Marketing');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (7, 'Ventas');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (8, 'Análisis y Diseño');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (9, 'Desarrollo y calidad');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (10, 'Implementación y Pruebas');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (11, 'Administración del Conocimiento');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (12, 'Recursos Humanos');
INSERT INTO `PHC`.`Departamento` (`idDepartamento`, `nombre`) VALUES (13, 'Finanzas');

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`Usuario`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`Usuario` (`idEmpleado`, `nombreUsuario`, `contrasena`, `esAdministrador`, `habilitado`, `contrasenaRestaurada`) VALUES (10, 'jose', md5('jose'), 1, 1, 0);
INSERT INTO `PHC`.`Usuario` (`idEmpleado`, `nombreUsuario`, `contrasena`, `esAdministrador`, `habilitado`, `contrasenaRestaurada`) VALUES (1, 'julieta', md5('julieta'), 0, 1, 0);
INSERT INTO `PHC`.`Usuario` (`idEmpleado`, `nombreUsuario`, `contrasena`, `esAdministrador`, `habilitado`, `contrasenaRestaurada`) VALUES (4, 'jesus', md5('jesus'), 0, 1, 0);
INSERT INTO `PHC`.`Usuario` (`idEmpleado`, `nombreUsuario`, `contrasena`, `esAdministrador`, `habilitado`, `contrasenaRestaurada`) VALUES (11, 'juan', md5('juan'), 1, 0, 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`Puesto`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (1, 'Director General', 'Direccion general de la empresa', 1, 1, 1);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (2, 'Gerente del Área de Negocios', NULL, 1, 2, 2);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (3, 'Gerente del Área de Producción', NULL, 1, 3, 2);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (4, 'Gerente del Área de Investigación, Desarrollo e Innovación', NULL, 1, 4, 2);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (5, 'Gerente del Área de Administración', NULL, 1, 5, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (6, 'Encargado de Marketing', NULL, 1, 6, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (7, 'Encargado de ventas', NULL, 1, 7, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (8, 'Encargado de análisis y diseño', NULL, 1, 8, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (9, 'Encargado de desarrollo y calidad', NULL, 1, 9, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (10, 'Encargado de Implementación y pruebas', NULL, 1, 10, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (11, 'Encargado de la Administración del conocimiento', NULL, 1, 11, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (12, 'Encargado de Recursos Humanos', NULL, 1, 12, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (13, 'Encargado de Finanzas', NULL, 1, 13, 3);
INSERT INTO `PHC`.`Puesto` (`idPuesto`, `nombre`, `descripcion`, `esResponsableDpto`, `idDepartamento`, `idNivel`) VALUES (14, 'Programador Senior', NULL, 0, 9, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`HistorialEmpleado`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (1, '2007-06-12', '2015-09-21', 1, 1);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (2, '2007-06-12', NULL, 1, 2);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (3, '2007-06-12', '2009-03-25', 1, 6);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (4, '2007-06-12', '2009-03-25', 1, 7);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (5, '2007-06-12', '2012-03-14', 11, 3);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (6, '2007-06-12', '2009-03-25', 11, 8);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (7, '2007-06-12', '2009-03-25', 11, 9);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (8, '2007-06-12', '2009-03-25', 11, 10);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (9, '2007-06-12', '2012-03-14', 11, 5);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (10, '2007-06-12', '2012-03-14', 7, 12);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (11, '2007-06-12', '2012-03-14', 7, 13);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (12, '2009-03-25', NULL, 6, 6);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (13, '2009-03-25', NULL, 8, 7);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (14, '2009-03-25', '2012-03-14', 5, 8);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (15, '2009-03-25', '2012-03-14', 3, 9);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (16, '2009-03-25', NULL, 3, 10);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (17, '2012-03-14', '2015-09-21', 7, 5);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (18, '2012-03-14', NULL, 10, 12);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (19, '2012-03-14', NULL, 4, 13);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (20, '2012-03-14', NULL, 5, 3);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (21, '2012-03-14', NULL, 10, 8);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (22, '2012-03-14', NULL, 8, 9);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (23, '2015-09-21', NULL, 6, 1);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (24, '2015-09-21', NULL, 7, 4);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (25, '2015-09-21', NULL, 9, 11);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (26, '2015-09-21', NULL, 2, 5);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (27, '2015-09-21 ', NULL, 9, 14);
INSERT INTO `PHC`.`HistorialEmpleado` (`idHistorialEmpleado`, `fechaIngreso`, `fechaEgreso`, `idEmpleado`, `idPuesto`) VALUES (28, '2015-09-21', NULL, 3, 14);

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`Requerimiento`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`Requerimiento` (`idRequerimiento`, `descripcion`) VALUES (1, 'Estudios secundarios completos');
INSERT INTO `PHC`.`Requerimiento` (`idRequerimiento`, `descripcion`) VALUES (2, 'Ámplios conocimientos de programación en multiples lenguajes.');
INSERT INTO `PHC`.`Requerimiento` (`idRequerimiento`, `descripcion`) VALUES (3, 'Estudios formales en administración de empresas');

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`Tarea`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`Tarea` (`idTarea`, `descripcion`) VALUES (1, 'Se encarga de administrar, coordinar, dirigir y supervisar las actividades administrativas de la empresa');
INSERT INTO `PHC`.`Tarea` (`idTarea`, `descripcion`) VALUES (2, 'Planificar las actividades técnicas de la Unidad a cargo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`RequerimientoPuesto`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 1);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 2);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 3);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 4);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 5);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 6);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 7);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 8);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 9);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 10);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 11);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 12);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 13);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (1, 14);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (2, 14);
INSERT INTO `PHC`.`RequerimientoPuesto` (`idRequerimiento`, `idPuesto`) VALUES (3, 2);

COMMIT;


-- -----------------------------------------------------
-- Data for table `PHC`.`PuestoTarea`
-- -----------------------------------------------------
START TRANSACTION;
USE `PHC`;
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (1, 1);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (1, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (2, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (3, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (4, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (5, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (6, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (7, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (8, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (9, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (10, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (11, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (12, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (13, 2);
INSERT INTO `PHC`.`PuestoTarea` (`idPuesto`, `idTarea`) VALUES (14, 2);

COMMIT;

