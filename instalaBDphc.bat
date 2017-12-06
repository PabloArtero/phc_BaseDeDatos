::Archivo .bat a modo de instalador de la base de datos
::Instala la BD sin datos, salvo por un solo usuario administrador con nombre de usuario "admin"
::y contraseña "admin"

::USAR LA RUTA DONDE ESTA EL EJECUTABLE DE MYSQL
cd C:\Program Files\MySQL\MySQL Server 5.7\bin

::EJECUTA EL SCRIPT DE LA CREACION DE LA DB
:: mysql -u"usuario" -p"contraseña" < ruta del script
mysql -uadmin -padmin < C:\Users\josdan\Downloads\script_con_usuario_inicial.sql