import flash.display.*;

var n: int; // 序号

function initialize(ni: int, cfgi: Array): void {

	rank1.x = cfgi[22][0];
	n = ni;
	rank1.text = ni.toString();
  if(n%10!=0){this.alpha=0.25}

}
