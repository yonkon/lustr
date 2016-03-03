<?php
if(!defined('_PS_VERSION_') )
  exit;
/*
 * updated 3.03.2016
 */
class LampAccessories extends Module {
  public function __construct()
  {
    $this->name = 'lampaccessories';
    $this->tab = 'front_office_features';
    $this->version = '1.1';
    $this->author = 'Vladimir Sudarkov';
    $this->need_instance = 0;
    $this->ps_versions_compliancy = array('min' => '1.5', 'max' => '1.7');
//    $this->dependencies = array('producttab');
    $this->dependencies = array();

    parent::__construct();

    $this->displayName = $this->l('Lamp Accessories');
    $this->description = $this->l('Original module for Lamplus. Display associated lamps on product page');

    $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');

    if (!Configuration::get('LAMPACCESSORIES_NAME'))
      $this->warning = $this->l('No name provided');
  }

  public function install()
  {
    if (Shop::isFeatureActive())
      Shop::setContext(Shop::CONTEXT_ALL);

    return parent::install() &&
    $this->registerHook('lampAccessories') &&
    $this->registerHook('header') &&
    Configuration::updateValue('LAMPACCESSORIES_NAME', 'Lamp Accessories');
  }

  public function uninstall()
  {
    if (!parent::uninstall() ||
      !Configuration::deleteByName('LAMPACCESSORIES_NAME'))
      return false;
    return true;
  }

  public function getContent()
  {
    $output = null;

    if (Tools::isSubmit('submit'.$this->name))
    {
      $la_tabcount = strval(Tools::getValue('LAMPACCESSORIES_TABCOUNT'));
      if (!$la_tabcount  || empty($la_tabcount) || !Validate::isGenericName($la_tabcount))
        $output .= $this->displayError( $this->l('Invalid Configuration value') );
      else
      {
        Configuration::updateValue('LAMPACCESSORIES_TABCOUNT', intval($la_tabcount));
        $output .= $this->displayConfirmation($this->l('Settings updated'));
      }

      $la_itemcount = strval(Tools::getValue('LAMPACCESSORIES_ITEMCOUNT'));
      if (!$la_itemcount  || empty($la_itemcount) || !Validate::isGenericName($la_itemcount))
        $output .= $this->displayError( $this->l('Invalid Configuration value') );
      else
      {
        Configuration::updateValue('LAMPACCESSORIES_ITEMCOUNT', intval($la_itemcount));
        $output .= $this->displayConfirmation($this->l('Settings updated'));
      }

    }
    return $output.$this->displayForm();
  }

  public function displayForm()
  {
    // Get default Language
    $default_lang = (int)Configuration::get('PS_LANG_DEFAULT');

    // Init Fields form array
    $fields_form[0]['form'] = array(
      'legend' => array(
        'title' => $this->l('Settings'),
      ),
      'input' => array(
        array(
          'type' => 'text',
          'label' => $this->l('Максимальное количествово вкладок категорий лампочек'),
          'name' => 'LAMPACCESSORIES_TABCOUNT',
          'size' => 20,
          'required' => true,
          'value' => Configuration::get('LAMPACCESSORIES_TABCOUNT')
        ),
        array(
          'type' => 'text',
          'label' => $this->l('Максимальное количествово лампочек на вкладку'),
          'name' => 'LAMPACCESSORIES_ITEMCOUNT',
          'size' => 20,
          'required' => true,
          'value' => Configuration::get('LAMPACCESSORIES_ITEMCOUNT')
        )
      ),
      'submit' => array(
        'title' => $this->l('Save'),
        'class' => 'button'
      )
    );

    $helper = new HelperForm();

    // Module, token and currentIndex
    $helper->module = $this;
    $helper->name_controller = $this->name;
    $helper->token = Tools::getAdminTokenLite('AdminModules');
    $helper->currentIndex = AdminController::$currentIndex.'&configure='.$this->name;

    // Language
    $helper->default_form_language = $default_lang;
    $helper->allow_employee_form_lang = $default_lang;

    // Title and toolbar
    $helper->title = $this->displayName;
    $helper->show_toolbar = true;        // false -> remove toolbar
    $helper->toolbar_scroll = true;      // yes - > Toolbar is always visible on the top of the screen.
    $helper->submit_action = 'submit'.$this->name;
    $helper->toolbar_btn = array(
      'save' =>
        array(
          'desc' => $this->l('Save'),
          'href' => AdminController::$currentIndex.'&configure='.$this->name.'&save'.$this->name.
            '&token='.Tools::getAdminTokenLite('AdminModules'),
        ),
      'back' => array(
        'href' => AdminController::$currentIndex.'&token='.Tools::getAdminTokenLite('AdminModules'),
        'desc' => $this->l('Back to list')
      )
    );

    // Load current value
    $helper->fields_value['LAMPACCESSORIES_TABCOUNT'] = Configuration::get('LAMPACCESSORIES_TABCOUNT');
    $helper->fields_value['LAMPACCESSORIES_ITEMCOUNT'] = Configuration::get('LAMPACCESSORIES_ITEMCOUNT');

    return $helper->generateForm($fields_form);
  }


