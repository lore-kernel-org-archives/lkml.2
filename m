Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0L0Pv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:51:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:51463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab0L0PvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:51:25 -0500
From: David Sterba <dsterba@suse.cz>
To: trivial@kernel.org
Cc: mchehab@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH] [TRIVIAL] i7core_edac: fix typos in comments
Date: Mon, 27 Dec 2010 16:51:15 +0100
Message-Id: <1293465075-26572-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.3.4.626.g73e7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/edac/i7core_edac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index f41a34e..340efb0 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1,6 +1,6 @@
 /* Intel i7 core/Nehalem Memory Controller kernel module
  *
- * This driver supports yhe memory controllers found on the Intel
+ * This driver supports the memory controllers found on the Intel
  * processor families i7core, i7core 7xx/8xx, i5core, Xeon 35xx,
  * Xeon 55xx and Xeon 56xx also known as Nehalem, Nehalem-EP, Lynnfield
  * and Westmere-EP.
@@ -1271,7 +1271,7 @@ static void __init i7core_xeon_pci_fixup(const struct pci_id_table *table)
 	int i;
 
 	/*
-	 * On Xeon 55xx, the Intel Quckpath Arch Generic Non-core pci buses
+	 * On Xeon 55xx, the Intel Quick Path Arch Generic Non-core pci buses
 	 * aren't announced by acpi. So, we need to use a legacy scan probing
 	 * to detect them
 	 */
@@ -1864,7 +1864,7 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 	if (mce->mcgstatus & 1)
 		i7core_check_error(mci);
 
-	/* Advice mcelog that the error were handled */
+	/* Advise mcelog that the errors were handled */
 	return 1;
 }
 
-- 
1.7.3.4.626.g73e7b

