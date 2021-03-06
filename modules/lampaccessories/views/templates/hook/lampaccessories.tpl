<!-- Block {if isset($my_module_name) && $my_module_name}
        {$my_module_name}
      {else}
       lampaccessories {$my_module_link}
      {/if} -->
{if !empty($lampaccessories)}
<div class="lampaccessories-tabs-container">
  <ul class="nav nav-tabs la-nav-tabs">
    {assign var="bActive" value="0"}
    {foreach $lampaccessories as $lampaccessoryCategory}
      <li {if $bActive==0}class="active"{/if}><a href="#lamp_category{$lampaccessoryCategory[0]['id_category_default']}" data-toggle="tab"
             id="lamp_category{$lampaccessoryCategory[0]['id_category_default']}_link">
          {$lampaccessoryCategory[0]['category']}</a>
      </li>
      {assign var="bActive" value="1"}

    {/foreach}
  </ul>
  <div class="tab-content la-tab-content">
    {assign var="bActive" value="0"}
    {foreach $lampaccessories as $lampaccessoryCategory}
    <section class="page-product-box tab-pane fade in {if $bActive==0}active{/if}"
             id="lamp_category{$lampaccessoryCategory[0]['id_category_default']}">
      {assign var="bActive" value="1"}
      {foreach $lampaccessoryCategory as $lampaccessory}
      <div class="lampaccessories_pr_line">
        <div class="lampaccessories_pr_img" style="background-image: url('{$lampaccessory['image_link']}');">
          <a href="{$lampaccessory['url']}" >&nbsp;</a>
        </div>
      <div class="lampaccessories_pr_text">
        <div class="lampaccessories_pr_name">
          <a href="{$lampaccessory['url']}">{$lampaccessory['name']}</a>
        </div>
        <div class="lampaccessories_pr_desc">
          {$lampaccessory['description_short']}
          <span class="lampaccessories_pr_price">{if !empty($lampaccessory['price']) && floatval($lampaccessory['price']) != 0}(+{convertPrice price=$lampaccessory['price']}){/if}</span>
        </div>
        <div class="lampaccessories_pr_controls">
          <form>
            <input type="hidden" name="controller" value="cart">
            <input type="hidden" name="add" value="1">
            <input type="hidden" name="ajax" value="true">
            <input type="hidden" name="id_product" value="{$lampaccessory['id_product']}">
            <input type="hidden" name="token" value="{$static_token}" />
            <a class="lampaccessories_pr_decr">-</a>
          <input class="lampaccessories_pr_count" readonly="readonly" name="qty" value="1">
            <a class="lampaccessories_pr_incr">+</a>

            <a class="lampaccessories_pr_buy">Купить</a>
            <span class="lampaccessories_error"></span>
            <span class="lampaccessories_success"></span>
          </form>
        </div>
      </div>

  </div>
  {/foreach}
  </section>
  {/foreach}
</div>
</div>

<div style="clear: both;"></div>
<script type="text/javascript" >
  {literal}
  $('.lampaccessories_pr_incr').click(function (e) {
    e.preventDefault();
    var $input = $(this).siblings('.lampaccessories_pr_count');
    var old = parseInt($input.val());
    $input.val(old + 1);
  });
  $('.lampaccessories_pr_decr').click(function (e) {
    e.preventDefault();
    $input = $(this).siblings('.lampaccessories_pr_count');
    var old = parseInt($input.val());
    old--;
    if (old < 1)
      old = 1;
    $input.val(old);
  });
  $('.lampaccessories-tabs-container .nav-tabs a').click(function (e) {
    e.preventDefault();
    var $this = $(this);
    $('.la-tab-content section').removeClass('active');
    $($this.attr('href')).addClass('active');
//    console.dir($($this.attr('href')));
  });
  $('.lampaccessories_pr_buy').click(function (e) {
    e.preventDefault();
    var $form = $(this).parents('form');
    var $successSpan = $form.find('.lampaccessories_success');
    var $errorSpan = $form.find('.lampaccessories_error');
    $successSpan.html('');
    $errorSpan.html('');
    $.ajax({
      url: '/',
      data: $form.serialize()
    })
        .success(function (data) {
          var res;
          try {
            res = JSON.parse(data);
            if (res.hasError) {
              $.each(res.errors, function (ei, error) {
                var curError = $errorSpan.text();
                $errorSpan.html(curError + error + '<br/>');
                $errorSpan.show("slow");
              });
            } else {
              $successSpan.text('Товар успешно добавлен в корзину');
              $successSpan.show("slow");
              ajaxCart.refresh();
            }
          } catch (e) {
            $errorSpan.text('Товар не удалось добавить в корзину');
            $errorSpan.show("slow");
          }
        })
        .error(function (data, data2) {
//          console.dir(data);
          $errorSpan.text('Серверу не удалось обработать запрос');
          $errorSpan.show("slow");
        })
        .complete(function () {
          setTimeout(function(){
            if($errorSpan.is(':visible')) {
              $errorSpan.hide("slow");
            }
            if($successSpan.is(':visible')) {
              $successSpan.hide("slow");
            }
          }, 5000);
        });
  });
  {/literal}
</script>
{/if}
<!-- /Block {if isset($my_module_name) && $my_module_name}
        {$my_module_name}
      {else}
       lampaccessories
      {/if} -->