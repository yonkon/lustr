<?php
/**
 * Created by PhpStorm.
 * User: X-iLeR
 * Date: 03.03.2016
 * Time: 1:26
 */

'SELECT * FROM `ps_feature_value`v JOIN ps_feature_value_lang l on l.`id_feature_value` = v.`id_feature_value` AND l.id_lang = 1'; //

'SELECT * FROM `ps_feature` v JOIN ps_feature_lang l ON l.`id_feature` = v.`id_feature` AND l.id_lang = 1';

"
SELECT v.*, l.*, l_n.id_feature_value AS id_feature_value_n, v_n.id_feature AS id_feature2
FROM `ps_feature_value` v
JOIN ps_feature_value_lang l
	ON l.`id_feature_value` = v.`id_feature_value`
AND l.id_lang = 1
AND id_feature = 15
JOIN ps_feature_value_lang l_n
  ON l_n.value = l.value
JOIN ps_feature_value v_n
  ON v_n.id_feature_value = l_n.id_feature_value
  AND v_n.id_feature IN (41, 42, 40)
"
