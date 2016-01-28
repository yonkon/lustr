<!-- Block {if isset($my_module_name) && $my_module_name}
        {$my_module_name}
      {else}
       lampaccessories {$my_module_link}
      {/if} -->
<div class="lampaccessories-tabs-container">
  <ul class="nav nav-tabs la-nav-tabs">
    {foreach $lampaccessories as $lampaccessoryCategory}
      <li><a href="#lamp_category{$lampaccessoryCategory[0]['id_category_default']}" data-toggle="tab"
             id="lamp_category{$lampaccessoryCategory[0]['id_category_default']}_link">{$lampaccessoryCategory[0]['category']}</a>
      </li>
    {/foreach}
    {*
          <li><a href="#idTab311" data-toggle="tab" id="st_easy_tab_1">Доставка и оплата</a></li>
          <li><a href="#idTab313" data-toggle="tab" id="st_easy_tab_3">Система скидок</a></li>
          <li><a href="#idTab312" data-toggle="tab" id="st_easy_tab_2">Гарантия</a></li>
          *}
  </ul>
  <div class="tab-content la-tab-content">
    {foreach $lampaccessories as $lampaccessoryCategory}
    <section class="page-product-box tab-pane fade in active"
             id="#lamp_category{$lampaccessoryCategory[0]['id_category_default']}">
      {foreach $lampaccessoryCategory as $lampaccessory}
      <div class="lampaccessories_pr_line">
        <div class="lampaccessories_pr_img" style="background-image: url('{$lampaccessory['image_link']}');">
      </div>
      <div class="lampaccessories_pr_text">
        <div class="lampaccessories_pr_name">
          <a href="javascript:void();">Шаровидная лампа накаливания</a>
        </div>
        <div class="lampaccessories_pr_desc">
          Pila PL P45 40W 230V E14 CL1CT/10X10F
          <span class="lampaccessories_pr_price">(+11 грн.)</span>
        </div>
        <div class="lampaccessories_pr_controls">
          <form>
            <input type="hidden" name="controller" value="cart">
            <input type="hidden" name="add" value="1">
            <input type="hidden" name="ajax" value="true">
            <input type="hidden" name="id_product" value="{$lampaccessory['id_product']}">
            <input type="hidden" name="token" value="{$static_token}" />
            <a class="lampaccessories_pr_incr">+</a>
          <input class="lampaccessories_pr_count" disabled="disabled" name="qty" value="1">
          <a class="lampaccessories_pr_decr">-</a>
          <a class="lampaccessories_pr_buy">Купить</a>
          </form>
        </div>
      </div>

  </div>
  {/foreach}
  </section>
  {/foreach}
  <section class="page-product-box tab-pane fade" id="idTab311">
  </section>
</div>
</div>

<script type="text/javascript">
  {literal}
  $(document).ready(function(){
    $('.lampaccessories_pr_buy').click(function(e) {
      var $form = $(this).parents('form');
      $.ajax({
        url : '/',
        data : $form.serialize()
      })
          .success(function(data){})
          .error(function(data, data2){
            console.dir(data);
          })
    });
  });
  {/literal}
</script>

<!-- /Block {if isset($my_module_name) && $my_module_name}
        {$my_module_name}
      {else}
       lampaccessories
      {/if} -->