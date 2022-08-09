# -- Librerías y módulos usados. -- #
import os

from downloader import get_csv

# -- Variables de conexión. -- #
AWS_AUTH_KEY = os.environ.get('AWS_KEY_ID')
AWS_AUTH_SECRET = os.environ.get('AWS_SECRET_KEY')
S3_BUCKET_NAME = os.environ.get('REPOSITORY_NAME')
# -- Archivos a descargar. -- #
FILES_TO_DOWNLOAD = (
    'disney_plus_titles.csv',
    'netflix_titles.csv'
)

# -- Ejecución de las descargas. -- #
for file in FILES_TO_DOWNLOAD:
    get_csv(
        auth_key=AWS_AUTH_KEY,
        auth_secret=AWS_AUTH_SECRET,
        bucket_name=S3_BUCKET_NAME,
        remote_name=file,
        local_name=file
    )
