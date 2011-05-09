Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1EIWDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:03:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54164
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754864Ab1EIVoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:46 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 050/206] Staging: hv: Rename stor_vsc_initialize()
Date: Mon,  9 May 2011 14:55:32 -0700
Message-Id: <1304978288-22999-50-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index d8ce28e..28b8569 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -71,9 +71,9 @@ struct storvsc_cmd_request {
 
 
 /*
- * stor_vsc_initialize - Main entry point
+ * storvsc_initialize - Main entry point
  */
-static int stor_vsc_initialize(struct hv_driver *driver)
+static int storvsc_initialize(struct hv_driver *driver)
 {
 	struct storvsc_driver *stor_driver;
 
@@ -514,7 +514,7 @@ static int storvsc_drv_init(void)
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
-	stor_vsc_initialize(&storvsc_drv_obj->base);
+	storvsc_initialize(&storvsc_drv_obj->base);
 
 	DPRINT_INFO(STORVSC_DRV,
 		    "max outstanding reqs %u",
-- 
1.7.4.1

