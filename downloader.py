# -- Librería usada -- #
import boto3


def get_csv(auth_key, auth_secret, bucket_name, remote_name, local_name):
    """
    Realiza la conexión a S3 y descarga el archivo CSV especificado.

    :type auth_key: string
    :param auth_key: Credencial de autenticación requerida para conectarse a S3.

    :type auth_secret: string
    :param auth_secret: Credencial de autenticación requerida para conectarse a S3.

    :type bucket_name: string
    :param bucket_name: Nombre del repositorio que contiene el archivo a descargar.

    :type remote_name: string
    :param remote_name: Nombre del archivo a descargar.

    :type local_name: string
    :param local_name: Nombre con el que queremos guardar el archivo localmente.
    """

    conection = boto3.resource(
        service_name='s3',
        aws_access_key_id=auth_key,
        aws_secret_access_key=auth_secret
    )
    conection.Bucket(bucket_name).download_file(Key=remote_name, Filename=local_name)
