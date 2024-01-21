### SEGMENTO DE EJECUCIÓN 1

# 1.1 Generamos una copia del ejemplo a utilizar.
gsutil cp gs://spls/gsp164/endpoints-quickstart.zip .

# Se descomprime el archivo del ejemplo.
unzip endpoints-quickstart.zip

# 1.2 Accedemos al directorio donde se encuentran los scripts necesarios para implementar la API.
cd endpoints-quickstart/scripts

# 2.2 Ejecutamos el script para implementar la configuración de OpenAPI.
./deploy_api.sh

# 3.1 Ejecutamos el script para implementar el Backend de la API.
./deploy_app.sh

# 4.1 Después de implementar la API le enviamos solicitudes con el siguiente script.
./query_api.sh

# 4.2 Para correr una prueba con los parámetros de consulta iataCode ejecutamos el siguiente script.
./query_api.sh JFK

# 5.1 Se ejecuta el siguiente script para generar trafico. Esto enviara resultados al Log para realizar los pasos 5.2 y 5.3
./generate_traffic.sh

#Eperamos 5 o 10 repeticiones de la solicitud y presionamos Ctrl+C para detener el proceso

### SEGMENTO DE EJECUCIÓN 2

# 6.1 Aplicamos la configuración de cuota con al siguiente script.
./deploy_api.sh ../openapi_with_ratelimit.yaml

# 6.2 Desplegamos nuevamente el Endpoint con la nueva configuración, esto tardara varios minutos.
./deploy_app.sh

### SEGMENTO 3
# Creo una variable para darle el nombre de mi API KEY.
export MI_KEY="YunAzGu"

# Esto equivale a los pasos 6.3 y 6.4.

# Creo mi API KEY utilizando el parámetro de la variable.
gcloud alpha services api-keys create --display-name=$MI_KEY

# Equivalente del paso 6.5.
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName="$MI_KEY)

# Equivalente del paso 6.6.
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

# 6.7 Enviamos una nueva solicitud utilizando la API KEY que creamos.
./query_api_with_key.sh $API_KEY

### SEGMENTO 4
# 6.8 Ahora la API tiene una cuota limite de 5 solicitudes por segundo. ejecutamos el siguiente comando para enviar trafico a la API.
# Esperamos 5 o 10 segundos para detener el proceso con las teclas Ctrl+C
./generate_traffic_with_key.sh $API_KEY


### SEGMENTO 5
# Enviamos una solicitud autenticada ala API.
# Esperamos unos 5 minutos mas y podemos validar todos los pasos del laboratorio.
./query_api_with_key.sh $API_KEY