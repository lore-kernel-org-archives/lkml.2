Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab1CZBSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:18:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44969 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752372Ab1CZBSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:18:37 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/ZVUB4nL7ZbQJxy5rmeYy2d8oMZojXBN2gMusok+
	DLu03XeS2d+J5T
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 03/27] staging/brcm80211: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:17:52 +0100
Message-Id: <1301102296-15565-4-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <20110314224746.GA21100@kroah.com>
References: <20110314224746.GA21100@kroah.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/brcm80211.

WRONG -> RIGHT
accomodate  -> accommodate
occured     -> occurred
recieve     -> receive
unferflow	-> underflow
useable		-> usable

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c    |    2 +-
 drivers/staging/brcm80211/include/bcmsrom_fmt.h   |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 65313fa..71c3571 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -264,7 +264,7 @@ extern SDIOH_API_RC sdioh_disable_func_intr(void)
 }
 #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
 
-/* Configure callback to client when we recieve client interrupt */
+/* Configure callback to client when we receive client interrupt */
 extern SDIOH_API_RC
 sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index c6cdcd9..fc2f5f6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -406,7 +406,7 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 		/*
 		   compute a new dma xfer rate for max_mpdu @ max mcs.
 		   This is the minimum dma rate that
-		   can acheive no unferflow condition for the current mpdu size.
+		   can achieve no underflow condition for the current mpdu size.
 		 */
 		/* note : we divide/multiply by 100 to avoid integer overflows */
 		fifo->dmaxferrate =
diff --git a/drivers/staging/brcm80211/include/bcmsrom_fmt.h b/drivers/staging/brcm80211/include/bcmsrom_fmt.h
index ae2bff8..4666afd 100644
--- a/drivers/staging/brcm80211/include/bcmsrom_fmt.h
+++ b/drivers/staging/brcm80211/include/bcmsrom_fmt.h
@@ -103,9 +103,9 @@
 
 #define	SROM_CRCREV		63
 
-/* SROM Rev 4: Reallocate the software part of the srom to accomodate
+/* SROM Rev 4: Reallocate the software part of the srom to accommodate
  * MIMO features. It assumes up to two PCIE functions and 440 bytes
- * of useable srom i.e. the useable storage in chips with OTP that
+ * of usable srom i.e. the usable storage in chips with OTP that
  * implements hardware redundancy.
  */
 
-- 
1.7.3.4

