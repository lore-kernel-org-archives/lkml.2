Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1JVFrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:47:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42321 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1JVFrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:47:16 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Youquan Song <youquan.song@intel.com>,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/36] Staging: cx25821: cx25821-core.c: Fix indent
Date: Sat, 22 Oct 2011 13:43:32 +0800
Message-Id: <1319262236-6498-13-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
References: <1319262236-6498-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent of statements that indented with spaces to indent with
tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 5346746..f8ead2a 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -869,7 +869,7 @@ static int cx25821_get_resources(struct cx25821_dev *dev)
 		return 0;
 
 	pr_err("%s: can't get MMIO memory @ 0x%llx\n",
-	       dev->name, (unsigned long long)pci_resource_start(dev->pci, 0));
+		dev->name, (unsigned long long)pci_resource_start(dev->pci, 0));
 
 	return -EBUSY;
 }
@@ -994,7 +994,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
  *  cx25821_i2c_register(&dev->i2c_bus[2]); */
 
 	CX25821_INFO("i2c register! bus->i2c_rc = %d\n",
-		     dev->i2c_bus[0].i2c_rc);
+			dev->i2c_bus[0].i2c_rc);
 
 	cx25821_card_setup(dev);
 
@@ -1224,7 +1224,7 @@ static __le32 *cx25821_risc_field_audio(__le32 * rp, struct scatterlist *sglist,
 			/* scanline needs to be split */
 			todo = bpl;
 			*(rp++) = cpu_to_le32(RISC_WRITE | sol |
-					      (sg_dma_len(sg) - offset));
+					(sg_dma_len(sg) - offset));
 			*(rp++) = cpu_to_le32(sg_dma_address(sg) + offset);
 			*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 			todo -= (sg_dma_len(sg) - offset);
@@ -1232,7 +1232,7 @@ static __le32 *cx25821_risc_field_audio(__le32 * rp, struct scatterlist *sglist,
 			sg++;
 			while (todo > sg_dma_len(sg)) {
 				*(rp++) = cpu_to_le32(RISC_WRITE |
-						      sg_dma_len(sg));
+						sg_dma_len(sg));
 				*(rp++) = cpu_to_le32(sg_dma_address(sg));
 				*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 				todo -= sg_dma_len(sg);
-- 
1.7.0.4

