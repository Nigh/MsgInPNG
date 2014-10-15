#Include gdip.ahk

class BinInPNG
{
	static _init:=0

	init()
	{
		if(this._init)
			Return 1
		If !this.pToken := Gdip_Startup()
		{
			MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
			Return -1
		}
		this._init:=1
		Return 0
	}

	selectPic(sFile)
	{
		if(!this._init)
			Return -1
		this.pBitmap:=Gdip_CreateBitmapFromFile(sFile)
		this.Width:=Gdip_GetImageWidth(this.pBitmap)
		this.Height:=Gdip_GetImageHeight(this.pBitmap)
		this.volume:=((this.Width*this.Height*3)//8)
		if(this.volume<=37)
			Return -2
		Return this.volume
	}

	getMsg()
	{

	}

	putMsg()
	{

	}

	getChar(char_Index)
	{
		if(!this.pBitmap)
			Return -1
		pixel_Index:=Ceil((char_Index*8-7)/3)
		y:=pixel_Index//this.Width
		x:=Mod(pixel_Index, this.Width)
		rgb_Index:=Mod(char_Index*8-7, 3)
		if(rgb_Index=0)
			loopCount:=4
		Else
			loopCount:=3
		Loop, % loopCount
		{
			Gdip_FromARGB(Gdip_GetPixel(this.pBitmap, x, y), A, R, G, B)
			array:={}
			array.Insert(R&0x1)
			array.Insert(G&0x1)
			array.Insert(B&0x1)
			x:=x=this.Width?1:x+1
			y:=x=1?y+1:y
		}
		if(rgb_Index=0)
			startCount:=3
		Else
			startCount:=rgb_Index
		output:=0
		Loop, 8
		{
			output+=array[A_Index+startCount-1]
			output<<=1
		}
		Return, output
	}

	putChar(char_Index)
	{
		
	}

	savePng(sOutput)
	{
		Gdip_SaveBitmapToFile(this.pBitmap, sOutput ".png")
	}

	version()
	{
		Return, "alpha 0"
	}
}

/*

alpha 0:
字节1为版本号A1
字节2从原图中读取，为全局偏移量
字节3为添加偏移量的版本号
字节4,5,6为长度，最大16Mb
字节7-16保留
字节17-value(0xff)为文件名
之后为内容

字节为MSB顺序

*/


class binMsg
{
	static version:=0xA1

	__New(sFile)
	{
		IfNotExist, % sFile
			Return -1
		FileGetSize, size, % sFile, B
		if(size>10000000)
			Return -2
		oFile:=FileOpen(sFile, "r")
		this.content:=Object()
		while(!oFile.AtEOF){
			this.content.Insert(oFile.ReadUChar())
		}
		oFile.Close()
		Return this
	}

	addOffset(offset)
	{
		if(offset>=0)
		{
			offset&=0xff
		}
		Else
		{
			offset:=-offset
			offset&=0xff
			offset:=-offset
		}
		Loop, % this.content.maxIndex()
		{
			if(offset<0)
				this.content[A_Index]+=0x100
			this.content[A_Index]+=offset
			this.content[A_Index]&=0xff
		}
	}

	__Get(key)
	{
		if(key="length")
			Return, this.content.Maxindex()
		Else
			Msgbox,4096,, No key named %key%
	}

	free()
	{
		this.content:=""
	}
}
