﻿REM  *****  LibreOffice VBA  *****

Option VBASupport 1 'for Len, StrConv
Option Explicit

'
'REF : https://leesumin.tistory.com/78
'REF : 유니코드 범위에 대한 이해 : https://jinios.github.io/study/2018/06/23/unicode_background_korean/
'

'
' 한글 결합식
'
' (초성 인덱스 * 21 + 중성 인덱스) * 28 + 종성 인덱스 + 0xAC00( 44032 : 가 )
' > 21은 중성의 총 수
' > 28은 종성의 총 수
' 
' 즉 한글 결합식은 최소한의 숫자를 사용하면서 인덱스를 하나로 합치기 위해
' 먼저 계산식에 오른 Index에 다음 Index 의 총 수를 곱해서 수를 밀어 올리면서 연산을 반복해서 완성 하는 것이다.
' 
' 초성 배열 19개 : "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ" , "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
' 중성 배열 21개 : "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"
' 종성 배열 28개 : "", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
'

'
' REF : https://velog.io/@limdumb/%EC%9C%A0%EB%8B%88%EC%BD%94%EB%93%9C-%ED%95%9C%EA%B8%80-%EB%B2%94%EC%9C%84
' 유니코드 한글 범위 : AC00 ~ D7FF
'

Function research___multibyte___check_multibyte

	Dim s as String : s = "가a1ㄴ다ㅏ"
	Dim slen as Integer : slen = Len( s )
	
	Dim b() as Byte
	
	Dim result as String
	
	Dim i as Integer
	For i = 1 To slen
	
		b = Mid( s, i, 1 )
		
		result = result & b & " : " & IsMultiByte( b ) & Chr( 10 )
		
	Next i
	
	MsgBox( result )
	
End Function
Function IsMultiByte( b() as Byte )

	'
	' 유니코드 범위 체크 : English + Latin : https://en.wikipedia.org/wiki/List_of_Unicode_characters
	'
	IsMultiByte = ( b( 1 ) <> 0 )

End Function




Function research___multibyte___check_number

	Dim s as String : s = "0가a1ㄴ다7ㅏ9"
	Dim slen as Integer : slen = Len( s )
	
	Dim b() as Byte
	
	Dim result as String
	
	Dim i as Integer
	For i = 1 To slen
	
		b = Mid( s, i, 1 )
		
		result = result & b & Chr( 9 ) & Chr( 9 ) & IsNumber( b ) & Chr( 10 )
		
	Next i
	
	MsgBox( result )
	
End Function
Function IsNumber( b() as Byte )


	'
	' Multibyte Check
	'
	If b( 1 ) <> 0 Then
		IsNumber = False
	Else
		
		'
		' 유니코드 범위 체크 : 숫자 : 0030 ~ 0039
		'
		IsNumber = ( b( 0 ) >= &H30 And b( 0 ) <= &H39 )
		
	End If


End Function




Function research___multibyte___check_english

	Dim s as String : s = "0가a1zㄴb다7AㅏZ9"
	Dim slen as Integer : slen = Len( s )
	
	Dim b() as Byte
	
	Dim result as String
	
	Dim i as Integer
	For i = 1 To slen
	
		b = Mid( s, i, 1 )
		
		result = result & b & Chr( 9 ) & Chr( 9 ) & IsEnglish( b ) & Chr( 10 )
		
	Next i
	
	MsgBox( result )
	
End Function
Function IsEnglish( b() as Byte )


	'
	' Multibyte Check
	'
	If b( 1 ) <> 0 Then
		IsEnglish = False
	Else
		
		'
		' 유니코드 범위 체크
		' 대문자 : 0041 ~ 005A
		' 소문자 : 0061 ~ 007A
		'
		IsEnglish = ( b( 0 ) >= &H41 And b( 0 ) <= &H5A ) Or ( b( 0 ) >= &H61 And b( 0 ) <= &H7A )
		
	End If


End Function




Function research___multibyte___check_korean

	Dim s as String : s = "가a1ㄴ다ㅏ"
	Dim slen as Integer : slen = Len( s )
	
	Dim b() as Byte
	
	Dim result as String
	
	Dim i as Integer
	For i = 1 To slen
	
		b = Mid( s, i, 1 )
		
		result = result & b & " : " & IsKorean( b ) & Chr( 10 )
		
	Next i
	
	MsgBox( result )
	
End Function
Function IsKorean( b() as Byte )

	'
	' 유니코드 범위 체크 : 한글 : AC00 ~ D7FF
	'
	IsKorean = ( b( 1 ) >= &HAC And b( 1 ) < &HD8 )

End Function




Sub research___multibyte

	'
	' spread sheet 의 cell 을 하나 가져온다.
	'
	Dim document as Object
	document = ThisComponent
	
	Dim sheets as Object
	sheets = document.Sheets
	
	Dim sheet as Object
	sheet = sheets.getByName( "multibyte_check" )
	
	Dim cell_0_1 as Object
	cell_0_1 = sheet.getCellByPosition( 0, 1 )	
	
	'
	'
	'
	Dim s as String : s =  cell_0_1.String
	MsgBox( s )
	Dim slen as Integer : slen = Len( s )
	
	Dim b() as Byte
	
	Dim result as String
	
	Dim i as Integer
	For i = 1 To slen
	
		b = Mid( s, i, 1 )
		
		result = result & b & Chr( 9 ) & Chr( 9 ) & "MultiByte = " & IsMultiByte( b ) & Chr( 9 ) & Chr( 9 ) & "Korean = " & IsKorean( b ) & Chr( 10 )
		
	Next i
	
	MsgBox( result )

End Sub
