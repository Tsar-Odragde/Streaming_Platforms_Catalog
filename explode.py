# -- Librerías usada -- # 
import pandas as pd
import numpy as np


def explode_df(full_df, to_keep, show_type):
    to_drop = [column_name for column_name in full_df.columns if column_name not in to_keep]
    df = full_df[full_df.type == show_type].drop(to_drop, axis=1)
    df_list = df.to_dict('records')

    for dic in df_list:
        if type(dic[to_keep[1]]) is str:
            dic[to_keep[1]] = dic[to_keep[1]].split(',')
        else:
            dic[to_keep[1]] = [np.nan]

    df = pd.DataFrame.from_records(df_list)
    df = df.explode(to_keep[1])
    df.index = range(1, df.shape[0]+1)
    return df
