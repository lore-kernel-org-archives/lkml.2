Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab0IDGjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:39:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45230 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0IDGjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OuEqn8MrYlzfRx+w51EhtreeOg7c2zD/nOHkRUT3dLwzy4su+h6fG7nPeVrjGfrU3f
         DMSG+eizPhAN++szRd/XVVKbNISHlflowzsinJokgAV+CDoz/756A02BU0XQ0plgiC0b
         kOGeWlh0nYzyhcvs/ScEqUb3F2xhg+Qltb8ZQ=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, pshah.mumbai@gmail.com, apatard@mandriva.com,
        randy.dunlap@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: xgifb: fixed many style issues in vb_util.c
Date: Sat,  4 Sep 2010 12:09:32 +0530
Message-Id: <1283582372-5319-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the vb_util.c file that fixes many style
issues found by the checkpatch.pl tool.
- extra spaces
- invalid code indent
- extra braces
- invalid comment style

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/xgifb/vb_util.c |  185 ++++++++++++---------------------------
 1 files changed, 58 insertions(+), 127 deletions(-)

diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index ae27f0c..65b3954 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -6,21 +6,20 @@
 #include <asm/io.h>
 #include <linux/types.h>
 
-void XGINew_SetReg1(unsigned long,unsigned short,unsigned short);
-void XGINew_SetReg2(unsigned long,unsigned short,unsigned short);
-void XGINew_SetReg3(unsigned long,unsigned short);
-void XGINew_SetReg4(unsigned long,unsigned long);
+void XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
+void XGINew_SetReg2(unsigned long, unsigned short, unsigned short);
+void XGINew_SetReg3(unsigned long, unsigned short);
+void XGINew_SetReg4(unsigned long, unsigned long);
 unsigned char XGINew_GetReg1(unsigned long, unsigned short);
 unsigned char XGINew_GetReg2(unsigned long);
 unsigned long XGINew_GetReg3(unsigned long);
 void XGINew_ClearDAC(unsigned char *);
-void XGINew_SetRegANDOR(unsigned long Port,unsigned short Index,
-			unsigned short DataAND,unsigned short DataOR);
-void XGINew_SetRegOR(unsigned long Port,unsigned short Index,
-		     unsigned short DataOR);
-void XGINew_SetRegAND(unsigned long Port,unsigned short Index,
-		      unsigned short DataAND);
-
+void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
+		unsigned short DataAND, unsigned short DataOR);
+void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
+		unsigned short DataOR);
+void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
+		unsigned short DataAND);
 
 /* --------------------------------------------------------------------- */
 /* Function : XGINew_SetReg1 */
@@ -28,178 +27,110 @@ void XGINew_SetRegAND(unsigned long Port,unsigned short Index,
 /* Output : */
 /* Description : SR CRTC GR */
 /* --------------------------------------------------------------------- */
-void XGINew_SetReg1( unsigned long port , unsigned short index , unsigned short data )
+void XGINew_SetReg1(unsigned long port, unsigned short index,
+		unsigned short data)
 {
 	outb(index, port);
 	outb(data, port + 1);
 }
 
-
 /* --------------------------------------------------------------------- */
 /* Function : XGINew_SetReg2 */
 /* Input : */
 /* Output : */
 /* Description : AR( 3C0 ) */
 /* --------------------------------------------------------------------- */
-/*void XGINew_SetReg2( unsigned long port , unsigned short index , unsigned short data )
+/*
+void XGINew_SetReg2(unsigned long port, unsigned short index, unsigned short data)
 {
-    InPortByte((P unsigned char )port + 0x3da - 0x3c0) ;
-    OutPortByte( XGINew_P3c0 , index ) ;
-    OutPortByte( XGINew_P3c0 , data ) ;
-    OutPortByte( XGINew_P3c0 , 0x20 ) ;
-}*/
-
+	InPortByte((P unsigned char)port + 0x3da - 0x3c0) ;
+	OutPortByte(XGINew_P3c0, index);
+	OutPortByte(XGINew_P3c0, data);
+	OutPortByte(XGINew_P3c0, 0x20);
+}
+*/
 
-/* --------------------------------------------------------------------- */
-/* Function : */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void XGINew_SetReg3( unsigned long port , unsigned short data )
+void XGINew_SetReg3(unsigned long port, unsigned short data)
 {
 	outb(data, port);
 }
 
