Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1EIVov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:44:51 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48537
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751477Ab1EIVom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:42 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 005/206] Staging: hv: Rename the device type variable
Date: Mon,  9 May 2011 14:54:47 -0700
Message-Id: <1304978288-22999-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the variable g_blk_device_type.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index b54130b..51d1265 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -115,7 +115,7 @@ struct block_device_context {
 static const char *drv_name = "blkvsc";
 
 /* {32412632-86cb-44a2-9b5c-50d1417354f5} */
-static const struct hv_guid g_blk_device_type = {
+static const struct hv_guid dev_type = {
 	.data = {
 		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
 		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
@@ -178,7 +178,7 @@ static int blk_vsc_initialize(struct hv_driver *driver)
 	/* Make sure we are at least 2 pages since 1 page is used for control */
 
 	driver->name = drv_name;
-	memcpy(&driver->dev_type, &g_blk_device_type, sizeof(struct hv_guid));
+	memcpy(&driver->dev_type, &dev_type, sizeof(struct hv_guid));
 
 
 	/*
-- 
1.7.4.1

