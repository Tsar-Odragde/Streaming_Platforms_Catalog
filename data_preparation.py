# -- Importación de librerías. -- #
import pandas as pd
import numpy as np
from datetime import datetime

from explode import explode_df

# -- Lectura de los CSV, creación de la columna 'Platform' y merge de los DataFrames. -- #
df1 = pd.read_csv('disney_plus_titles_fixed.csv', sep=';')
df2 = pd.read_csv('netflix_titles_fixed.csv', sep=';')

df1.insert(
    loc=2,
    column='platform',
    value='Disney+'
)
df2.insert(
    loc=2,
    column='platform',
    value='Netflix'
)
df_list = [df1, df2]
df = pd.concat(df_list, ignore_index=True)

# -- Reestructuración e imputación de valores faltantes de la columna 'DataAdded'. -- #
date_list = df.date_added.to_list()
for index, date in enumerate(date_list):
    if date is not np.nan:
        date = datetime.strptime(date.strip(), '%B %d, %Y')  # ej: Transformamos 'November 25, 2021' en '2021-11-25'
        date_list[index] = date.strftime('%Y-%m-%d')
    else:
        date_list[index] = date_list[index-1]  # Acá imputamos los valores faltantes por el valor anterior.
df['date_added'] = date_list

# -- Estructuración y fragmentación de la data en distintos archivos CSV para la ingesta en la DB. -- #
movies_df = df[df.type == 'Movie'].drop(['show_id', 'director', 'cast', 'country', 'duration', 'listed_in'], axis=1)
movies_df.index = (range(1, (movies_df.shape[0]+1)))  # Reindexación del DF.
movies_df.to_csv('movie.csv', index=True, sep=';')  # Creación de movie.csv.

tv_df = df[df.type == 'TV Show'].drop(['show_id', 'director', 'cast', 'country', 'duration', 'listed_in'], axis=1)
tv_df.index = (range(1, (tv_df.shape[0]+1)))
tv_df.to_csv('tv_show.csv', index=True, sep=';')  # Creación de tv_show.csv

direction_df = explode_df(df, ['title', 'director'], 'Movie')
direction_df.to_csv('direction.csv', index=True, sep=';')  # Creación de direction.csv

app_mov_df = explode_df(df, ['title', 'cast'], 'Movie')
app_mov_df.to_csv('appearance_movie.csv', index=True, sep=';')  # Creación de appearance_movie.csv

app_tv_df = explode_df(df, ['title', 'cast'], 'TV Show')
app_tv_df.to_csv('appearance_tv.csv', index=True, sep=';')  # Creación de appearance_tv.csv

prod_mov_df = explode_df(df, ['title', 'country'], 'Movie')
prod_mov_df.to_csv('production_mov.csv', index=True, sep=';')  # Creación de production_mov.csv

prod_tv_df = explode_df(df, ['title', 'country'], 'TV Show')
prod_tv_df.to_csv('production_tv.csv', index=True, sep=';')  # Creación de production_tv.csv

cat_mov_df = explode_df(df, ['title', 'listed_in'], 'Movie')
cat_mov_df.to_csv('class_mov.csv', index=True, sep=';')  # Creación de class_mov.csv

cat_tv_df = explode_df(df, ['title', 'listed_in'], 'TV Show')
cat_tv_df.to_csv('class_tv.csv', index=True, sep=';')  # Creación de class_tv.csv
