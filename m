Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1JXImy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:42:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57395 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1JXImT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:42:19 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, Tejun Heo <tj@kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [RFC 2/4] lib: devres: add annotations for #endif
Date: Mon, 24 Oct 2011 10:42:07 +0200
Message-Id: <1319445729-14841-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
References: <1319445729-14841-1-git-send-email-w.sang@pengutronix.de>
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
---
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