  public function hookLampAccessories(&$params) {
    $la_itemcount = Configuration::get('LAMPACCESSORIES_ITEMCOUNT');
    if(empty($la_itemcount)) {
      $la_itemcount = 4;
      Configuration::set('LAMPACCESSORIES_ITEMCOUNT', 4);
    }
    $la_tabcount = Configuration::get('LAMPACCESSORIES_TABCOUNT');
    if(empty($la_tabcount)) {
      $la_tabcount = 4;
      Configuration::set('LAMPACCESSORIES_TABCOUNT', 4);
    }

    $context = Context::getContext();
    $controller = $context->controller;
    $id_lang = (int)$context->language->id;
    /**
     * @var $prod Product
     */
    $prod = $controller->getProduct();
    if(empty($prod)) {
      return '';
    }


    $features = $prod->getFeatures($id_lang);
    $id_feature_value = null;
    $id_feature_values = array();

    $power_ids = array( // id_feature_value, // lang value
      152, //100
      28, //60
      87, //50
      7, //42
      183, //40
      64, //35
      270, //30
      22, //28
      247, //20
      253, //18
      267, //10
      217, //2
      298, //1
      231, //0.24
      209, //0.1
    );

    $sql = "SELECT v.*, l.*, l_n.id_feature_value AS id_feature_value_n, v_n.id_feature AS id_feature2
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
      ";
    $lampTypeFVs = Db::getInstance()->executeS(
      $sql
    );
    $lampTypeN_Values = array(); //id_feature для тип лампочки 1,2,3 (id_feature 40-42) => id_feature для тип лампы (id_feature 15)
    foreach($lampTypeFVs as $ltfv) {
      $lampTypeN_Values[$ltfv['id_feature_value_n']][] = $ltfv['id_feature_value'];
    }


    foreach ($features as $feature) {

      if($feature['id_feature'] == 16) { //Тип цоколя
        $id_feature_value = $feature['id_feature_value'];
        $id_feature_values[] = $feature['id_feature_value'];
      }

      if(in_array($feature['id_feature'], array(40, 41, 42) ) ) { //Тип лампы 1,2,3
        if(!isset($id_feature_values[15])) {
          $id_feature_values[15] = array();
        }
        $id_feature_value = $lampTypeN_Values[$feature['id_feature_value']];
        $id_feature_values[15] = array_merge($id_feature_values[15], $lampTypeN_Values[$feature['id_feature_value']] ); //15 - Тип лампы
      }

      if($feature['id_feature'] == 14) { //Мощность лампы
        $power_ind = array_search($feature['id_feature_value'], $power_ids);
        if($power_ind === false) {
          $id_feature_values[] = $feature['id_feature_value'];
        } else {
          $id_feature_values[] = array_slice($power_ids, $power_ind);
        }
      }

//      if($feature['id_feature'] == 38) { //Класс лампы
//        $id_feature_values[] = $feature['id_feature_value'];
//      }

      if($feature['id_feature'] == 43) { //Код лампочек
        $id_feature_values[] = $feature['id_feature_value'];
      }

    }


    if(empty($id_feature_value))
      return '';

    $lampIdCategory = 42;
    $lampIdCategories = array($lampIdCategory);
    $lampCategories = CategoryCore::getChildren($lampIdCategory, $id_lang);
    foreach($lampCategories as $lampCategory) {
      $lampIdCategories[] = $lampCategory['id_category'];
    }
    $sCatIds = join(', ', $lampIdCategories);
// $sCatIds=$prod->id_category_default;
    $sIdFeatureValues = join(', ', $id_feature_values);
    $sIdFeatureValues = '';
    $id_feature_values_count = count($id_feature_values);
    $i = 0;
    foreach ($id_feature_values as $id_fv) {
//      $id_fv = $id_feature_values[$i];
      $sIdFeatureValues .= "
      JOIN ps_feature_product f{$i}
        ON f{$i}.id_product = p.id_product
          AND f{$i}.id_feature_value " .
        ( is_array($id_fv) ?
          (" IN (" . join(', ', $id_fv)  ) .") " :
          (" = {$id_fv}")
        )
        . "
";
      $i++;
    }

//    $sql = "SELECT p.*, pl.*, cl.name AS category, f.*, i.id_image
    $sql = "SELECT p.*, pl.*, cl.name AS category, i.id_image
      FROM ps_product p
      JOIN ps_product_lang pl ON pl.id_product = p.id_product AND pl.id_lang={$id_lang}
      JOIN ps_category_lang cl ON cl.id_category=p.id_category_default AND cl.id_lang={$id_lang}
      {$sIdFeatureValues}
      LEFT JOIN ps_image i
        ON i.id_product = p.id_product
          AND i.cover=1
      WHERE p.id_category_default IN ($sCatIds) AND p.active=1
      ORDER BY  p.price DESC
      ";

    if($_REQUEST['debug'] == 2) {
      echo $sql;
      print_r( $lampTypeN_Values);
      print_r( $id_feature_values);
      echo "\nsIdFeatureValues = $sIdFeatureValues";
    }
//    $sql = "SELECT p.*, pl.*, cl.name AS category, i.id_image
//      FROM ps_product p
//      JOIN ps_product_lang pl ON pl.id_product = p.id_product AND pl.id_lang={$id_lang}
//      JOIN ps_category_lang cl ON cl.id_category=p.id_category_default AND cl.id_lang={$id_lang}
//      JOIN ps_feature_product f
//        ON f.id_product = p.id_product
//          AND f.id_feature_value = {$id_feature_value}
//      LEFT JOIN ps_image i
//        ON i.id_product = p.id_product
//          AND i.cover=1
//      WHERE p.id_category_default IN ($sCatIds) AND p.active=1
//      ORDER BY  p.price DESC
//      ";

    $lampAccessoriesAll = Db::getInstance()->executeS(
      $sql
    );

    $lampAccessories = array();
    $lampAccessoriesCount = array();
    foreach($lampAccessoriesAll as $lampAccessory) {
      if(count($lampAccessories[$lampAccessory['category']]) >= $la_itemcount)
        continue;
      $imageLink = Link::getImageLink($lampAccessory['link_rewrite'], $lampAccessory['id_image']);
      $productLink = $context->link->getProductLink($lampAccessory);
      $lampAccessory['url'] = $productLink;
      $lampAccessory['image_link'] = 'http://' .$imageLink;
      $lampAccessories[$lampAccessory['category']][] = $lampAccessory;
    }
    foreach ($lampAccessories as $ind => $cat) {
      $lampAccessoriesCount[$ind] = count($cat);
    }
    arsort($lampAccessoriesCount);
    $lampAccessoriesSorted = array();
    foreach($lampAccessoriesCount as $ind => $count) {
      $lampAccessoriesSorted[] = $lampAccessories[$ind];
    }

    $lampAccessories = array_slice($lampAccessoriesSorted, 0, $la_tabcount);

    $this->context->smarty->assign(
      array(
        'lampaccessories' => $lampAccessories,
        'my_module_name' => Configuration::get('LAMPACCESSORIES_NAME'),
        'my_module_link' => $this->context->link->getModuleLink('lampaccessories', 'display')
      )
    );
    return $this->display(__FILE__, 'lampaccessories.tpl');
  }

  public function hookDisplayHeader()
  {
    $this->context->controller->addCSS($this->_path.'css/lampaccessories.css', 'all');
//    $this->context->controller->addJS($this->_path.'js/lampaccessories.js');
  }

}

?>
