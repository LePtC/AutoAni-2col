import flash.display.*;

var firstvalue: Number;
var diffvalue: int;

var cn: String;
var up: String;
var dn: String;

var format1: TextFormat;

function initialize(firstvaluei: Number, pofix: String, upi: String, dni: String): void {

	firstvalue = firstvaluei;
  cn = pofix;
  up=upi;
  dn=dni;
	this.alpha = 0;

  format1 = new TextFormat();
  format1.color = 0xFFFFFF;
	te.setTextFormat(format1);
}



function update(po: Number): void {

	diffvalue = int(po-firstvalue);

	if(diffvalue==0 && this.alpha>0) {
		this.alpha -= 0.1;
	}

  if(diffvalue!=0 ) {
    if(this.alpha<1){
    this.alpha += 0.1;
  }
    te.text=Math.abs(diffvalue).toString()+cn;
    if(diffvalue>0){
      te.text=up+te.text;
      format1.color = 0xFFAA99;
      te.setTextFormat(format1);
    }else{
      te.text=dn+te.text;
      format1.color = 0x781c86;
      te.setTextFormat(format1);
    }
  }
}

