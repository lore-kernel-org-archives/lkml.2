Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1CMK1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:13 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39909 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1CMK0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:24 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 13/24] staging: xgifb: vb_util: delete commented-out code
Date: Sun, 13 Mar 2011 12:26:17 +0200
Message-Id: <1300011988-2109-14-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete commented-out code.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_util.c |   34 ----------------------------------
 drivers/staging/xgifb/vb_util.h |    2 --
 2 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index f542d66..465bcda 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -21,22 +21,6 @@ void XGINew_SetReg1(unsigned long port, unsigned short index,
 	outb(data, port + 1);
 }
 
-/* --------------------------------------------------------------------- */
-/* Function : XGINew_SetReg2 */
-/* Input : */
-/* Output : */
-/* Description : AR( 3C0 ) */
-/* --------------------------------------------------------------------- */
-/*
-void XGINew_SetReg2(unsigned long port, unsigned short index, unsigned short data)
-{
-	InPortByte((P unsigned char)port + 0x3da - 0x3c0) ;
-	OutPortByte(XGINew_P3c0, index);
-	OutPortByte(XGINew_P3c0, data);
-	OutPortByte(XGINew_P3c0, 0x20);
-}
-*/
-
 void XGINew_SetReg3(unsigned long port, unsigned short data)
 {
 	outb(data, port);
@@ -103,21 +87,3 @@ void XGINew_SetRegOR(unsigned long Port, unsigned short Index,
 	temp |= DataOR;
 	XGINew_SetReg1(Port, Index, temp);
 }
-
-#if 0
-void NewDelaySeconds(int seconds)
-{
-	int i;
-
-	for (i = 0; i < seconds; i++) {
-
-	}
-}
-
-void Newdebugcode(unsigned char code)
-{
-	/* OutPortByte(0x80, code); */
-	/* OutPortByte(0x300, code); */
-	/* NewDelaySeconds(0x3); */
-}
-#endif
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 156f644..bf52127 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -1,7 +1,5 @@
 #ifndef _VBUTIL_
 #define _VBUTIL_
-extern   void     NewDelaySeconds( int );
-extern   void     Newdebugcode(unsigned char);
 extern   void     XGINew_SetReg1(unsigned long, unsigned short, unsigned short);
 extern   void     XGINew_SetReg3(unsigned long, unsigned short);
 extern    unsigned char     XGINew_GetReg1(unsigned long, unsigned short);
-- 
1.5.6.5

