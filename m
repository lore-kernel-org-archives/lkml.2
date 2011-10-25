Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab1JYNEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:04:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52855 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1JYND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:03:59 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH] lib: devres: add annotations for #endif
Date: Tue, 25 Oct 2011 15:03:42 +0200
Message-Id: <1319547822-23394-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on devres, I found those make navigating the code a tad
easier.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---

Ack from Grant given personally here in Prague.

 lib/devres.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/devres.c b/lib/devres.c
index 7c0e953..78777ae 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -348,5 +348,5 @@ void pcim_iounmap_regions(struct pci_dev *pdev, u16 mask)
 	}
 }
 EXPORT_SYMBOL(pcim_iounmap_regions);
-#endif
-#endif
+#endif /* CONFIG_PCI */
+#endif /* CONFIG_HAS_IOPORT */
-- 
1.7.6.3

