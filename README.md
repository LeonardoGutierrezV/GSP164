![Google Cloud](https://cdn.qwiklabs.com/GMOHykaqmlTHiqEeQXTySaMXYPHeIvaqa2qHEzw6Occ%3D)
# GSP164 Cloud Endpoints: Qwik Start 

En este repositorio se aborda la resolución del laboratorio GSP164 Cloud Endpoints.

[Acceso al laboratorio](https://www.cloudskillsboost.google/focuses/767?catalog_rank=%7B%22rank%22%3A1%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=29444936)

## 1. Obteniendo el código de ejemplo.

Este comando genera una copia del archivo que contiene lo necesario para la implementación de la API de ejemplo.

``` bash
gsutil cp gs://spls/gsp164/endpoints-quickstart.zip
```

Se debe descomprimir el archivo para poder realizar el despliegue del API.

``` bash
cd endpoints-quickstart
```
## 2. Implementando la configuración de Endpoints.

Es necesario acceder a la ubicación donde se encuentran los archivos que nos permiten desplegar la API.

``` bash
cd scripts
```
El comando implementa la configuración OpenAPI en el Service Management, usando el comando: **gcloud endpoints services deploy openapi.yaml**

``` bash
./deploy_api.sh
```

## 3. Implementación del Backend del API.

Para desplegar el API Backend, debes asegurarte de estar en el directorio endpoints-quickstart/scripts. Entonces hay que ejecutar el script.

``` bash
./deploy_app.sh
```
El script ejecuta el siguiente comando para crear un entorno App Engine flexible en la region indicada al inicio del laboratorio mediante la variable $REGION: **cloud app create --region="$REGION"**

El script ejecutara el comando **gcloud app deploy** para implementar el API de ejemplo en App Eengine.

## 4. Envío de solicitudes al API.

**1.** Después de implementar el API de ejemplo, puedes enviarle solicitudes. Para hacerlo debes ejecutar el siguiente script.

``` bash
./query_api.sh
``` 

El script hace ecos del comando curl y lo utiliza para enviar solicitudes al API y muestra los resultados en la terminal.

La API espera un parámetro de consulta, iataCode, que se establece en un código IATA airport válido, tal como SEA o JFK.

**2.** Para validarlo, ejecuta el siguiente ejemplo en la terminal.

## 5. Siguiendo la actividad de la API. 

**1.** Ejecuta el siguiente script para generación de trafico

``` bash
./generate_traffic.sh
``` 

**2.** Esto ejecutara actividad del API que podemos monitorizar desde el apartado Airport Codes, En servicios de Endpoints.

## 6. Agregar una cuota a la API

Cloudendpoints te permite asignar cuotas para poder controlar la tasa de llamadas a cada API. La cuotas se pueden utilizar para proteger la APIs de un uso excesivo.

**1.** Despliega la configuración de Endpoints con configuración de cuotas.

``` bash
./deploy_api.sh ../openapi_with_ratelimit.yaml
``` 

**2.** Re-despliega la APP para usar una nueva configuración de Endṕoints.

``` bash
./deploy_app.sh
``` 

Esto puede tardar varios minutos.

**3, 4.** Vamos a crear las credenciales y a obtener el identificador.

```bash
gcloud alpha services api-keys create --display-name="MiAppiKey"
``` 

**5.** Se obtiene el identificador del API Key para poder obtener el valor.
```bash
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=MiAppiKey")
``` 

**6.** Asignamos el valor de nuestra API Key a la variable API_KEY mediante el comando export.

```bash
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")
```

**7.** Envía tu solicitud a la API utilizando la API Key que se acaba de generar.

```bash
./query_api_with_key.sh $API_KEY
```

**8.** Ejecuta el siguiente comando para enviar trafico a la API y disparar el limite de la cuota.

```bash
./generate_traffic_with_key.sh $API_KEY
```

**9.** Despues de ejecutar el script por 5 o 10 segundos presiona **CTRL+C** para detener su ejecución.

**10.** enviamos otra solicitud autenticada a ala API.

```bash
./query_api_with_key.sh $API_KEY
```

Valida la respuesta de salida de la terminal.

```bash
{
     "code": 8,
     "message": "Insufficient tokens for quota 'airport_requests' and limit 'limit-on-airport-requests' of service 'example-project.appspot.com' for consumer 'api_key:AIzeSyDbdQdaSdhPMdiAuddd_FALbY7JevoMzAB'.",
     "details": [
      {
       "@type": "type.googleapis.com/google.rpc.DebugInfo",
       "stackEntries": [],
       "detail": "internal"
      }
     ]
    }
```
Si obtienes una salida diferente, trata de cotrrer el script nuevamente.

```bash
generate_traffic_with_key.sh

```
Ahora solo es necesario esperar unos 5 minutos para validar todos los puntos solicitados en el laboratorio.

O puedes copiar y pegar el contenido del script GSP164.sh en la terminal del laboratorio.
