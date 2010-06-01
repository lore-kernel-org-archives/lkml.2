Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0FAD0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:26:01 -0400
Received: from mail.perches.com ([173.55.12.10]:2482 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab0FADXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:30 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/21] drivers/net/vxge/vxge-main.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:14 -0700
Message-Id: <3b77109efe35cf983a884c793b7d47e446ea8988.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/vxge/vxge-main.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
index b504bd5..3c43430 100644
--- a/drivers/net/vxge/vxge-main.c
+++ b/drivers/net/vxge/vxge-main.c
@@ -4350,9 +4350,7 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 
 	/* Copy the station mac address to the list */
 	for (i = 0; i < vdev->no_of_vpath; i++) {
-		entry =	(struct vxge_mac_addrs *)
-				kzalloc(sizeof(struct vxge_mac_addrs),
-					GFP_KERNEL);
+		entry =	kzalloc(sizeof(struct vxge_mac_addrs), GFP_KERNEL);
 		if (NULL == entry) {
 			vxge_debug_init(VXGE_ERR,
 				"%s: mac_addr_list : memory allocation failed",
-- 
1.7.0.3.311.g6a6955

