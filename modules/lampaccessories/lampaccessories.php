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
    $this->registerHook('leftColumn') &&
    $this->registerHook('rightColumn') &&
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


  public function hookDisplayLeftColumn(&$params) {
    $this->context->smarty->assign(
      array(
        'my_module_name' => Configuration::get('LAMPACCESSORIES_NAME'),
        'my_module_link' => $this->context->link->getModuleLink('lampaccessories', 'display')
      )
    );
    return $this->display(__FILE__, 'lampaccessories.tpl');
  }

  public function hookDisplayRightColumn(&$params) {
    return $this->hookDisplayLeftColumn($params);
  }

  public function hookDisplayHeader()
  {
    $this->context->controller->addCSS($this->_path.'css/lampaccessories.css', 'all');
  }

}

?>
