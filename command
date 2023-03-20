## LISTAR FICHEROS ABIERTOS
lsof -i -n | egrep '\<sshd\>' | grep ESTABLISHED 

## COMPROBAR PROCESOS SSHD
ps -ef | grep -w "sshd:"

## ESTADÍSTICAS POR SOCKET DE CONEXIÓN
ss | grep ssh

## MOSTRAR TODOS LOS PID DE UN USUARIO 
sudo lsof -t -u user

## MOSTRA RUTA CON ARCHIVOS ABIERTOS
sudo lsof +D {path}

## LISTAR ARCHIVOS ABIERTOS BAJO PROTOCOLO TCP.
lsof -i
