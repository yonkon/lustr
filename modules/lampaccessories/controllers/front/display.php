<?php
/**
 * Created by PhpStorm.
 * User: Vlaimip
 * Date: 25.01.2016
 * Time: 6:02
 */
class lampaccessoriesdisplayModuleFrontController extends ModuleFrontController
{
  public function initContent()
  {
    parent::initContent();
    $this->setTemplate('display.tpl');
  }
}