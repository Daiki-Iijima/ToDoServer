function reqListener () {
  const jsonObj = JSON.parse(this.responseText);

  console.log(jsonObj);

  const responseDiv = document.getElementById("respnse");

  //  子ノードをすべて消去
  for(let i=responseDiv.childNodes.length-1; i>=0;i--){
    responseDiv.removeChild(responseDiv.childNodes[i]);
  }

  //  取得した情報を表示
  for(var i = 0;i<jsonObj.length; i++){
    const str =  "("+jsonObj[i]["id"]+")"+jsonObj[i]["title"] + ":" + jsonObj[i]["is_complete"];
    const isComplete = jsonObj[i]["is_complete"];
    const title = jsonObj[i]["title"];

    //  タイトル表示要素生成
    let element = document.createElement("p");
    let content = document.createTextNode(str);
    const id = jsonObj[i]["id"];

    //  チェックボックス生成
    let checkElement = document.createElement("input");
    checkElement.setAttribute("type","checkbox");
    checkElement.setAttribute("id","checkbox"+id);

    //  すでに完了していればチェックをつける
    if(isComplete === "true"){
      checkElement.setAttribute("checked","checked");
    }

    checkElement.addEventListener('change',function(){
      const isCheck = document.getElementById("checkbox"+id).checked;

      let data;

      if(isCheck){
        data = {"title":title,"is_complete":"true","_method":"PUT"};
      }else{
        data = {"title":title,"is_complete":"false","_method":"PUT"};
      }

      const json = JSON.stringify(data);
      console.log(json);

      var oReq = new XMLHttpRequest();
      oReq.addEventListener("load", updateView);
      oReq.open("POST", "http://127.0.0.1:8001/api/todo/"+id);
      oReq.setRequestHeader("Content-Type","application/json");
      oReq.send(json);
    });

    //  消去ボタン生成
    let btnContent = document.createElement("button");
    btnContent.setAttribute("type","button");
    let btnText = document.createTextNode("消去");

    //  消去イベント
    btnContent.addEventListener('click',function(){
      var oReq = new XMLHttpRequest();
      oReq.addEventListener("load", updateView);
      oReq.open("DELETE", "http://127.0.0.1:8001/api/todo/"+id);
      oReq.send();
    });

    element.appendChild(content);
    element.appendChild(checkElement);

    btnContent.appendChild(btnText);
    element.appendChild(btnContent);

    responseDiv.insertBefore(element,null);
  }
}

//  最新の情報を取得
function updateView(){
  //  全取得して表示を更新
  var oReq = new XMLHttpRequest();
  oReq.addEventListener("load", reqListener);
  oReq.open("GET", "http://127.0.0.1:8001/api/todo/");
  oReq.send();
}

//  コンテンツ本体(HTML)がロードされたところで実行される
document.addEventListener('DOMContentLoaded',function(){

  //  ページ表示時に最新情報を取得する
  updateView();

  //  イベントの紐付け
  //  最新情報取得
  document.getElementById('allget').addEventListener('click',function(){
    updateView();
  });

  //  データ登録
  document.getElementById('recognite').addEventListener('click',function(){
    //  送信データの生成
    const titleInput = document.getElementById('title');
    const titleStr = titleInput.value;

    let data = {"title":titleStr,is_complete:"false"};

    const json = JSON.stringify(data);
    console.log(json);

    var oReq = new XMLHttpRequest();
    oReq.addEventListener("load", updateView);
    oReq.open("POST", "http://127.0.0.1:8001/api/todo/");
    oReq.setRequestHeader("Content-Type","application/json");
    oReq.send(json);
  });
});

