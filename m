Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1FXGXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:23:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37053 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1FXGWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o04EYw1XXe6szmXANEVudFAQ43X24to7cYI6pnmAzB6f+QL8Bsh7nB7tX2IZv12ijO
         uMSrGo1qrn9V2uFwh7XThv1dS1KG7xaWrym59QvrRk4C866776c9pdo5qUKdzU5eZuW+
         jv56mOAYj2HS6bHr1DKvfFsobf6MgwI9zpzK0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/3]Remove one to many nnn's in some comments.
Date: Thu, 23 Jun 2011 23:22:28 -0700
Message-Id: <1308896549-4560-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308896549-4560-1-git-send-email-justinmattock@gmail.com>
References: <1308896549-4560-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes some comments that seem to be typos. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h |    2 +-
 drivers/usb/otg/fsl_otg.c                         |    2 +-
 net/mac80211/work.c                               |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index 3ef42b3..83755ab 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -76,7 +76,7 @@ extern void sdioh_sdmmc_osfree(sdioh_info_t *sd);
 
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
-	bool client_intr_enabled;	/* interrupt connnected flag */
+	bool client_intr_enabled;	/* interrupt connected flag */
 	bool intr_handler_valid;	/* client driver interrupt handler valid */
 	sdioh_cb_fn_t intr_handler;	/* registered interrupt handler */
 	void *intr_handler_arg;	/* argument to call interrupt handler */
diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
index 0f420b2..2d9cc44 100644
--- a/drivers/usb/otg/fsl_otg.c
+++ b/drivers/usb/otg/fsl_otg.c
@@ -639,7 +639,7 @@ static int fsl_otg_set_power(struct otg_transceiver *otg_p, unsigned mA)
  * Delayed pin detect interrupt processing.
  *
  * When the Mini-A cable is disconnected from the board,
- * the pin-detect interrupt happens before the disconnnect
+ * the pin-detect interrupt happens before the disconnect
  * interrupts for the connected device(s).  In order to
  * process the disconnect interrupt(s) prior to switching
  * roles, the pin-detect interrupts are delayed, and handled
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index d2e7f0e..a4fb304 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1071,7 +1071,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		local->tmp_channel = NULL;
 		/* If tmp_channel wasn't operating channel, then
 		 * we need to go back on-channel.
-		 * NOTE:  If we can ever be here while scannning,
+		 * NOTE:  If we can ever be here while scanning,
 		 * or if the hw_config() channel config logic changes,
 		 * then we may need to do a more thorough check to see if
 		 * we still need to do a hardware config.  Currently,
-- 
1.7.5.4

