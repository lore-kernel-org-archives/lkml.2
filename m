Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0LaFvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:51:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0LaFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:48:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kI9a9Kvp3cBj8IqrlpjOBf/ekx7eZdv/tDUVn71964uhiPO8bQBBI20b3ygiI6nBpq
         mVv7lurRWkfVUQz0/V75R6yuxAXBGF+hSK9m1NIFlF4erFR8jFn/lGqVhAqXSRslIq6s
         2FWAjxwJIflZncHvUo2YPcIgBZF+uYoeYAq8c=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/15]drivers:staging:rtl8187se:r8180_hw.h Fix some comments.
Date: Thu, 30 Dec 2010 21:48:41 -0800
Message-Id: <1293774531-5294-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-3-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-4-git-send-email-justinmattock@gmail.com>
 <1293774531-5294-5-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_hw.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_hw.h b/drivers/staging/rtl8187se/r8180_hw.h
index 3fca144..34aa664 100644
--- a/drivers/staging/rtl8187se/r8180_hw.h
+++ b/drivers/staging/rtl8187se/r8180_hw.h
@@ -10,7 +10,7 @@
 	Parts of this driver are based on the Intel Pro Wireless
 	2100 GPL driver.
 
-	We want to tanks the Authors of those projects
+	We want to thanks the Authors of those projects
 	and the Ndiswrapper project Authors.
 */
 
@@ -181,7 +181,7 @@
 #define RF_SW_CFG_SI		BIT1
 #define EIFS			0x2D			/* Extended InterFrame Space Timer, in unit of 4 us.	*/
 
-#define BRSR			0x34			/* Basic rate set										*/
+#define BRSR			0x34			/* Basic rate set */
 
 #define IMR 0x006C
 #define ISR 0x003C
@@ -286,7 +286,7 @@
 #define CR_MulRW    ((1 << 0))
 
 #define IMR_Dot11hInt	((1 << 25))			/*802.11h Measurement Interrupt					*/
-#define IMR_BcnDmaInt	((1 << 24))			/*Beacon DMA Interrupt */ /*What differenct between BcnDmaInt and BcnInt???	*/
+#define IMR_BcnDmaInt	((1 << 24))			/*Beacon DMA Interrupt */ /*What difference between BcnDmaInt and BcnInt???	*/
 #define IMR_WakeInt		((1 << 23))			/*Wake Up Interrupt								*/
 #define IMR_TXFOVW		((1 << 22))			/*Tx FIFO Overflow Interrupt					*/
 #define IMR_TimeOut1	((1 << 21))			/*Time Out Interrupt 1							*/
@@ -313,7 +313,7 @@
 #define IMR_TimeOut3	((1 << 0))			/*Time Out Interrupt 3							*/
 #define IMR_TMGDOK      ((1 << 30))
 #define ISR_Dot11hInt	((1 << 25))			/*802.11h Measurement Interrupt					*/
-#define ISR_BcnDmaInt	((1 << 24))			/*Beacon DMA Interrupt	*/ /*What differenct between BcnDmaInt and BcnInt???	*/
+#define ISR_BcnDmaInt	((1 << 24))			/*Beacon DMA Interrupt	*/ /*What difference between BcnDmaInt and BcnInt???	*/
 #define ISR_WakeInt		((1 << 23))			/*Wake Up Interrupt								*/
 #define ISR_TXFOVW		((1 << 22))			/*Tx FIFO Overflow Interrupt					*/
 #define ISR_TimeOut1	((1 << 21))			/*Time Out Interrupt 1							*/
-- 
1.6.5.2.180.gc5b3e

