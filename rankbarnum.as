import flash.display.*;

var n: int; // 序号
var starn: int; // 显示为星号

function initialize(ni: int, cfgi: Array): void {

  if(isNaN(cfgi[1][5])){
    starn = 225;
  }else{
    starn = Number(cfgi[1][5]);
  }

	rank1.x = cfgi[22][0];
	n = ni;
	rank1.text = ni.toString();
  if(n%10!=0 && n<= starn){this.alpha=0.25}
  if(n>starn){rank1.text="*"}
}
