{*
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2014 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
{include file="$tpl_dir./errors.tpl"}
{if $errors|@count == 0}
  {if !isset($priceDisplayPrecision)}
    {assign var='priceDisplayPrecision' value=2}
  {/if}
  {if !$priceDisplay || $priceDisplay == 2}
    {assign var='productPrice' value=$product->getPrice(true, $smarty.const.NULL, 6)}
    {assign var='productPriceWithoutReduction' value=$product->getPriceWithoutReduct(false, $smarty.const.NULL)}
  {elseif $priceDisplay == 1}
    {assign var='productPrice' value=$product->getPrice(false, $smarty.const.NULL, 6)}
    {assign var='productPriceWithoutReduction' value=$product->getPriceWithoutReduct(true, $smarty.const.NULL)}
  {/if}
  <div itemscope itemtype="https://schema.org/Product">
    <meta itemprop="url" content="{$link->getProductLink($product)}">
    {if $content_only}<a href="{$link->getProductLink($product)|escape:'html':'UTF-8'}" target="_parent" class="btn btn-default button button-medium quickview-full-btn"><span>
							{l s='Подробнее'} <i class="icon-chevron-right right"></i>
						</span></a>{/if}
    <div class="primary_block row">

      {if isset($adminActionDisplay) && $adminActionDisplay}
        <div id="admin-action" class="container">
          <p class="alert alert-info">{l s='This product is not visible to your customers.'}
            <input type="hidden" id="admin-action-product-id" value="{$product->id}" />
            <a id="publish_button" class="btn btn-default button button-small" href="#">
              <span>{l s='Publish'}</span>
            </a>
            <a id="lnk_view" class="btn btn-default button button-small" href="#">
              <span>{l s='Back'}</span>
            </a>
          </p>
          <p id="admin-action-result"></p>
        </div>
      {/if}
      {if isset($confirmation) && $confirmation}
        <p class="confirmation">
          {$confirmation}
        </p>
      {/if}
      {if isset($warehouse_vars.headings_center) && $warehouse_vars.headings_center}
        <div class="col-xs-12">
          <div class="product-title product-title-center ">
            <h1 itemprop="name" class="page-heading">{$product->name|escape:'html':'UTF-8'}</h1>
            {hook h='productratingHook' productid=$product->id}
            {if isset($warehouse_vars.yotpo_stars)  && $warehouse_vars.yotpo_stars == 1}
              <div class="yotpo bottomLine"
                   data-appkey="{$yotpoAppkey|escape:'htmlall':'UTF-8'}"
                   data-domain="{$yotpoDomain|escape:'htmlall':'UTF-8'}"
                   data-product-id="{$yotpoProductId|intval}"
                   data-product-models="{$yotpoProductModel|escape:'htmlall':'UTF-8'}"
                   data-name="{$yotpoProductName|escape:'htmlall':'UTF-8'}"
                   data-url="{$yotpoProductLink|escape:'htmlall':'UTF-8'}"
                   data-image-url="{$yotpoProductImageUrl|escape:'htmlall':'UTF-8'}"
                   data-description="{$yotpoProductDescription|escape:'htmlall':'UTF-8'}"
                   data-bread-crumbs="{$yotpoProductBreadCrumbs|escape:'htmlall':'UTF-8'}"
                   data-lang="{$yotpoLanguage|escape:'htmlall':'UTF-8'}"></div>
            {/if}

            {if $product_manufacturer->id_manufacturer}
              {assign var="myfile" value="img/m/{$product_manufacturer->id_manufacturer}-mf_image2.jpg"}
              {if file_exists($myfile)}
                {if !$content_only}<a href="{$link->getmanufacturerLink($product->id_manufacturer, $product_manufacturer->link_rewrite)}" title="{l s='All products of this manufacturer'}"> {/if}  <span itemprop="brand" style="display: none">{$product_manufacturer->name}</span>
                <img class="imglog" src="{$base_dir_ssl}img/m/{$product_manufacturer->id_manufacturer}-mf_image2.jpg" />{if !$content_only}</a>{/if}{else}<label>{l s='Manufacturer:'}</label>
                {if !$content_only}<a class="manname" href="{$link->getmanufacturerLink($product->id_manufacturer, $product_manufacturer->link_rewrite)}" title="{l s='All products of this manufacturer'}">{/if}<span itemprop="brand">{$product_manufacturer->name}</span>{if !$content_only}</a>{/if}{/if} {/if}

            {if !$product->is_virtual && $product->condition}
              <p id="product_condition">
                <label>{l s='Condition:'} </label>
                {if $product->condition == 'new'}
                  <link itemprop="itemCondition" href="https://schema.org/NewCondition"/>
                  <span class="editable">{l s='New product'}</span>
                {elseif $product->condition == 'used'}
                  <link itemprop="itemCondition" href="https://schema.org/UsedCondition"/>
                  <span class="editable">{l s='Used'}</span>
                {elseif $product->condition == 'refurbished'}
                  <link itemprop="itemCondition" href="https://schema.org/RefurbishedCondition"/>
                  <span class="editable">{l s='Refurbished'}</span>
                {/if}
              </p>
            {/if}
          </div></div>
      {/if}

      <!-- left infos-->
      <div class="pb-left-column col-xs-12 {if isset($warehouse_vars.product_right_block) && $warehouse_vars.product_right_block && !$content_only}show-right-info col-md-{$warehouse_vars.product_left_size} col-lg-{$warehouse_vars.product_left_size}{else}col-md-{$warehouse_vars.product_left_size} col-lg-{$warehouse_vars.product_left_size}{/if}">
        <!-- product img-->
        <div id="image-block" class="clearfix">
          {if $product->on_sale}
            <span class="sale-label">{l s='Sale!'}</span>
          {elseif $product->specificPrice && $product->specificPrice.reduction && $productPriceWithoutReduction > $productPrice}
            <span class="sale-label">{l s='Reduced price!'}</span>
          {/if}
          {if $product->online_only}
            <span class="online-label {if isset($product->new) && $product->new == 1}online-label2{/if}">{l s='Online only'}</span>
          {/if}
          {if isset($product->new) && $product->new == 1}
            <span class="new-label">{l s='New'}</span>
          {/if}

          {if $have_image}
            <span id="view_full_size" class="easyzoom easyzoom--overlay easyzoom--with-thumbnails">
						{if $jqZoomEnabled && $have_image}
              <a class="jqzoom" title="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}" rel="gal1" href="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'thickbox_default')|escape:'html':'UTF-8'}">
                <img itemprop="image"  src="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'large_default')|escape:'html':'UTF-8'}" title="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}" alt="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}"/>
                {if !$content_only}
                  <span class="span_link">
							
							</span>
                {/if}
              </a>
						{else}
							<img id="bigpic" itemprop="image" src="{$link->getImageLink($product->link_rewrite, $cover.id_image, 'large_default')|escape:'html':'UTF-8'}" title="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}" alt="{if !empty($cover.legend)}{$cover.legend|escape:'html':'UTF-8'}{else}{$product->name|escape:'html':'UTF-8'}{/if}" width="{$largeSize.width}" height="{$largeSize.height}"/>
							{if !$content_only}
              <span class="span_link no-print"></span>
            {/if}
            {/if}
					</span>
          {else}
            <span id="view_full_size">
						<img itemprop="image" src="{$img_prod_dir}{$lang_iso}-default-large_default.jpg" id="bigpic" alt="" title="{$product->name|escape:'html':'UTF-8'}" width="{$largeSize.width}" height="{$largeSize.height}"/>
              {if !$content_only}
                <span class="span_link">
							
							</span>
              {/if}
					</span>
          {/if}
        </div> <!-- end image-block -->

        {if isset($images) && count($images) > 0}
          <!-- thumbnails -->
          <div id="views_block" class="clearfix {if isset($images) && count($images) < 2}hidden{/if}">
            {if isset($images) && count($images) > 4}
              <span class="view_scroll_spacer">
							<a id="view_scroll_left" class="" title="{l s='Other views'}" href="javascript:{ldelim}{rdelim}">
                {l s='Previous'}
              </a>
						</span>
            {/if}
            <div id="thumbs_list" {if isset($warehouse_vars.product_right_block) && $warehouse_vars.product_right_block}class="small-thumblist"{/if}>
              <ul id="thumbs_list_frame">
                {if isset($images)}
                  {foreach from=$images item=image name=thumbnails}
                    {assign var=imageIds value="`$product->id`-`$image.id_image`"}
                    {if !empty($image.legend)}
                      {assign var=imageTitle value=$image.legend|escape:'html':'UTF-8'}
                    {else}
                      {assign var=imageTitle value=$product->name|escape:'html':'UTF-8'}
                    {/if}
                    <li id="thumbnail_{$image.id_image}"{if $smarty.foreach.thumbnails.last} class="last"{/if}>
                      <a{if $jqZoomEnabled && $have_image} href="javascript:void(0);" rel="{literal}{{/literal}gallery: 'gal1', smallimage: '{$link->getImageLink($product->link_rewrite, $imageIds, 'large_default')|escape:'html':'UTF-8'}',largeimage: '{$link->getImageLink($product->link_rewrite, $imageIds, 'thickbox_default')|escape:'html':'UTF-8'}'{literal}}{/literal}"{else} href="{$link->getImageLink($product->link_rewrite, $imageIds, 'thickbox_default')|escape:'html':'UTF-8'}"	data-fancybox-group="other-views" class="fancybox{if $image.id_image == $cover.id_image} shown{/if}"{/if} title="{$imageTitle}">
                        <img class="img-responsive" id="thumb_{$image.id_image}" src="{$link->getImageLink($product->link_rewrite, $imageIds, 'cart_default')|escape:'html':'UTF-8'}" alt="{$imageTitle}" title="{$imageTitle}" {if isset($cartSize)} height="{$cartSize.height}" width="{$cartSize.width}"{/if} itemprop="image" />
                      </a>
                    </li>
                  {/foreach}
                {/if}
              </ul>
            </div> <!-- end thumbs_list -->
            {if isset($images) && count($images) > 4}
              <a id="view_scroll_right" title="{l s='Other views'}" href="javascript:{ldelim}{rdelim}">
                {l s='Next'}
              </a>
            {/if}
          </div> <!-- end views-block -->
          <!-- end thumbnails -->
        {/if}
        {if isset($images) && count($images) > 1}
          <p class="resetimg clear no-print">
					<span id="wrapResetImages" style="display: none;">
						<a href="{$link->getProductLink($product)|escape:'html':'UTF-8'}" data-id="resetImages">
              <i class="icon-repeat"></i>
              {l s='Display all pictures'}
            </a>
					</span>
          </p>
        {/if}
        {if !$content_only}
          <!-- usefull links-->
          <ul id="usefull_link_block" class="clearfix no-print">
            {if $HOOK_EXTRA_LEFT}{$HOOK_EXTRA_LEFT}{/if}
            <li class="print">
              <a href="javascript:print();">
                {l s='Print'}
              </a>
            </li>
          </ul>
        {/if}
      </div> <!-- end pb-left-column -->
      <!-- end left infos-->
      <!-- center infos -->

      <div class="pb-center-column col-xs-12 {if isset($warehouse_vars.product_right_block) && $warehouse_vars.product_right_block && !$content_only}col-md-{$warehouse_vars.product_center_size-3} col-lg-{$warehouse_vars.product_center_size-3}{else}col-md-{$warehouse_vars.product_center_size} col-lg-{$warehouse_vars.product_center_size}{/if}">
        {if isset($warehouse_vars.headings_center) && !$warehouse_vars.headings_center}
          <div class="product-title">
            <h1 itemprop="name">{$product->name|escape:'html':'UTF-8'}</h1>
            {if isset($warehouse_vars.yotpo_stars)  && $warehouse_vars.yotpo_stars == 1}
              <div class="yotpo bottomLine"
                   data-appkey="{$yotpoAppkey|escape:'htmlall':'UTF-8'}"
                   data-domain="{$yotpoDomain|escape:'htmlall':'UTF-8'}"
                   data-product-id="{$yotpoProductId|intval}"
                   data-product-models="{$yotpoProductModel|escape:'htmlall':'UTF-8'}"
                   data-name="{$yotpoProductName|escape:'htmlall':'UTF-8'}"
                   data-url="{$yotpoProductLink|escape:'htmlall':'UTF-8'}"
                   data-image-url="{$yotpoProductImageUrl|escape:'htmlall':'UTF-8'}"
                   data-description="{$yotpoProductDescription|escape:'htmlall':'UTF-8'}"
                   data-bread-crumbs="{$yotpoProductBreadCrumbs|escape:'htmlall':'UTF-8'}"
                   data-lang="{$yotpoLanguage|escape:'htmlall':'UTF-8'}"></div>
            {/if}

            {if $product_manufacturer->id_manufacturer}
              {assign var="myfile" value="img/m/{$product_manufacturer->id_manufacturer}-mf_image2.jpg"}
              {if file_exists($myfile)}
                {if !$content_only}<a href="{$link->getmanufacturerLink($product->id_manufacturer, $product_manufacturer->link_rewrite)}" title="{l s='All products of this manufacturer'}"> {/if}  <span  style="display: none" itemprop="brand">{$product_manufacturer->name}</span>
                <img class="imglog" src="{$base_dir_ssl}img/m/{$product_manufacturer->id_manufacturer}-mf_image2.jpg" />{if !$content_only}</a>{/if}{else}<label>{l s='Manufacturer:'}</label>
                {if !$content_only}<a class="manname" itemtype="https://schema.org/Organization" href="{$link->getmanufacturerLink($product->id_manufacturer, $product_manufacturer->link_rewrite)}" title="{l s='All products of this manufacturer'}">{/if}<span itemprop="brand">{$product_manufacturer->name}</span>{if !$content_only}</a>{/if}{/if} {/if}

            {if !$product->is_virtual && $product->condition}
              <p id="product_condition">
                <label>{l s='Condition:'} </label>
                {if $product->condition == 'new'}
                  <link itemprop="itemCondition" href="https://schema.org/NewCondition"/>
                  <span class="editable">{l s='New'}</span>
                {elseif $product->condition == 'used'}
                  <link itemprop="itemCondition" href="https://schema.org/UsedCondition"/>
                  <span class="editable">{l s='Used'}</span>
                {elseif $product->condition == 'refurbished'}
                  <link itemprop="itemCondition" href="https://schema.org/RefurbishedCondition"/>
                  <span class="editable">{l s='Refurbished'}</span>
                {/if}
              </p>
            {/if}
          </div>
        {/if}
        <p id="product_reference"{if empty($product->reference) || !$product->reference} style="display: none;"{/if}>
          <label>{l s='Reference:'} </label>
          <span class="editable" itemprop="sku"{if !empty($product->reference) && $product->reference} content="{$product->reference}{/if}">{if !isset($groups)}{$product->reference|escape:'html':'UTF-8'}{/if}</span>
        </p>
        {if $product->description_short || $packItems|@count > 0}
          <div id="short_description_block">
            {if $product->description_short}
              <div id="short_description_content" class="rte align_justify" itemprop="description">{$product->description_short}</div>
            {/if}

            {if $product->description}
              <p class="buttons_bottom_block">
                <a href="#descriptionContent" class="btn btn-default">
                  {l s='More details'}
                </a>
              </p>
            {/if}
            <!--{if $packItems|@count > 0}
						<div class="short_description_pack">
						<h3>{l s='Pack content'}</h3>
							{foreach from=$packItems item=packItem}
							
							<div class="pack_content">
								{$packItem.pack_quantity} x <a href="{$link->getProductLink($packItem.id_product, $packItem.link_rewrite, $packItem.category)|escape:'html':'UTF-8'}">{$packItem.name|escape:'html':'UTF-8'}</a>
								<p>{$packItem.description_short}</p>
							</div>
							{/foreach}
						</div>
					{/if}-->
          </div> <!-- end short_description_block -->
        {/if}
        {if $PS_STOCK_MANAGEMENT}<div class="available-box">{/if}
          {if ($display_qties == 1 && !$PS_CATALOG_MODE && $PS_STOCK_MANAGEMENT && $product->available_for_order)}
            <!-- number of item in stock -->
            <p id="pQuantityAvailable"{if $product->quantity <= 0} style="display: none;"{/if}>
              <span id="quantityAvailable">{$product->quantity|intval}</span>
              <span {if $product->quantity > 1} style="display: none;"{/if} id="quantityAvailableTxt">{l s='Item'}</span>
              <span {if $product->quantity == 1} style="display: none;"{/if} id="quantityAvailableTxtMultiple">{l s='Items'}</span>
            </p>
          {/if}
          <!-- availability or doesntExist -->
          <p id="availability_statut"{if !$PS_STOCK_MANAGEMENT || ($product->quantity <= 0 && !$product->available_later && $allow_oosp) || ($product->quantity > 0 && !$product->available_now) || !$product->available_for_order || $PS_CATALOG_MODE} style="display: none;"{/if}>
            {*<span id="availability_label">{l s='Availability:'}</span>*}
            <span id="availability_value" class="label{if $product->quantity <= 0 && !$allow_oosp} label-danger{elseif $product->quantity <= 0} label-warning{else} label-success{/if}">{if $product->quantity <= 0}{if $PS_STOCK_MANAGEMENT && $allow_oosp}{$product->available_later}{else}{l s='This product is no longer in stock'}{/if}{elseif $PS_STOCK_MANAGEMENT}{$product->available_now}{/if}</span>
          </p>
          {if $PS_STOCK_MANAGEMENT}
            {if !$product->is_virtual}{hook h="displayProductDeliveryTime" product=$product}{/if}
            <p class="warning_inline" id="last_quantities"{if ($product->quantity > $last_qties || $product->quantity <= 0) || $allow_oosp || !$product->available_for_order || $PS_CATALOG_MODE} style="display: none"{/if} >{l s='Warning: Last items in stock!'}</p>
          {/if}
          <p id="availability_date"{if ($product->quantity > 0) || !$product->available_for_order || $PS_CATALOG_MODE || !isset($product->available_date) || $product->available_date < $smarty.now|date_format:'%Y-%m-%d'} style="display: none;"{/if}>
            <span id="availability_date_label">{l s='Availability date:'}</span>
            <span id="availability_date_value">{if Validate::isDate($product->available_date)}{dateFormat date=$product->available_date full=false}{/if}</span>
          </p>
          <!-- Out of stock hook -->
          <div id="oosHook"{if $product->quantity > 0} style="display: none;"{/if}>
            {$HOOK_PRODUCT_OOS}
          </div>
          {if $PS_STOCK_MANAGEMENT}</div>{/if}
        <!-- buy block -->
        {if ($product->show_price && !isset($restricted_country_mode)) || isset($groups) || $product->reference || (isset($HOOK_PRODUCT_ACTIONS) && $HOOK_PRODUCT_ACTIONS)}
        <!-- add to cart form-->
        <form id="buy_block" {if $PS_CATALOG_MODE && !isset($groups) && $product->quantity > 0}class="hidden"{/if} action="{$link->getPageLink('cart')|escape:'html':'UTF-8'}" method="post">
          <!-- hidden datas -->
          <p class="hidden">
            <input type="hidden" name="token" value="{$static_token}" />
            <input type="hidden" name="id_product" value="{$product->id|intval}" id="product_page_product_id" />
            <input type="hidden" name="add" value="1" />
            <input type="hidden" name="id_product_attribute" id="idCombination" value="" />
          </p>
          {if (isset($HOOK_PRODUCT_ACTIONS) && $HOOK_PRODUCT_ACTIONS) || (isset($comparator_max_item) && $comparator_max_item)}
            <div class="more_buttons_bottom_block no-print">
              {hook h='productratingHook' productid=$product->id}
              {if isset($comparator_max_item) && $comparator_max_item}
                <p class="align_center">
                  <a title="Оставить отзыв" id="new_comment_tab_btn" class="open-comment-form" href="#new_comment_form">{l s=''} <i class="fa fa-paint-brush"></i></a>
                </p>
                <div class="compare additional_button no-print">
                  <a class="add_to_compare" href="{$link->getProductLink($product)}" data-id-product="{$product->id}" title="{l s='Add to Compare'}">{l s='Add to Compare'}</a>
                </div>
              {/if}
              {$HOOK_PRODUCT_ACTIONS}

            </div>
          {/if}
          <div class="box-info-product">
            <div class="product_attributes {if !isset($groups)} hidden{/if} clearfix">
              {if isset($groups)}
                <!-- attributes -->
                <div id="attributes">
                  <div class="clearfix"></div>
                  {foreach from=$groups key=id_attribute_group item=group}
                    {if $group.attributes|@count}
                      <fieldset class="attribute_fieldset">
                        <label class="attribute_label" {if $group.group_type != 'color' && $group.group_type != 'radio'}for="group_{$id_attribute_group|intval}"{/if}>{$group.name|escape:'html':'UTF-8'}:&nbsp;</label>
                        {assign var="groupName" value="group_$id_attribute_group"}
                        <div class="attribute_list">
                          {if ($group.group_type == 'select')}
                            <select name="{$groupName}" id="group_{$id_attribute_group|intval}" class="form-control attribute_select no-print">
                              {foreach from=$group.attributes key=id_attribute item=group_attribute}
                                <option value="{$id_attribute|intval}"{if (isset($smarty.get.$groupName) && $smarty.get.$groupName|intval == $id_attribute) || $group.default == $id_attribute} selected="selected"{/if} title="{$group_attribute|escape:'html':'UTF-8'}">{$group_attribute|escape:'html':'UTF-8'}</option>
                              {/foreach}
                            </select>
                          {elseif ($group.group_type == 'color')}
                            <ul id="color_to_pick_list" class="clearfix">
                              {assign var="default_colorpicker" value=""}
                              {foreach from=$group.attributes key=id_attribute item=group_attribute}
                                {assign var='img_color_exists' value=file_exists($col_img_dir|cat:$id_attribute|cat:'.jpg')}
                                <li{if $group.default == $id_attribute} class="selected"{/if}>
                                  <a href="{$link->getProductLink($product)|escape:'html':'UTF-8'}" id="color_{$id_attribute|intval}" name="{$colors.$id_attribute.name|escape:'html':'UTF-8'}" class="color_pick{if ($group.default == $id_attribute)} selected{/if}"{if !$img_color_exists && isset($colors.$id_attribute.value) && $colors.$id_attribute.value} style="background:{$colors.$id_attribute.value|escape:'html':'UTF-8'};"{/if} title="{$colors.$id_attribute.name|escape:'html':'UTF-8'}" {if $img_color_exists}style="background: url({$img_col_dir}{$id_attribute|intval}.jpg) repeat;"{/if}></a>
                                </li>
                                {if ($group.default == $id_attribute)}
                                  {$default_colorpicker = $id_attribute}
                                {/if}
                              {/foreach}
                            </ul>
                            <input type="hidden" class="color_pick_hidden" name="{$groupName|escape:'html':'UTF-8'}" value="{$default_colorpicker|intval}" />
                          {elseif ($group.group_type == 'radio')}
                            <ul>
                              {foreach from=$group.attributes key=id_attribute item=group_attribute}
                                <li>
                                  <input type="radio" class="attribute_radio" name="{$groupName|escape:'html':'UTF-8'}" value="{$id_attribute}" {if ($group.default == $id_attribute)} checked="checked"{/if} />
                                  <span>{$group_attribute|escape:'html':'UTF-8'}</span>
                                </li>
                              {/foreach}
                            </ul>
                          {/if}
                        </div> <!-- end attribute_list -->
                      </fieldset>
                    {/if}
                  {/foreach}
                </div> <!-- end attributes -->
              {/if}
            </div> <!-- end product_attributes -->
            {hook h='displayCountDownProduct' product=$product}
            <div class="box-cart-bottom clearfix {if $PS_CATALOG_MODE} unvisible{/if}">
              <div class="add_to_cart_container pull-right{if (!$allow_oosp && $product->quantity <= 0) || !$product->available_for_order || (isset($restricted_country_mode) && $restricted_country_mode) || $PS_CATALOG_MODE} unvisible{/if}">
                <p id="add_to_cart" class="buttons_bottom_block no-print">
                  <button type="submit" name="Submit" class="exclusive">
                    <span class="add_to_cart">{if $content_only && (isset($product->customization_required) && $product->customization_required)}{l s='Customize'}{else}{l s='Add to cart'}{/if}</span>
                  </button>
                </p>
                {hook h="displayProductSizeGuide" product=$product}
              </div>
              <!-- quantity wanted -->
              {if !$PS_CATALOG_MODE}
                <div id="quantity_wanted_p"{if (!$allow_oosp && $product->quantity <= 0) || !$product->available_for_order || $PS_CATALOG_MODE} style="display: none;"{/if}>
                  <label  for="quantity_wanted" class="qty-label">{l s='Quantity'}:</label>
                  <div class="quantity-input-wrapper">
                    <input type="text" name="qty" id="quantity_wanted" class="text" value="{if isset($quantityBackup)}{$quantityBackup|intval}{else}{if $product->minimal_quantity > 1}{$product->minimal_quantity}{else}1{/if}{/if}" />
                    <a href="#" data-field-qty="qty" class="transition-300 product_quantity_down">
                      <span><i class="icon-caret-down"></i></span>
                    </a>
                    <a href="#" data-field-qty="qty" class="transition-300 product_quantity_up ">
                      <span><i class="icon-caret-up"></i></span>
                    </a>
                  </div>
                  <span class="clearfix"></span>
                </div>
              {/if}
              <div class="content_prices clearfix">
                {if $product->show_price && !isset($restricted_country_mode) && !$PS_CATALOG_MODE}
                  <!-- prices -->
                  <div class="price">
                    <p class="our_price_display" itemprop="offers" itemscope itemtype="https://schema.org/Offer">{strip}
                        {if $product->quantity > 0}<link itemprop="availability" href="https://schema.org/InStock"/>{/if}
                        {if $priceDisplay >= 0 && $priceDisplay <= 2}
                          <span id="our_price_display" class="price" itemprop="price" content="{$productPrice}">{convertPrice price=$productPrice|floatval}</span>
                          <meta itemprop="priceCurrency" content="{$currency->iso_code}" />
                        {/if}
                      {/strip}</p>
                    {hook h="displayProductPriceBlock" product=$product type="price"}
                    {if $priceDisplay >= 0 && $priceDisplay <= 2}
                      {if $tax_enabled  && ((isset($display_tax_label) && $display_tax_label == 1) || !isset($display_tax_label))}
                        <span class="tax-label">{if $priceDisplay == 1} {l s='tax excl.'}{else} {l s='tax incl.'}{/if}</span>
                      {/if}
                    {/if}
                    <p id="old_price"{if (!$product->specificPrice || !$product->specificPrice.reduction)} class="hidden"{/if}>{strip}
                        {if $priceDisplay >= 0 && $priceDisplay <= 2}
                          {hook h="displayProductPriceBlock" product=$product type="old_price"}
                          <span id="old_price_display"><span class="price">{if $productPriceWithoutReduction > $productPrice}{convertPrice price=$productPriceWithoutReduction|floatval}{/if}</span>{if $tax_enabled && $display_tax_label == 1} {if $priceDisplay == 1}{l s='tax excl.'}{else}{l s='tax incl.'}{/if}{/if}</span>
                        {/if}
                      {/strip}</p>
                    {if $priceDisplay == 2}
                      <br />
                      <span id="pretaxe_price">{strip}
										<span id="pretaxe_price_display">{convertPrice price=$product->getPrice(false, $smarty.const.NULL)}</span> {l s='tax excl.'}
									{/strip}</span>
                    {/if}
                  </div> <!-- end prices -->
                  <p id="reduction_percent" {if !$product->specificPrice || $product->specificPrice.reduction_type != 'percentage'} style="display:none;"{/if}>{strip}
                      <span id="reduction_percent_display">
										{if $product->specificPrice && $product->specificPrice.reduction_type == 'percentage'}-{$product->specificPrice.reduction*100}%{/if}
									</span>
                    {/strip}</p>
                  <p id="reduction_amount" {if !$product->specificPrice || $product->specificPrice.reduction_type != 'amount' || $product->specificPrice.reduction|floatval ==0} style="display:none"{/if}>{strip}
                      <span id="reduction_amount_display">
									{if $product->specificPrice && $product->specificPrice.reduction_type == 'amount' && $product->specificPrice.reduction|floatval !=0}
                    -{convertPrice price=$productPriceWithoutReduction|floatval-$productPrice|floatval}
                  {/if}
									</span>
                    {/strip}</p>
                  {if $packItems|@count && $productPrice < $product->getNoPackPrice()}
                    <p class="pack_price">{l s='Instead of'} <span style="text-decoration: line-through;">{convertPrice price=$product->getNoPackPrice()}</span></p>
                  {/if}
                  {if $product->ecotax != 0}
                    <p class="price-ecotax">{l s='Including'} <span id="ecotax_price_display">{if $priceDisplay == 2}{$ecotax_tax_exc|convertAndFormatPrice}{else}{$ecotax_tax_inc|convertAndFormatPrice}{/if}</span> {l s='for ecotax'}
                      {if $product->specificPrice && $product->specificPrice.reduction}
                        <br />{l s='(not impacted by the discount)'}
                      {/if}
                    </p>
                  {/if}
                  {if !empty($product->unity) && $product->unit_price_ratio > 0.000000}
                    {math equation="pprice / punit_price" pprice=$productPrice  punit_price=$product->unit_price_ratio assign=unit_price}
                    <p class="unit-price"><span id="unit_price_display">{convertPrice price=$unit_price}</span> {l s='per'} {$product->unity|escape:'html':'UTF-8'}</p>
                    {hook h="displayProductPriceBlock" product=$product type="unit_price"}
                  {/if}
                {/if} {*close if for show price*}
                {hook h="displayProductPriceBlock" product=$product type="weight" hook_origin='product_sheet'}

                <div class="clear"></div>

              </div> <!-- end content_prices -->
              <!-- minimal quantity wanted -->
              <p id="minimal_quantity_wanted_p"{if $product->minimal_quantity <= 1 || !$product->available_for_order || $PS_CATALOG_MODE} style="display: none;"{/if}>
                {l s='The minimum purchase order quantity for the product is'} <b id="minimal_quantity_label">{$product->minimal_quantity}</b>



            </div>
            <div class="buy_to_one">{$HOOK_PRODUCT_ACTIONS}</div>
            <!-- end box-cart-bottom -->
          </div> <!-- end box-info-product -->
        </form>
        {/if}<!-- end buy block -->

        {if !isset($warehouse_vars.product_right_block) || !$warehouse_vars.product_right_block}
          {$HOOK_EXTRA_RIGHT}
        {/if}

      </div>
      <!-- end center infos-->
      {if !$content_only}
        {if isset($warehouse_vars.product_right_block) && $warehouse_vars.product_right_block}
          <!-- pb-right-column-->
          <div class="pb-right-column col-xs-12 col-md-3 col-lg-3">
            <div class="pb-right-column-content">
              {if isset($warehouse_vars.accesories_position) && $warehouse_vars.accesories_position}
                {if isset($accessories) && $accessories}
                  <!--Accessories -->
                  <section class="page-product-box flexslider_carousel_block accesories-slider">
                    <h3 class="page-product-heading">{l s='Accessories'}</h3>
                    {include file="$tpl_dir./product-list-small.tpl" products=$accessories
                    iqitGenerator=1 accesories=1 line_xs=1 line_ms=1 line_sm=1 line_md=1 line_lg=1 colnb=2}
                  </section>
                  <!--end Accessories -->
                {/if}{/if}
              {hook h='productPageRight'}
              {$HOOK_EXTRA_RIGHT}
            </div>
          </div> <!-- end pb-right-column-->
        {/if}{/if}
    </div> <!-- end primary_block -->
    {if !$content_only}
      {if (isset($quantity_discounts) && count($quantity_discounts) > 0)}
        <!-- quantity discount -->
        <section class="page-product-box">
          <h3 class="page-product-heading">{l s='Volume discounts'}</h3>
          <div id="quantityDiscount">
            <table class="std table-product-discounts">
              <thead>
              <tr>
                <th>{l s='Quantity'}</th>
                <th>{if $display_discount_price}{l s='Price'}{else}{l s='Discount'}{/if}</th>
                <th>{l s='You Save'}</th>
              </tr>
              </thead>
              <tbody>
              {foreach from=$quantity_discounts item='quantity_discount' name='quantity_discounts'}
                <tr id="quantityDiscount_{$quantity_discount.id_product_attribute}" class="quantityDiscount_{$quantity_discount.id_product_attribute}" data-discount-type="{$quantity_discount.reduction_type}" data-discount="{$quantity_discount.real_value|floatval}" data-discount-quantity="{$quantity_discount.quantity|intval}">
                  <td>
                    {$quantity_discount.quantity|intval}
                  </td>
                  <td>
                    {if $quantity_discount.price >= 0 || $quantity_discount.reduction_type == 'amount'}
                      {if $display_discount_price}
                        {if $quantity_discount.reduction_tax == 0 && !$quantity_discount.price}
                          {convertPrice price = $productPriceWithoutReduction|floatval-($productPriceWithoutReduction*$quantity_discount.reduction_with_tax)|floatval}
                        {else}
                          {convertPrice price=$productPriceWithoutReduction|floatval-$quantity_discount.real_value|floatval}
                        {/if}
                      {else}
                        {convertPrice price=$quantity_discount.real_value|floatval}
                      {/if}
                    {else}
                      {if $display_discount_price}
                        {if $quantity_discount.reduction_tax == 0}
                          {convertPrice price = $productPriceWithoutReduction|floatval-($productPriceWithoutReduction*$quantity_discount.reduction_with_tax)|floatval}
                        {else}
                          {convertPrice price = $productPriceWithoutReduction|floatval-($productPriceWithoutReduction*$quantity_discount.reduction)|floatval}
                        {/if}
                      {else}
                        {$quantity_discount.real_value|floatval}%
                      {/if}
                    {/if}
                  </td>
                  <td>
                    <span>{l s='Up to'}</span>
                    {if $quantity_discount.price >= 0 || $quantity_discount.reduction_type == 'amount'}
                      {$discountPrice=$productPriceWithoutReduction|floatval-$quantity_discount.real_value|floatval}
                    {else}
                      {$discountPrice=$productPriceWithoutReduction|floatval-($productPriceWithoutReduction*$quantity_discount.reduction)|floatval}
                    {/if}
                    {$discountPrice=$discountPrice * $quantity_discount.quantity}
                    {$qtyProductPrice=$productPriceWithoutReduction|floatval * $quantity_discount.quantity}
                    {convertPrice price=$qtyProductPrice - $discountPrice}
                  </td>
                </tr>
              {/foreach}
              </tbody>
            </table>
          </div>
        </section>
      {/if}
      {if isset($packItems) && $packItems|@count > 0}
        <section id="blockpack">
          <h3 class="page-product-heading">{l s='Pack content'}</h3>
          {include file="$tpl_dir./product-list.tpl" products=$packItems}
        </section>
      {/if}
      <a name="descriptionContent"></a>
      <!-- Tab headings -->
      <a name="tabs-ett"></a>
      <div class="product-tabs-container">
        {if isset($warehouse_vars.product_tabs) && $warehouse_vars.product_tabs}
          <ul class="nav nav-tabs pr-nav-tabs">
            {if isset($product) && $product->description}<li><a href="#descriptionTab" data-toggle="tab">{l s='More info'}</a></li>{/if}
            {if isset($features) && $features}<li><a href="#featuresTab" data-toggle="tab">{l s='Data sheet'}</a></li>{/if}
            {if isset($product) && $product->customizable}<li><a href="#customizationsTab" data-toggle="tab">{l s='Product customization'}</a></li>{/if}
            {if isset($attachments) && $attachments}<li><a href="#attachmentsTab" data-toggle="tab">{l s='Download'}</a></li>{/if}
            {$HOOK_PRODUCT_TAB}
          </ul>
        {/if}
        {if isset($warehouse_vars.product_tabs) && $warehouse_vars.product_tabs}
        <!-- Tab panes -->
        <div class="tab-content pr-tab-content">
          {/if}
          {if isset($product) && $product->description}
          <!-- More info -->
          {if isset($warehouse_vars.product_tabs) && $warehouse_vars.product_tabs}
          <section class="page-product-box tab-pane fade" id="descriptionTab">
            {else}
            <section class="page-product-box" id="descriptionTab">
              <h3 class="page-product-heading">{l s='More info'}</h3>
              {/if}
              <!-- full description -->

              <div  class="rte">{$product->description}</div>
            </section>
            <!--end  More info -->
            {/if}

            {if isset($features) && $features}
            <!-- Data sheet -->
            {if isset($warehouse_vars.product_tabs) && $warehouse_vars.product_tabs}
            <section class="page-product-box tab-pane fade" id="featuresTab">
              {else}
              <section class="page-product-box" id="descriptionTab">
                <h3 class="page-product-heading">{l s='Data sheet'}</h3>
                {/if}
                <table class="table-data-sheet">
                  {foreach from=$features item=feature}
                    <tr class="{cycle values="odd,even"}">
                      {if isset($feature.value) && !in_array($feature.id_feature, array(40,41,42,43))}

                        <td>{$feature.name|escape:'html':'UTF-8'}</td>
                        <td>{$feature.value|escape:'html':'UTF-8'}</td>
                        {*<td>{$feature.id_feature|escape:'html':'UTF-8'}</td>*}
                      {/if}
                    </tr>
                  {/foreach}
                </table>
              </section>
              <!--end Data sheet -->
              {/if}



              {if isset($product) && $product->customizable}
              <!--Customization -->
              {if isset($warehouse_vars.product_tabs) && $warehouse_vars.product_tabs}
              <section class="page-product-box tab-pane fade" id="customizationsTab">
                {else}
                <section class="page-product-box" id="customizationsTab">
                  <h3 class="page-product-heading">{l s='Product customization'}</h3>
                  {/if}

                  <!-- Customizable products -->
                  <form method="post" action="{$customizationFormTarget}" enctype="multipart/form-data" id="customizationForm" class="clearfix">
                    <p class="infoCustomizable">
                      {l s='After saving your customized product, remember to add it to your cart.'}
                      {if $product->uploadable_files}
                        <br />
                        {l s='Allowed file formats are: GIF, JPG, PNG'}{/if}
                    </p>
                    {if $product->uploadable_files|intval}
                      <div class="customizableProductsFile">
                        <ul id="uploadable_files" class="clearfix">
                          {counter start=0 assign='customizationField'}
                          {foreach from=$customizationFields item='field' name='customizationFields'}
                            {if $field.type == 0}
                              <li class="customizationUploadLine{if $field.required} required{/if}">{assign var='key' value='pictures_'|cat:$product->id|cat:'_'|cat:$field.id_customization_field}
                                {if isset($pictures.$key)}
                                  <div class="customizationUploadBrowse">
                                    <img src="{$pic_dir}{$pictures.$key}_small" alt="" />
                                    <a href="{$link->getProductDeletePictureLink($product, $field.id_customization_field)|escape:'html':'UTF-8'}" title="{l s='Delete'}" >
                                      <img src="{$img_dir}icon/delete.gif" alt="{l s='Delete'}" class="customization_delete_icon" width="11" height="13" />
                                    </a>
                                  </div>
                                {/if}
                                <div class="customizationUploadBrowse form-group">
                                  <label class="customizationUploadBrowseDescription">
                                    {if !empty($field.name)}
                                      {$field.name}
                                    {else}
                                      {l s='Please select an image file from your computer'}
                                    {/if}
                                    {if $field.required}<sup>*</sup>{/if}
                                  </label>
                                  <input type="file" name="file{$field.id_customization_field}" id="img{$customizationField}" class="form-control customization_block_input {if isset($pictures.$key)}filled{/if}" />
                                </div>
                              </li>
                              {counter}
                            {/if}
                          {/foreach}
                        </ul>
                      </div>
                    {/if}
                    {if $product->text_fields|intval}
                      <div class="customizableProductsText">
                        <ul id="text_fields">
                          {counter start=0 assign='customizationField'}
                          {foreach from=$customizationFields item='field' name='customizationFields'}
                            {if $field.type == 1}
                              <li class="customizationUploadLine{if $field.required} required{/if}">
                                <label for ="textField{$customizationField}">
                                  {assign var='key' value='textFields_'|cat:$product->id|cat:'_'|cat:$field.id_customization_field}
                                  {if !empty($field.name)}
                                    {$field.name}
                                  {/if}
                                  {if $field.required}<sup>*</sup>{/if}
                                </label>
										<textarea name="textField{$field.id_customization_field}" class="form-control customization_block_input" id="textField{$customizationField}" rows="3" cols="20">{strip}
											{if isset($textFields.$key)}
                        {$textFields.$key|stripslashes}
                      {/if}
										{/strip}</textarea>
                              </li>
                              {counter}
                            {/if}
                          {/foreach}
                        </ul>
                      </div>
                    {/if}
                    <p id="customizedDatas">
                      <input type="hidden" name="quantityBackup" id="quantityBackup" value="" />
                      <input type="hidden" name="submitCustomizedDatas" value="1" />
                      <button class="button btn btn-default button button-small" name="saveCustomization">
                        <span>{l s='Save'}</span>
                      </button>
						<span id="ajax-loader" class="unvisible">
							<img src="{$img_ps_dir}loader.gif" alt="loader" />
						</span>
                    </p>
                  </form>
                  <p class="clear required"><sup>*</sup> {l s='required fields'}</p>
                </section>
                <!--end Customization -->
                {/if}

                {if isset($attachments) && $attachments}
                <!--Download -->
                {if isset($warehouse_vars.product_tabs) && $warehouse_vars.product_tabs}
                <section class="page-product-box tab-pane fade" id="attachmentsTab">
                  {else}
                  <section class="page-product-box" id="attachmentsTab">
                    <h3 class="page-product-heading">{l s='Download'}</h3>
                    {/if}

                    {foreach from=$attachments item=attachment name=attachements}
                      {if $smarty.foreach.attachements.iteration %3 == 1}<div class="row">{/if}
                      <div class="col-lg-4">
                        <h4><a href="{$link->getPageLink('attachment', true, NULL, "id_attachment={$attachment.id_attachment}")|escape:'html':'UTF-8'}">{$attachment.name|escape:'html':'UTF-8'}</a></h4>
                        <p class="text-muted">{$attachment.description|escape:'html':'UTF-8'}</p>
                        <a class="btn btn-default btn-block" href="{$link->getPageLink('attachment', true, NULL, "id_attachment={$attachment.id_attachment}")|escape:'html':'UTF-8'}">
                          <i class="icon-download"></i>
                          {l s="Download"} ({Tools::formatBytes($attachment.file_size, 2)})
                        </a>
                        <hr>
                      </div>
                      {if $smarty.foreach.attachements.iteration %3 == 0 || $smarty.foreach.attachements.last}</div>{/if}
                    {/foreach}
                  </section>
                  <!--end Download -->
                  {/if}

                  {if isset($HOOK_PRODUCT_TAB_CONTENT) && $HOOK_PRODUCT_TAB_CONTENT}{$HOOK_PRODUCT_TAB_CONTENT}{/if}
                  {if isset($warehouse_vars.product_tabs) && $warehouse_vars.product_tabs}
        </div>
        {/if}
      </div>

      <!-- Lamp Accessories -->
      {if isset($HOOK_LAMP_ACCESSORIES)}
        {$HOOK_LAMP_ACCESSORIES}
      {/if}
      <!-- end Lamp Accessories -->




      {if !isset($warehouse_vars.accesories_position) || !$warehouse_vars.accesories_position}
        {if isset($accessories) && $accessories}
          <!--Accessories -->
          <section class="page-product-box flexslider_carousel_block">
            <h3 class="page-product-heading">{l s='Accessories'}</h3>
            {include file="$tpl_dir./product-slider.tpl" products=$accessories id='accessories_slider'}
          </section>
          <!--end Accessories -->
        {/if}{/if}
      {if isset($HOOK_PRODUCT_FOOTER) && $HOOK_PRODUCT_FOOTER}{$HOOK_PRODUCT_FOOTER}{/if}
      <!-- description & features -->

    {/if}
  </div> <!-- itemscope product wrapper -->
  {strip}
    {if isset($smarty.get.ad) && $smarty.get.ad}
      {addJsDefL name=ad}{$base_dir|cat:$smarty.get.ad|escape:'html':'UTF-8'}{/addJsDefL}
    {/if}
    {if isset($smarty.get.adtoken) && $smarty.get.adtoken}
      {addJsDefL name=adtoken}{$smarty.get.adtoken|escape:'html':'UTF-8'}{/addJsDefL}
    {/if}
    {addJsDef allowBuyWhenOutOfStock=$allow_oosp|boolval}
    {addJsDef availableNowValue=$product->available_now|escape:'quotes':'UTF-8'}
    {addJsDef availableLaterValue=$product->available_later|escape:'quotes':'UTF-8'}
    {addJsDef attribute_anchor_separator=$attribute_anchor_separator|escape:'quotes':'UTF-8'}
    {addJsDef attributesCombinations=$attributesCombinations}
    {addJsDef currentDate=$smarty.now|date_format:'%Y-%m-%d %H:%M:%S'}
    {if isset($combinations) && $combinations}
      {addJsDef combinations=$combinations}
      {addJsDef combinationsFromController=$combinations}
      {addJsDef displayDiscountPrice=$display_discount_price}
      {addJsDefL name='upToTxt'}{l s='Up to' js=1}{/addJsDefL}
    {/if}
    {if isset($combinationImages) && $combinationImages}
      {addJsDef combinationImages=$combinationImages}
    {/if}
    {addJsDef customizationId=$id_customization}
    {addJsDef customizationFields=$customizationFields}
    {addJsDef default_eco_tax=$product->ecotax|floatval}
    {addJsDef displayPrice=$priceDisplay|intval}
    {addJsDef ecotaxTax_rate=$ecotaxTax_rate|floatval}
    {if isset($cover.id_image_only)}
      {addJsDef idDefaultImage=$cover.id_image_only|intval}
    {else}
      {addJsDef idDefaultImage=0}
    {/if}
    {addJsDef img_ps_dir=$img_ps_dir}
    {addJsDef img_prod_dir=$img_prod_dir}
    {addJsDef id_product=$product->id|intval}
    {addJsDef jqZoomEnabled=$jqZoomEnabled|boolval}
    {addJsDef maxQuantityToAllowDisplayOfLastQuantityMessage=$last_qties|intval}
    {addJsDef minimalQuantity=$product->minimal_quantity|intval}
    {addJsDef noTaxForThisProduct=$no_tax|boolval}
    {if isset($customer_group_without_tax)}
      {addJsDef customerGroupWithoutTax=$customer_group_without_tax|boolval}
    {else}
      {addJsDef customerGroupWithoutTax=false}
    {/if}
    {if isset($group_reduction)}
      {addJsDef groupReduction=$group_reduction|floatval}
    {else}
      {addJsDef groupReduction=false}
    {/if}
    {addJsDef oosHookJsCodeFunctions=Array()}
    {addJsDef productHasAttributes=isset($groups)|boolval}
    {addJsDef productPriceTaxExcluded=($product->getPriceWithoutReduct(true)|default:'null' - $product->ecotax)|floatval}
    {addJsDef productPriceTaxIncluded=($product->getPriceWithoutReduct(false)|default:'null' - $product->ecotax * (1 + $ecotaxTax_rate / 100))|floatval}
    {addJsDef productBasePriceTaxExcluded=($product->getPrice(false, null, 6, null, false, false) - $product->ecotax)|floatval}
    {addJsDef productBasePriceTaxExcl=($product->getPrice(false, null, 6, null, false, false)|floatval)}
    {addJsDef productBasePriceTaxIncl=($product->getPrice(true, null, 6, null, false, false)|floatval)}
    {addJsDef productReference=$product->reference|escape:'html':'UTF-8'}
    {addJsDef productAvailableForOrder=$product->available_for_order|boolval}
    {addJsDef productPriceWithoutReduction=$productPriceWithoutReduction|floatval}
    {addJsDef productPrice=$productPrice|floatval}
    {addJsDef productUnitPriceRatio=$product->unit_price_ratio|floatval}
    {addJsDef productShowPrice=(!$PS_CATALOG_MODE && $product->show_price)|boolval}
    {addJsDef PS_CATALOG_MODE=$PS_CATALOG_MODE}
    {if $product->specificPrice && $product->specificPrice|@count}
      {addJsDef product_specific_price=$product->specificPrice}
    {else}
      {addJsDef product_specific_price=array()}
    {/if}
    {if $display_qties == 1 && $product->quantity}
      {addJsDef quantityAvailable=$product->quantity}
    {else}
      {addJsDef quantityAvailable=0}
    {/if}
    {addJsDef quantitiesDisplayAllowed=$display_qties|boolval}
    {if $product->specificPrice && $product->specificPrice.reduction && $product->specificPrice.reduction_type == 'percentage'}
      {addJsDef reduction_percent=$product->specificPrice.reduction*100|floatval}
    {else}
      {addJsDef reduction_percent=0}
    {/if}
    {if $product->specificPrice && $product->specificPrice.reduction && $product->specificPrice.reduction_type == 'amount'}
      {addJsDef reduction_price=$product->specificPrice.reduction|floatval}
    {else}
      {addJsDef reduction_price=0}
    {/if}
    {if $product->specificPrice && $product->specificPrice.price}
      {addJsDef specific_price=$product->specificPrice.price|floatval}
    {else}
      {addJsDef specific_price=0}
    {/if}
    {addJsDef specific_currency=($product->specificPrice && $product->specificPrice.id_currency)|boolval} {* TODO: remove if always false *}
    {addJsDef stock_management=$PS_STOCK_MANAGEMENT|intval}
    {addJsDef taxRate=$tax_rate|floatval}
    {addJsDefL name=doesntExist}{l s='This combination does not exist for this product. Please select another combination.' js=1}{/addJsDefL}
    {addJsDefL name=doesntExistNoMore}{l s='This product is no longer in stock' js=1}{/addJsDefL}
    {addJsDefL name=doesntExistNoMoreBut}{l s='with those attributes but is available with others.' js=1}{/addJsDefL}
    {addJsDefL name=fieldRequired}{l s='Please fill in all the required fields before saving your customization.' js=1}{/addJsDefL}
    {addJsDefL name=uploading_in_progress}{l s='Uploading in progress, please be patient.' js=1}{/addJsDefL}
    {addJsDefL name='product_fileDefaultHtml'}{l s='No file selected' js=1}{/addJsDefL}
    {addJsDefL name='product_fileButtonHtml'}{l s='Choose File' js=1}{/addJsDefL}
  {/strip}
{/if}

