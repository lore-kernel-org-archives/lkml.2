Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab0L3XL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:11:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58873 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0L3XIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NiH45ak8ZpORkjwVgW/zAnojNw/fn9Q1poal5RIXdhqgFlMFuA6vcZpcBoijvHGgaB
         63kepF5M55eRphfFqtYG/txc4CkTyc1wqLhYh/En2LWQ/c+OEclxr+b+46JAAtgqZ2Vx
         1WPvWUVyvJgNdzfr/urdRvCdXBSj+y8BSwqRE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/15]drivers:usb:host Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:58 -0800
Message-Id: <1293750484-1161-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293750484-1161-8-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-8-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo "diable" to "disable" and also fixes another typo in a comment. 
Please let me know if this is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/usb/host/fhci-hcd.c |    4 ++--
 drivers/usb/host/fhci-tds.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 20092a2..12fd184 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -98,13 +98,13 @@ void fhci_usb_enable_interrupt(struct fhci_usb *usb)
 	usb->intr_nesting_cnt--;
 }
 
-/* diable the usb interrupt */
+/* disable the usb interrupt */
 void fhci_usb_disable_interrupt(struct fhci_usb *usb)
 {
 	struct fhci_hcd *fhci = usb->fhci;
 
 	if (usb->intr_nesting_cnt == 0) {
-		/* diable the timer interrupt */
+		/* disable the timer interrupt */
 		disable_irq_nosync(fhci->timer->irq);
 
 		/* disable the usb interrupt */
diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index 7be548c..38fe058 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -271,8 +271,8 @@ void fhci_init_ep_registers(struct fhci_usb *usb, struct endpoint *ep,
 
 /*
  * Collect the submitted frames and inform the application about them
- * It is also prepearing the TDs for new frames. If the Tx interrupts
- * are diabled, the application should call that routine to get
+ * It is also preparing the TDs for new frames. If the Tx interrupts
+ * are disabled, the application should call that routine to get
  * confirmation about the submitted frames. Otherwise, the routine is
  * called frome the interrupt service routine during the Tx interrupt.
  * In that case the application is informed by calling the application
-- 
1.6.5.2.180.gc5b3e

