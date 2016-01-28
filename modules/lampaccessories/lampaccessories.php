<?php
if(!defined('_PS_VERSION_') )
 exit;

class LampAccessories extends Module {
  public function __construct()
  {
    $this->name = 'LampAccessories';
    $this->tab = 'front_office_features';
    $this->version = '1.0';
    $this->author = 'Vladimir Sudarkov';
    $this->need_instance = 0;
    $this->ps_versions_compliancy = array('min' => '1.5', 'max' => '1.7');
//    $this->dependencies = array('producttab');
    $this->dependencies = array();

    parent::__construct();

    $this->displayName = $this->l('Lamp Accessoriese');
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
      $my_module_name = strval(Tools::getValue('LAMPACCESSORIES_NAME'));
      if (!$my_module_name  || empty($my_module_name) || !Validate::isGenericName($my_module_name))
        $output .= $this->displayError( $this->l('Invalid Configuration value') );
      else
      {
        Configuration::updateValue('LAMPACCESSORIES_NAME', $my_module_name);
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
          'label' => $this->l('Configuration value'),
          'name' => 'LAMPACCESSORIES_NAME',
          'size' => 20,
          'required' => true
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
    $helper->fields_value['LAMPACCESSORIES_NAME'] = Configuration::get('LAMPACCESSORIES_NAME');

    return $helper->generateForm($fields_form);
  }


  public function hookLampAccessories(&$params) {
    $la_per_tab = Configuration::get('LAMPACCESSORIES_PER_TAB');
    if(empty($la_per_tab)) {
      $la_per_tab = 4;
      Configuration::set('LAMPACCESSORIES_PER_TAB', 4);
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
    foreach ($features as $feature) {
      if($feature['id_feature'] == 16) {
        $id_feature_value = $feature['id_feature_value'];
      }
    }

    if(empty($id_feature_value))
      return '';

    $lampIdCategory = 42;
    $lampIdCategory = $prod->id_category_default;
    $lampIdCategories = array($lampIdCategory);
    $lampCategories = CategoryCore::getChildren($lampIdCategory, $id_lang);
    foreach($lampCategories as $lampCategory) {
      $lampIdCategories[] = $lampCategory['id_category'];
    }
    $sCatIds = join(', ', $lampIdCategories);
// $sCatIds=$prod->id_category_default;
    $sql = "SELECT p.*, pl.*, cl.name AS category, f.*, i.id_image
      FROM ps_product p
      JOIN ps_product_lang pl ON pl.id_product = p.id_product AND pl.id_lang={$id_lang}
      JOIN ps_category_lang cl ON cl.id_category=p.id_category_default AND cl.id_lang={$id_lang}
      JOIN ps_feature_product f
        ON f.id_product = p.id_product
          AND f.id_feature_value = {$id_feature_value}
      LEFT JOIN ps_image i
        ON i.id_product = p.id_product
          AND i.cover=1
      WHERE p.id_category_default IN ($sCatIds)
      ";

    $lampAccessoriesAll = Db::getInstance()->executeS(
      $sql
    );

    $lampAccessories = array();
    foreach($lampAccessoriesAll as $lampAccessory) {
      if(count($lampAccessories[$lampAccessory['category']])>=$la_per_tab)
        continue;
      $imageLink = LinkCore::getImageLink($lampAccessory['link_rewrite'], $lampAccessory['id_image']);
      $lampAccessory['image_link'] = 'http://' .$imageLink;
      $lampAccessories[$lampAccessory['category']][] = $lampAccessory;
    }


      $this->context->smarty->assign(
      array(
        'lampaccessories' => $lampAccessories,
        'my_module_name' => Configuration::get('LAMPACCESSORIES_NAME'),
        'my_module_link' => $this->context->link->getModuleLink('lampaccessories', 'display')
      )
    );
    return $this->display(__FILE__, 'lampaccessories.tpl');
  }

  public function hookDisplayRightColumn(&$params) {
    return $this->hookLampAccessories($params);
  }

  public function hookDisplayHeader()
  {
    $this->context->controller->addCSS($this->_path.'css/lampaccessories.css', 'all');
  }

}

?>
