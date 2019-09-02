﻿import flash.display.*;

var colbar: Array;
var cfg: Array;


var n: int; // 序号
var id: String; // mid
var cn: String; // 中文名
//var po: Number;
var rt: Number;
var col: Number;

var H: Number;

var Icon: Sprite; // 头像容器

var j:int;

var format1: TextFormat;

function initialize(ni: int, idi: String, cni: String, coli: Number, pofix: String, cfgi: Array): void {

	Icon = new Sprite();
	addChild(Icon);
	Icon.x = 0;
	Icon.y = -3;

	cfg = cfgi;

	rank1.x = cfg[22][0];
	rec.x = cfg[24][0];
	cname.x = cfg[25][0];
	H = cfg[26][0];
	rec.height = cfg[27][0];

	rt = cfg[28][0] / 2 + 4;

	format1 = new TextFormat();
	format1.color = 0xFFFFFF;
	format1.size = cfg[29][0];

	this.y = Number(cfg[30][0]);
	this.alpha = 0;

	n = ni;

	cn = cni;
	cname.text = cni;
	cname.setTextFormat(format1);


  id = clearDelimeters(idi);
	var icon: Loader = new Loader();
	icon.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoaded);
	icon.load(new URLRequest(id + pofix));


	col = coli;
	/*var newColorTransform: ColorTransform = rec.transform.colorTransform;
	newColorTransform.color = col;
	rec.transform.colorTransform = newColorTransform;*/

  include "colbar.as"; // 按增速变色

  firstcall=0;
  firstcally=0;
  atcol=0;
}

var firstcall:int;
var firstcally:int;

var atcol:int; // 分栏


function iconLoaded(e: Event): void {

	var image: Bitmap = new Bitmap(e.target.content.bitmapData);
	image.width = 2 * rt;
	image.height = 2 * rt;
	image.x = -rt;
	image.y = 0;
	Icon.addChildAt(image, 0);

	// Create the mask graphic
	var maskCircle: Sprite = new Sprite();
	maskCircle.graphics.beginFill(0x000000);
	maskCircle.graphics.drawEllipse(-rt, 0, 2 * rt, 2 * rt);
	maskCircle.graphics.endFill();
	maskCircle.visible = false;
	Icon.addChild(maskCircle);

	image.mask = maskCircle; // Applies the mask

}



var rank: int; // 要去往的排名
rank1.text = "";

var fan: Number = 0;
var fanlast: Number = 0;
var news: int = 60; // 最近有更新的话，给30帧高亮时间
var tarA: Number; // 最近有更新的目标alpha1，否则半透明



function update(po: Number, speed: Number): void {

  if(firstcall<2){
    jiafen.initialize(po/10000," 万","+","-");
    firstcall++;
  }else{
    jiafen.update(po/10000);
  }

	fan = po / cfg[36][0];

	if(fan - fanlast > Number(cfg[68][0])) {
		this.alpha = 1;
		news = cfg[69][0];
	} else if(news > Number(cfg[70][0])) {
		news--;
	}
	fanlast = fan;
	tarA = news / cfg[69][0];


	cvalue.text = cfg[38][0] + fan.toFixed(int(cfg[37][0])).toString() + cfg[39][0];
	cvalue.setTextFormat(format1);

	// rank1.text = (rank + 1).toString(); //+ "."
	//rank1.setTextFormat(format1);


	var newColorTransform: ColorTransform = rec.transform.colorTransform;
	newColorTransform.color = colbar[colfun(speed)];
	rec.transform.colorTransform = newColorTransform;
}


function colfun(speed: Number): int {
	if(speed <= 0) {
		return(0)
	}
	if(speed >= 50000) {
		return(100)
	}
	return(int(Math.pow(speed / 50000, 1 / 6) * 100))
}


function clearDelimeters(formattedString: String): String {
	return formattedString.replace(/[\u000d\u000a\u0008\u0020]+/g, "");
}

// 位置和柱长都采用“固定比例赶往目标值”算法
function updatey(i: int, scale: Number): void {

  if( i<int(cfg[1][1]) || i>(int(cfg[1][1])+int(cfg[1][2])*25) ){
    this.visible=false;
  }else{
    this.visible=true;
  }

  if(firstcally<2){
    jiamin.initialize(-i," 名","▲","▼");

    for(j = 0; j<(cfg[118]).length; j++){
      if(id==clearDelimeters(cfg[118][j])){
        jiamin.initialize(-int(cfg[119][j])," 名","▲","▼");
      }
    }

    firstcally++;
  }else{
    jiamin.update(-i);
  }

  if(i>225){
    jiamin.visible=false;
  }else{
    jiamin.visible=true;
  }

	if(cfg[53][0] == "1") { // 对数轴
		rec.width += (Math.log(1 + fan) * scale - rec.width) / Number(cfg[8][0]);
	} else {
		rec.width += (fan * scale - rec.width) / Number(cfg[8][0]);
	}
	cvalue.x = rec.width + Number(cfg[41][0]);
	if(cvalue.x < Number(cfg[40][0])) {
		cvalue.x = Number(cfg[40][0]);
	}
	if(cvalue.x > Number(cfg[40][1])) {
		cvalue.x = Number(cfg[40][1]);
	}
	Icon.x = rec.width;


  jiafen.x=cvalue.x+90;
  jiamin.x=cvalue.x+176;
if(fan>=100){
  jiafen.x+=20;
  jiamin.x+=20;
}

	cname.x = rec.width - (cname.textWidth + 10) - 27;


  // 分双栏
  if(i>=(int(cfg[1][1])+25)&&atcol==0){
    atcol=1;
    this.y-=1080;
  }
  if(i<(int(cfg[1][1])+25)&&atcol==1){
    atcol=0;
    this.y+=1080;
  }
  i-=25*atcol;
  this.x=1920/int(cfg[1][2])*atcol;


	if(fan >= Number(cfg[67][0])) {
		var dist = Math.abs(i * H - this.y);
		if(dist >= Number(cfg[10][0])) { // 变速
			this.y += (i * H - this.y) / Number(cfg[9][0]);
		} else if(dist >= Number(cfg[12][0])) { // 匀速
			if(this.y < i * H) {
				this.y += Number(cfg[11][0]);
			}
			if(this.y > i * H) {
				this.y -= Number(cfg[11][0]);
			}
		} else { // 直接抵达
			this.y = i * H;
		}

	} else {
		rank1.text = "";
		this.y += (Number(cfg[30][0]) - this.y) / Number(cfg[9][0]); // 往出生点消失
	}

	if(fan <= Number(cfg[67][0]) || (this.alpha > tarA + 0.05)) {
		this.alpha -= 0.05;
	} else if(this.alpha < tarA - 0.05) {
		this.alpha += 0.05;
	}



}




var pstart: int; // 拥有用户的层号起点
var pnum: int; // 拥有用户数量
