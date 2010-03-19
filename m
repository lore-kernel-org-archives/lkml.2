Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab0CSUTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:19:45 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:53417 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0CSUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U/gz9rXzSjZoLSsnxWjniQb4/ZEZtvdKAwCXCVbu/Ib8Fl4G1BiGAlA8xy447+HKFn
         j51fOlPbcH5Sg3/+3x6R86dSRJpvhaAUq5uuWoY+nDfrf6nJCK/7XPjj7o8u8W+a/gXd
         l5z+k0HZAZBnRaHN+D2zNqqJdv+Jx9EIXv5BY=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 7/7] Staging:rt2860: fix coding style issue in rt3070.c, rt3090.c, rt30xx.c
Date: Sat, 20 Mar 2010 01:18:51 +0500
Message-Id: <1269029931-29399-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the rt3070.c, rt3090.c, rt30xx.c files that fixes up
errors found by the checkpatch.pl tool

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/rt2860/chips/rt3070.c |    4 ++--
 drivers/staging/rt2860/chips/rt3090.c |    4 ++--
 drivers/staging/rt2860/chips/rt30xx.c |    9 +++------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rt2860/chips/rt3070.c b/drivers/staging/rt2860/chips/rt3070.c
index 627bad9..3a17fd1 100644
--- a/drivers/staging/rt2860/chips/rt3070.c
+++ b/drivers/staging/rt2860/chips/rt3070.c
@@ -56,7 +56,7 @@ void NICInitRT3070RFRegisters(struct rt_rtmp_adapter *pAd)
 		u32 RfReg = 0;
 		u32 data;
 
-		RT30xxReadRFRegister(pAd, RF_R30, (u8 *)& RfReg);
+		RT30xxReadRFRegister(pAd, RF_R30, (u8 *)&RfReg);
 		RfReg |= 0x80;
 		RT30xxWriteRFRegister(pAd, RF_R30, (u8)RfReg);
 		RTMPusecDelay(1000);
@@ -84,7 +84,7 @@ void NICInitRT3070RFRegisters(struct rt_rtmp_adapter *pAd)
 			}
 		} else if (IS_RT3071(pAd)) {
 			/* Driver should set RF R6 bit6 on before init RF registers */
-			RT30xxReadRFRegister(pAd, RF_R06, (u8 *)& RfReg);
+			RT30xxReadRFRegister(pAd, RF_R06, (u8 *)&RfReg);
 			RfReg |= 0x40;
 			RT30xxWriteRFRegister(pAd, RF_R06, (u8)RfReg);
 
diff --git a/drivers/staging/rt2860/chips/rt3090.c b/drivers/staging/rt2860/chips/rt3090.c
index 5927ba4..c2933c6 100644
--- a/drivers/staging/rt2860/chips/rt3090.c
+++ b/drivers/staging/rt2860/chips/rt3090.c
@@ -53,7 +53,7 @@ void NICInitRT3090RFRegisters(struct rt_rtmp_adapter *pAd)
 		/* Driver should toggle RF R30 bit7 before init RF registers */
 		u32 RfReg = 0, data;
 
-		RT30xxReadRFRegister(pAd, RF_R30, (u8 *)& RfReg);
+		RT30xxReadRFRegister(pAd, RF_R30, (u8 *)&RfReg);
 		RfReg |= 0x80;
 		RT30xxWriteRFRegister(pAd, RF_R30, (u8)RfReg);
 		RTMPusecDelay(1000);
@@ -90,7 +90,7 @@ void NICInitRT3090RFRegisters(struct rt_rtmp_adapter *pAd)
 		}
 
 		/* Driver should set RF R6 bit6 on before calibration */
-		RT30xxReadRFRegister(pAd, RF_R06, (u8 *)& RfReg);
+		RT30xxReadRFRegister(pAd, RF_R06, (u8 *)&RfReg);
 		RfReg |= 0x40;
 		RT30xxWriteRFRegister(pAd, RF_R06, (u8)RfReg);
 
diff --git a/drivers/staging/rt2860/chips/rt30xx.c b/drivers/staging/rt2860/chips/rt30xx.c
index 6e684a3..4367a19 100644
--- a/drivers/staging/rt2860/chips/rt30xx.c
+++ b/drivers/staging/rt2860/chips/rt30xx.c
@@ -170,8 +170,7 @@ void RTMPFilterCalibration(struct rt_rtmp_adapter *pAd)
 	pAd->Mlme.CaliBW40RfR24 = 0x2F;	/*Bit[5] must be 1 for BW 40 */
 
 	do {
-		if (loop == 1)	/*BandWidth = 40 MHz */
-		{
+		if (loop == 1) {	/*BandWidth = 40 MHz */
 			/* Write 0x27 to RF_R24 to program filter */
 			RF_R24_Value = 0x27;
 			RT30xxWriteRFRegister(pAd, RF_R24, RF_R24_Value);
@@ -190,8 +189,7 @@ void RTMPFilterCalibration(struct rt_rtmp_adapter *pAd)
 			RT30xxReadRFRegister(pAd, RF_R31, &value);
 			value |= 0x20;
 			RT30xxWriteRFRegister(pAd, RF_R31, value);
-		} else		/*BandWidth = 20 MHz */
-		{
+		} else {	/*BandWidth = 20 MHz */
 			/* Write 0x07 to RF_R24 to program filter */
 			RF_R24_Value = 0x07;
 			RT30xxWriteRFRegister(pAd, RF_R24, RF_R24_Value);
@@ -353,8 +351,7 @@ void RT30xxLoadRFNormalModeSetup(struct rt_rtmp_adapter *pAd)
 	RT30xxReadRFRegister(pAd, RF_R27, &RFValue);
 	/* TX to RX IQ glitch(RF_R27) has been fixed in RT3070(F). */
 	/* Raising RF voltage is no longer needed for RT3070(F) */
-	if (IS_RT3090(pAd))	/* RT309x and RT3071/72 */
-	{
+	if (IS_RT3090(pAd)) {	/* RT309x and RT3071/72 */
 		if ((pAd->MACVersion & 0xffff) < 0x0211)
 			RFValue = (RFValue & (~0x77)) | 0x3;
 		else
-- 
1.7.0.2

