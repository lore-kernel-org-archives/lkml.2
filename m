Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869Ab2ILRH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:07:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62613 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760603Ab2ILRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:36 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/15] arch/sparc/kernel/pci_sun4v.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:11 +0200
Message-Id: <1347469402-27557-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 arch/sparc/kernel/pci_sun4v.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 7661e84..051b69c 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -594,7 +594,7 @@ static int __devinit pci_sun4v_iommu_init(struct pci_pbm_info *pbm)
 		printk(KERN_ERR PFX "Strange virtual-dma[%08x:%08x].\n",
 		       vdma[0], vdma[1]);
 		return -EINVAL;
-	};
+	}
 
 	dma_mask = (roundup_pow_of_two(vdma[1]) - 1UL);
 	num_tsb_entries = vdma[1] / IO_PAGE_SIZE;

