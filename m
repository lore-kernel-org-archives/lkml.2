Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2KCNkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 09:40:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54876 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab2KCNko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 09:40:44 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: fix the spaces issue around that '->' in drivers/gsc_hpdi.c
Date: Sat,  3 Nov 2012 22:40:39 +0900
Message-Id: <1351950039-16269-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: spaces prohibited around that '->' (ctx:VxW)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/gsc_hpdi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/gsc_hpdi.c b/drivers/staging/comedi/drivers/gsc_hpdi.c
index 4809295..3342a46 100644
--- a/drivers/staging/comedi/drivers/gsc_hpdi.c
+++ b/drivers/staging/comedi/drivers/gsc_hpdi.c
@@ -621,7 +621,7 @@ static void hpdi_detach(struct comedi_device *dev)
 				sizeof(struct plx_dma_desc) *
 				NUM_DMA_DESCRIPTORS,
 				devpriv->dma_desc,
-				devpriv-> dma_desc_phys_addr);
+				devpriv->dma_desc_phys_addr);
 		if (devpriv->hpdi_phys_iobase)
 			comedi_pci_disable(devpriv->hw_dev);
 		pci_dev_put(devpriv->hw_dev);
-- 
1.7.9.5

