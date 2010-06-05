Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab0FEXeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:34:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48449 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933801Ab0FEXd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tuaaYzzwm1EZGMTM5nvxUluDKmbTveAwoEQTuixVPDQBi95KEDbraxL39bZgyX+AFI
         q/QqTKsqsI9ZiZ7zzpp/7zo4TpWdiivIKlx99pc/XuXZpsHukj6hiFrUeGUfyI8U0CYt
         PGHBq+CfbQ6uQMwvD42PXkm69WkOCKH08Nzrw=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 3/6] Kill empty function NewDelaySeconds().
Date: Sun,  6 Jun 2010 01:33:13 +0200
Message-Id: <1275780796-17751-4-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/vb_util.c |   20 --------------------
 drivers/staging/xgifb/vb_util.h |    1 -
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/xgifb/vb_util.c b/drivers/staging/xgifb/vb_util.c
index 39e55c9..3419341 100644
--- a/drivers/staging/xgifb/vb_util.c
+++ b/drivers/staging/xgifb/vb_util.c
@@ -170,23 +170,6 @@ void XGINew_SetRegOR( ULONG Port , USHORT Index , USHORT DataOR )
 
 
 /* --------------------------------------------------------------------- */
-/* Function : NewDelaySecond */
-/* Input : */
-/* Output : */
-/* Description : */
-/* --------------------------------------------------------------------- */
-void NewDelaySeconds( int seconds )
-{
-    int i ;
-
-
-    for( i = 0 ; i < seconds ; i++ )
-    {
-    }
-}
-
-
-/* --------------------------------------------------------------------- */
 /* Function : Newdebugcode */
 /* Input : */
 /* Output : */
@@ -196,8 +179,5 @@ void Newdebugcode( UCHAR code )
 {
 //    outb ( (u8)code , 0x80 ) ;
     /* outb ( (u8)code , 0x300 ) ; */
-    /* NewDelaySeconds( 0x3 ) ; */
 }
 
-
-
diff --git a/drivers/staging/xgifb/vb_util.h b/drivers/staging/xgifb/vb_util.h
index 91779d8..4abe3a9 100644
--- a/drivers/staging/xgifb/vb_util.h
+++ b/drivers/staging/xgifb/vb_util.h
@@ -1,6 +1,5 @@
 #ifndef _VBUTIL_
 #define _VBUTIL_
-extern   void     NewDelaySeconds( int );
 extern   void     Newdebugcode( UCHAR );
 extern   void     XGINew_SetReg1(ULONG, USHORT, USHORT);
 extern   void     XGINew_SetReg3(ULONG, USHORT);
-- 
1.7.1

