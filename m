Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0L3XIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 18:08:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58873 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0L3XIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tgiQVtHYxlRXUK+n5knwvfmcH0oQGs647iwCZR5oBRFU2v81Z6213EGnGrlXyVgkqn
         WovHrmVOCjCWfvwsoGRa1NpUdcjslE4vbjaJ/Vl2lJesjtpp4wikTSZt2QlyZyKveGE6
         x5/4i88/MBTITeKN7ulH5Gg00GRPM1J62rcqM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 08/15]drivers:scsi:lpfc:lpfc_init.c Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:57 -0800
Message-Id: <1293750484-1161-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b306579..a921f16 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7661,7 +7661,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	 * the HBA.
 	 */
 
-	/* HBA interrupt will be diabled after this call */
+	/* HBA interrupt will be disabled after this call */
 	lpfc_sli_hba_down(phba);
 	/* Stop kthread signal shall trigger work_done one more time */
 	kthread_stop(phba->worker_thread);
-- 
1.6.5.2.180.gc5b3e

