document.addEventListener('turbolinks:load', function () {
  if (!$('#card_form')[0]) return false; //カード登録ページではないなら以降実行しない。
  console.log("hoge");
  Payjp.setPublicKey("pk_test_ad6d32b343d4d6231e804bcf"); //公開鍵を読み込む。
  const regist_button = $("#regist_card"); //カード入力フォームの登録ボタン。

  regist_button.on("click", function (e) { //登録ボタンを押したとき（ここはsubmitではなくclickにしておく）。
    e.preventDefault();
    console.log(this);    
    const card = {
      number: $("#card_number_form").val(),
      cvc: $("#cvc_form").val(),
      exp_month: $("#exp_month_form").val(),
      exp_year: Number($("#exp_year_form").val()) + 2000
      
    };
　　console.log(card); 

  Payjp.createToken(card, (status, response) => { //cardをpayjpに送信して登録する。
      
  if (status === 200) { //成功した場合
    alert("カードを登録しました");
    console.log(response.id);
     // ↓hidden_fieldにcardのtokenを入れることでtokenがparamsに送られる。
     $("#card_token").append(
      `<input type="hidden" name="payjp_token" value=${response.id}>
      <input type="hidden" name="card_token" value=${response.card.id}>`
    );
    $("#card_number_form").removeAttr("name");
    $("#cvc_form").removeAttr("name");
    $("#exp_month_form").removeAttr("name");
    $("#exp_year_form").removeAttr("name");
    // ↓formのsubmitボタンを強制起動する（ページが遷移してコントローラが起動する）。
    $('#card_form')[0].submit();
  } else { //失敗した場合
    alert("カード情報が正しくありません。");
    console.log(response.error.message);
    regist_button.prop('disabled', false);
  }

});
  }); //登録ボタンを押したときここまで。
  
});