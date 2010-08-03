Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0HCRpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:45:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0HCRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:45:08 -0400
From: Stefan Weil <weil@mail.berlios.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: Stefan Weil <weil@mail.berlios.de>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling contorller -> controller in comments
Date: Tue,  3 Aug 2010 19:44:52 +0200
Message-Id: <1280857492-4398-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:pU8bAgWYyjQ0i650hhUS9vXQ46OQUtyWeiMIsnjTiDX
 B8elIdkLaOxVe/aGdBoVvdm2/MN361MKP57WT7qN4633coj1ZD
 qewuEdBA+A9YeyTVYOcxQxh7/SrDmyCwG8Ag41rG48RTyNuhMx
 LQy7+DAEtvdpDKeRnqvBWHfK1q1Rdj/US5QZR49dWtqjOJXHzS
 vDF5vHKy0dops94s9sGONURtU/O2Ta8/EGT9ns7IQkU3ScoVqa
 gtqa/dBFpRHmm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/dma/fsldma.c |    2 +-
 drivers/net/sh_eth.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8088b14..f0fd6db 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -10,7 +10,7 @@
  * Description:
  *   DMA engine driver for Freescale MPC8540 DMA controller, which is
  *   also fit for MPC8560, MPC8555, MPC8548, MPC8641, and etc.
- *   The support for MPC8349 DMA contorller is also added.
+ *   The support for MPC8349 DMA controller is also added.
  *
  * This driver instructs the DMA controller to issue the PCI Read Multiple
  * command for PCI read operations, instead of using the default PCI Read Line
diff --git a/drivers/net/sh_eth.c b/drivers/net/sh_eth.c
index 501a55f..70a9bc5 100644
--- a/drivers/net/sh_eth.c
+++ b/drivers/net/sh_eth.c
@@ -1325,7 +1325,7 @@ static int sh_mdio_init(struct net_device *ndev, int id)
 	bitbang->mdc_msk = 0x01;
 	bitbang->ctrl.ops = &bb_ops;
 
-	/* MII contorller setting */
+	/* MII controller setting */
 	mdp->mii_bus = alloc_mdio_bitbang(&bitbang->ctrl);
 	if (!mdp->mii_bus) {
 		ret = -ENOMEM;
-- 
1.5.6.5

