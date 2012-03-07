Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2CGTz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:55:59 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54350
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932405Ab2CGTzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:55:55 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Cc: Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] net/hyperv: Use the built-in macro KBUILD_MODNAME for this driver
Date: Wed,  7 Mar 2012 12:02:00 -0800
Message-Id: <1331150520-7879-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Olaf Hering <olaf@aepfle.de>
---
 drivers/net/hyperv/netvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 0ae7a1a..217dfed 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -310,7 +310,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 static void netvsc_get_drvinfo(struct net_device *net,
 			       struct ethtool_drvinfo *info)
 {
-	strcpy(info->driver, "hv_netvsc");
+	strcpy(info->driver, KBUILD_MODNAME);
 	strcpy(info->version, HV_DRV_VERSION);
 	strcpy(info->fw_version, "N/A");
 }
@@ -482,7 +482,7 @@ MODULE_DEVICE_TABLE(vmbus, id_table);
 
 /* The one and only one */
 static struct  hv_driver netvsc_drv = {
-	.name = "netvsc",
+	.name = KBUILD_MODNAME,
 	.id_table = id_table,
 	.probe = netvsc_probe,
 	.remove = netvsc_remove,
-- 
1.7.4.1

