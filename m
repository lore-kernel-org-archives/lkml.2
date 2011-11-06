Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1KFOrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 09:47:07 -0500
Received: from apfelkorn.psychaos.be ([195.144.77.38]:42100 "EHLO
	apfelkorn.psychaos.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1KFOrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 09:47:05 -0500
From: Peter De Schrijver <p2@psychaos.be>
To: p2@psychaos.be
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Verheyen <jeff.verheyen@ampersant.be>
Subject: [PATCH] bt8xx: add support for PCI device ID 0x36c
Date: Sun,  6 Nov 2011 16:47:58 +0200
Message-Id: <1320590878-9612-1-git-send-email-p2@psychaos.be>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add support for conexant PCI device 0x36c. Seems to be fully compatible with
the currently supported chips, yet the chip has different PCI ID.

Signed-off-by: Peter De Schrijver <p2@psychaos.be>
---
 drivers/media/video/bt8xx/bt848.h       |    5 ++++-
 drivers/media/video/bt8xx/bttv-driver.c |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/bt8xx/bt848.h b/drivers/media/video/bt8xx/bt848.h
index 0bcd953..c37e6ac 100644
--- a/drivers/media/video/bt8xx/bt848.h
+++ b/drivers/media/video/bt8xx/bt848.h
@@ -30,6 +30,10 @@
 #ifndef PCI_DEVICE_ID_BT849
 #define PCI_DEVICE_ID_BT849     0x351
 #endif
+#ifndef PCI_DEVICE_ID_FUSION879
+#define PCI_DEVICE_ID_FUSION879	0x36c
+#endif
+
 #ifndef PCI_DEVICE_ID_BT878
 #define PCI_DEVICE_ID_BT878     0x36e
 #endif
@@ -37,7 +41,6 @@
 #define PCI_DEVICE_ID_BT879     0x36f
 #endif
 
-
 /* Brooktree 848 registers */
 
 #define BT848_DSTATUS          0x000
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 3dd0660..76c301f 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4572,6 +4572,7 @@ static struct pci_device_id bttv_pci_tbl[] = {
 	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT849), 0},
 	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT878), 0},
 	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_BT879), 0},
+	{PCI_VDEVICE(BROOKTREE, PCI_DEVICE_ID_FUSION879), 0},
 	{0,}
 };
 
-- 
1.7.4.1