-
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_SetReg4 */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void XGINew_SetReg4( unsigned long port , unsigned long data )
+void XGINew_SetReg4(unsigned long port, unsigned long data)
 {
 	outl(data, port);
 }
 
-
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_GetReg1 */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
 unsigned char XGINew_GetReg1(unsigned long port, unsigned short index)
 {
-    unsigned char data ;
+	unsigned char data;
 
-    outb(index, port);
-    data = inb(port + 1) ;
-    return( data ) ;
+	outb(index, port);
+	data = inb(port + 1);
+	return data;
 }
 
-
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_GetReg2 */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
 unsigned char XGINew_GetReg2(unsigned long port)
 {
-    unsigned char data ;
+	unsigned char data;
 
-    data = inb(port) ;
+	data = inb(port);
 
-    return( data ) ;
+	return data;
 }
 
-
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_GetReg3 */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-unsigned long XGINew_GetReg3( unsigned long port )
+unsigned long XGINew_GetReg3(unsigned long port)
 {
-    unsigned long data ;
+	unsigned long data;
 
-    data = inl(port) ;
+	data = inl(port);
 
-    return( data ) ;
+	return data;
 }
 
-
-
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_SetRegANDOR */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void XGINew_SetRegANDOR( unsigned long Port , unsigned short Index , unsigned short DataAND , unsigned short DataOR )
+void XGINew_SetRegANDOR(unsigned long Port, unsigned short Index,
+		unsigned short DataAND, unsigned short DataOR)
 {
-    unsigned short temp ;
+	unsigned short temp;
 
-    temp = XGINew_GetReg1( Port , Index ) ;		/* XGINew_Part1Port index 02 */
-    temp = ( temp & ( DataAND ) ) | DataOR ;
-    XGINew_SetReg1( Port , Index , temp ) ;
+	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
+	temp = (temp & (DataAND)) | DataOR;
+	XGINew_SetReg1(Port, Index, temp);
 }
 
-
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_SetRegAND */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void XGINew_SetRegAND(unsigned long Port,unsigned short Index,unsigned short DataAND)
+void XGINew_SetRegAND(unsigned long Port, unsigned short Index,
+		unsigned short DataAND)
 {
-    unsigned short temp ;
+	unsigned short temp;
 
-    temp = XGINew_GetReg1( Port , Index ) ;	/* XGINew_Part1Port index 02 */
-    temp &= DataAND ;
-    XGINew_SetReg1( Port , Index , temp ) ;
+	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
+	temp &= DataAND;
+	XGINew_SetReg1(Port, Index, temp);
 }
 
-
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_SetRegOR */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void XGINew_SetRegOR( unsigned long Port , unsigned short Index , unsigned short DataOR )
+void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
+		unsigned short DataOR)
 {
-    unsigned short temp ;
+	unsigned short temp;
 
-    temp = XGINew_GetReg1( Port , Index ) ;	/* XGINew_Part1Port index 02 */
-    temp |= DataOR ;
-    XGINew_SetReg1( Port , Index , temp ) ;
+	temp = XGINew_GetReg1(Port, Index); /* XGINew_Part1Port index 02 */
+	temp |= DataOR;
+	XGINew_SetReg1(Port, Index, temp);
 }
 
 #if 0
-/* --------------------------------------------------------------------- */
-/* Function : NewDelaySecond */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void NewDelaySeconds( int seconds )
+void NewDelaySeconds(int seconds)
 {
-    int i ;
+	int i;
 
+	for (i = 0; i < seconds; i++) {
 
-    for( i = 0 ; i < seconds ; i++ )
-    {
-
-
-
-    }
+	}
 }
 
-/* --------------------------------------------------------------------- */
-/* Function : Newdebugcode */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
 void Newdebugcode(unsigned char code)
 {
-//    OutPortByte ( 0x80 , code ) ;
-    /* OutPortByte ( 0x300 , code ) ; */
-    /* NewDelaySeconds( 0x3 ) ; */
+	/* OutPortByte(0x80, code); */
+	/* OutPortByte(0x300, code); */
+	/* NewDelaySeconds(0x3); */
 }
 #endif
-- 
1.6.0.4

