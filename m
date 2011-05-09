Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1EJIdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:33:09 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53154
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756109Ab1EJIax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 009/206] Staging: hv: Rename the function blk_vsc_on_device_add
Date: Mon,  9 May 2011 14:54:51 -0700
Message-Id: <1304978288-22999-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the function blk_vsc_on_device_add.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 391666e..0005e33 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -139,7 +139,7 @@ MODULE_PARM_DESC(ring_size, "Ring buffer size (in bytes)");
  */
 static int blkvsc_probe(struct hv_device *dev);
 
-static int blk_vsc_on_device_add(struct hv_device *device,
+static int blkvsc_device_add(struct hv_device *device,
 				void *additional_info)
 {
 	struct storvsc_device_info *device_info;
@@ -197,7 +197,7 @@ static int blk_vsc_initialize(struct hv_driver *driver)
 		    stor_driver->max_outstanding_req_per_channel);
 
 	/* Setup the dispatch table */
-	stor_driver->base.dev_add = blk_vsc_on_device_add;
+	stor_driver->base.dev_add = blkvsc_device_add;
 	stor_driver->base.dev_rm = stor_vsc_on_device_remove;
 	stor_driver->base.cleanup = stor_vsc_on_cleanup;
 	stor_driver->on_io_request = stor_vsc_on_io_request;
-- 
1.7.4.1

