Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab1IUU4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:56:00 -0400
Received: from jcz.nl ([213.196.18.5]:52183 "EHLO jcz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1IUUz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:55:59 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 16:55:59 EDT
From: Jaap Crezee <jaap@jcz.nl>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jaap Crezee <jaap@jcz.nl>
Subject: [PATCH] Staging: intel_sst: instel_sst: fixed some coding style issues.
Date: Wed, 21 Sep 2011 22:48:44 +0200
Message-Id: <1316638124-6226-1-git-send-email-jaap@jcz.nl>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Jaap Crezee <jaap@jcz.nl>
---
 drivers/staging/intel_sst/intel_sst.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst.c b/drivers/staging/intel_sst/intel_sst.c
index d892861..c303d85 100644
--- a/drivers/staging/intel_sst/intel_sst.c
+++ b/drivers/staging/intel_sst/intel_sst.c
@@ -321,7 +321,7 @@ static int __devinit intel_sst_probe(struct pci_dev *pci,
 		if (ret) {
 			pr_err("couldn't register LPE device\n");
 			goto do_free_misc;
- 		}
+		}
 	} else if (sst_drv_ctx->pci_id == SST_MFLD_PCI_ID) {
 		u32 csr;
 
@@ -524,9 +524,11 @@ int intel_sst_resume(struct pci_dev *pci)
 	return 0;
 }
 
-/* The runtime_suspend/resume is pretty much similar to the legacy suspend/resume with the noted exception below:
- * The PCI core takes care of taking the system through D3hot and restoring it back to D0 and so there is
- * no need to duplicate that here.
+/* The runtime_suspend/resume is pretty much similar to the legacy
+ * suspend/resume with the noted exception below:
+ * The PCI core takes care of taking the system through D3hot and
+ * restoring it back to D0 and so there is no need to duplicate
+ * that here.
  */
 static int intel_sst_runtime_suspend(struct device *dev)
 {
-- 
1.7.6.3

