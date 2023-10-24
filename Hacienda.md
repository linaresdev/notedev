# DGII Note
Mis Anotaciones de desarrollo

<p>La biblioteca Hacienda contiene todos los métodos para interactuar con el nuevo modelo de facturación electrónica.</p>

- Auth
- Issue
- Consult

### Auth - Autenticacion
```php	
	Hacienda::auth($authUrl); // callback JSON

	/*
	* Repuesta
	* {
	*  "token": "string",
	*  "expira": "2023-10-24T19:23:31.594Z",
	*  "expedido": "2023-10-24T19:23:31.594Z"
	* }
	*/
```
### Issue - Emisión
Url de prueba para la emision de conprobantes
` POST | 'https://ecf.dgii.gov.do/testecf/emisorreceptor/api/Emision/EmisionComprobantes'`

```php

Hacienda::issue($issueUrl);

/*
* REPUESTA
* curl -X 'POST' \
*  'https://ecf.dgii.gov.do/testecf/emisorreceptor/api/Emision/EmisionComprobantes' \
*  -H 'accept: */*' \
*  -H 'Content-Type: application/json-patch+json' \
*  -d '{
*  "rnc": "string",
*  "tipoEncf": "string",
*  "urlRecepcion": "string",
*  "urlAutenticacion": "string"
* }'
*/
```
