set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool &1;

WITH  base AS (SELECT to_char(sysdate-1,'DD.MM.YYYY') FECHA,
                      to_char(sysdate-1,'DAY') DIA,
                      to_char(sysdate-8,'DD.MM.YYYY') SEM_ANTERIOR,
                      to_char(sysdate-8,'DAY') DIA_SEM_ANTERIOR
              FROM DUAL),
      wap_srv_raw AS  (SELECT to_char(FECHA,'DD.MM.YYYY') FECHA,
                              COUNT(1) CNT_FILAS
                      FROM  WAP_GATEWAY_SERVICE_ZTE_RAW
                      GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      wap_srv_day AS  (SELECT to_char(FECHA,'DD.MM.YYYY') FECHA,
                              COUNT(1) CNT_FILAS
                      FROM  WAP_GATEWAY_SERVICE_ZTE_DAY
                      GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      wap_srv_bh  AS  (SELECT to_char(FECHA,'DD.MM.YYYY') FECHA,
                              COUNT(1) CNT_FILAS
                      FROM  WAP_GATEWAY_SERVICE_ZTE_BH
                      GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      wap_srv_ibhw  AS  (SELECT to_char(FECHA,'DD.MM.YYYY') FECHA,
                        COUNT(1) CNT_FILAS
                        FROM  WAP_GATEWAY_SERVICE_ZTE_IBHW
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      wap_kpi_raw  AS   (SELECT 'WAP_GATEWAY_KPI_ZTE_RAW' TABLA,
                                to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  WAP_GATEWAY_KPI_ZTE_RAW
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      mob_asp_hour  AS  (SELECT 'MOBILEUM_ASP_HOUR' TABLA,
                                to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  MOBILEUM_ASP_HOUR
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      mob_asp_day AS    (SELECT 'MOBILEUM_ASP_DAY' TABLA,
                                to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  MOBILEUM_ASP_DAY
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      mob_asp_bh  AS    (SELECT 'MOBILEUM_ASP_BH' TABLA,
                                to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  MOBILEUM_ASP_BH
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      mob_asp_ibhw  AS  (SELECT to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  MOBILEUM_ASP_IBHW
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cdc_hour   AS (SELECT 'TEC_CE_CDC_TPS_HOUR' TABLA,
                                to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  TEC_CE_CDC_TPS_HOUR
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cdc_day    AS (SELECT 'TEC_CE_CDC_TPS_DAY' TABLA,
                                to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  TEC_CE_CDC_TPS_DAY
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cdc_bh  AS  (SELECT 'TEC_CE_CDC_TPS_BH' TABLA,
                              to_char(FECHA,'DD.MM.YYYY') FECHA,
                              COUNT(1) CNT_FILAS
                      FROM  TEC_CE_CDC_TPS_BH
                      GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cdc_ibhw  AS  (SELECT to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  TEC_CE_CDC_TPS_IBHW
                        GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cm_hour AS  (SELECT 'TEC_CE_CM_TPS_HOUR' TABLA,
                              to_char(FECHA,'DD.MM.YYYY') FECHA,
                              COUNT(1) CNT_FILAS
                      FROM  TEC_CE_CM_TPS_HOUR
                      GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cm_day  AS  (SELECT 'TEC_CE_CM_TPS_DAY' TABLA,
                              to_char(FECHA,'DD.MM.YYYY') FECHA,
                              COUNT(1) CNT_FILAS
                      FROM  TEC_CE_CM_TPS_DAY
                      GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cm_bh AS  (SELECT 'TEC_CE_CM_TPS_BH' TABLA,
                            to_char(FECHA,'DD.MM.YYYY') FECHA,
                            COUNT(1) CNT_FILAS
                    FROM  TEC_CE_CM_TPS_BH
                    GROUP BY to_char(FECHA,'DD.MM.YYYY')),
      tec_cm_ibhw  AS  (SELECT  to_char(FECHA,'DD.MM.YYYY') FECHA,
                                COUNT(1) CNT_FILAS
                        FROM  TEC_CE_CM_TPS_IBHW
                        GROUP BY to_char(FECHA,'DD.MM.YYYY'))
select  /*html*/
        base.fecha                Ayer, 
        base.dia                  Dia,
        'WAP_GATEWAY_SERVICE_ZTE' Proveedor,
        wap_srv_raw.cnt_filas     nivel_hour,
        wap_srv_day.cnt_filas     nivel_day,
        wap_srv_bh.cnt_filas      nivel_bh,
        base.SEM_ANTERIOR         Sem_Anterior,
        base.DIA_SEM_ANTERIOR     Dia_Sem_Anterior,
        wap_srv_ibhw.cnt_filas    nivel_ibhw
from  base,
      wap_srv_raw,
      wap_srv_day,
      wap_srv_bh,
      wap_srv_ibhw
where base.fecha = wap_srv_raw.fecha (+)
and   base.fecha = wap_srv_day.fecha (+)
and   base.fecha = wap_srv_bh.fecha (+)
and   base.SEM_ANTERIOR = wap_srv_ibhw.fecha (+) 
union all
select  
        base.fecha            Ayer, 
        base.dia              Dia,
        'WAP_GATEWAY_KPI_ZTE' Proveedor,
        wap_kpi_raw.cnt_filas nivel_hour,
        null                  nivel_day,
        null                  nivel_bh,
        base.SEM_ANTERIOR     Sem_Anterior,
        base.DIA_SEM_ANTERIOR Dia_Sem_Anterior,
        null                  nivel_ibhw
from  base,
      wap_kpi_raw
where base.fecha = wap_kpi_raw.fecha (+)
union all
select  base.fecha                Ayer, 
        base.dia                  Dia,
        'MOBILEUM_ASP' Proveedor,
        mob_asp_hour.cnt_filas nivel_hour,
        mob_asp_day.cnt_filas nivel_day,
        mob_asp_bh.cnt_filas nivel_bh,
        base.SEM_ANTERIOR         Sem_Anterior,
        base.DIA_SEM_ANTERIOR     Dia_Sem_Anterior,
        mob_asp_ibhw.cnt_filas nivel_ibhw
from    base,
        mob_asp_hour,
        mob_asp_day,
        mob_asp_bh,
        mob_asp_ibhw
where base.fecha = mob_asp_hour.fecha (+)
and   base.fecha = mob_asp_day.fecha (+)
and   base.fecha = mob_asp_bh.fecha (+)
and   base.SEM_ANTERIOR = mob_asp_ibhw.fecha (+)
union all
select  base.fecha                Ayer, 
        base.dia                  Dia,
        'TEC_CE_CDC_TPS' Proveedor,
        tec_cdc_hour.cnt_filas nivel_hour,
        tec_cdc_day.cnt_filas nivel_day,
        tec_cdc_bh.cnt_filas nivel_bh,
        base.SEM_ANTERIOR         Sem_Anterior,
        base.DIA_SEM_ANTERIOR     Dia_Sem_Anterior,
        tec_cdc_ibhw.cnt_filas nivel_ibhw
from    base,
        tec_cdc_hour,
        tec_cdc_day,
        tec_cdc_bh,
        tec_cdc_ibhw
where base.fecha = tec_cdc_hour.fecha (+)
and   base.fecha = tec_cdc_day.fecha (+)
and   base.fecha = tec_cdc_bh.fecha (+)
and   base.SEM_ANTERIOR = tec_cdc_ibhw.fecha (+)
union all
select  base.fecha                Ayer, 
        base.dia                  Dia,
        'TEC_CE_CM_TPS'           Proveedor,
        tec_cm_hour.cnt_filas     nivel_hour,
        tec_cm_day.cnt_filas      nivel_day,
        tec_cm_bh.cnt_filas       nivel_bh,
        base.SEM_ANTERIOR         Sem_Anterior,
        base.DIA_SEM_ANTERIOR     Dia_Sem_Anterior,
        tec_cm_ibhw.cnt_filas     nivel_ibhw
from    base,
        tec_cm_hour,
        tec_cm_day,
        tec_cm_bh,
        tec_cm_ibhw
where base.fecha = tec_cm_hour.fecha (+)
and   base.fecha = tec_cm_day.fecha (+)
and   base.fecha = tec_cm_bh.fecha (+)
and   base.SEM_ANTERIOR = tec_cm_ibhw.fecha (+);

spool off
exit;