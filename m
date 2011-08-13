Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1HMA1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:27:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45030 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab1HMA1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:46 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/10]drivers:staging Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:11 -0700
Message-Id: <1313195235-4522-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/vt6655/wpactl.c |    2 +-
 drivers/staging/vt6656/rf.c     |    6 +++---
 drivers/staging/vt6656/wpactl.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index a0f994e..472f0bc 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -627,7 +627,7 @@ static int wpa_get_scan(PSDevice pDevice,
 
     if (ptempBSS == NULL) {
 
-       printk("bubble sort kmalloc memory fail@@@\n");
+       printk("bubble sort kmalloc memory fail\n");
 
         ret = -ENOMEM;
 
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3fd0478..c327f45 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -899,16 +899,16 @@ BOOL        bResult = TRUE;
                 bResult &= IFRFbWriteEmbeded(pDevice, 0x03C6A200+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
                 if (pDevice->sMgmtObj.eScanState != WMAC_NO_SCANNING) {
                     // scanning, the channel number is pDevice->uScanChannel
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uScanChannel);
+                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uScanChannel);
                     bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uScanChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
                 } else {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uCurrChannel);
+                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RFbRawSetPower> 11B mode uCurrChannel[%d]\n", pDevice->sMgmtObj.uCurrChannel);
                     bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226D0LoCurrentTable[pDevice->sMgmtObj.uCurrChannel-1]); //RobertYu:20060420, sometimes didn't change channel just set power with different rate
                 }
 
                 bResult &= IFRFbWriteEmbeded(pDevice, 0x015C0800+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060420, ok now, new switching power (mini-pci can have bigger power consumption)
             } else {
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"@@@@ RFbRawSetPower> 11G mode\n");
+                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RFbRawSetPower> 11G mode\n");
                 dwVT3226Pwr = ((0x3F-pDevice->byCurPwr) << 20 ) | ( 0x7 << 8 ) /* Reg7 */ |   //RobertYu:20060420, TWIF 1.10
                                (BY_VT3226_REG_LEN << 3 )  | IFREGCTL_REGW;
                 bResult &= IFRFbWriteEmbeded(pDevice, dwVT3226Pwr);
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 9216df0..e796c82 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -634,7 +634,7 @@ static int wpa_get_scan(PSDevice pDevice,
 
     if (ptempBSS == NULL) {
 
-       printk("bubble sort kmalloc memory fail@@@\n");
+       printk("bubble sort kmalloc memory fail\n");
 
         ret = -ENOMEM;
 
-- 
1.7.6

