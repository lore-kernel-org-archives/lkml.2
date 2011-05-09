Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1EIVox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:44:53 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47288
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751502Ab1EIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 007/206] Staging: hv: Change the name of blkvsc driver variable
Date: Mon,  9 May 2011 14:54:49 -0700
Message-Id: <1304978288-22999-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the variable g_blkvsc_drv.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index a80e7c1..a0e08de 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -852,7 +852,7 @@ static void blkvsc_request(struct request_queue *queue)
 
 
 /* The one and only one */
-static  struct storvsc_driver g_blkvsc_drv;
+static  struct storvsc_driver blkvsc_drv;
 
 static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
@@ -867,8 +867,8 @@ static const struct block_device_operations block_ops = {
  */
 static int blkvsc_drv_init(void)
 {
-	struct storvsc_driver *storvsc_drv_obj = &g_blkvsc_drv;
-	struct hv_driver *drv = &g_blkvsc_drv.base;
+	struct storvsc_driver *storvsc_drv_obj = &blkvsc_drv;
+	struct hv_driver *drv = &blkvsc_drv.base;
 	int ret;
 
 	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
@@ -897,8 +897,8 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void blkvsc_drv_exit(void)
 {
-	struct storvsc_driver *storvsc_drv_obj = &g_blkvsc_drv;
-	struct hv_driver *drv = &g_blkvsc_drv.base;
+	struct storvsc_driver *storvsc_drv_obj = &blkvsc_drv;
+	struct hv_driver *drv = &blkvsc_drv.base;
 	struct device *current_dev;
 	int ret;
 
-- 
1.7.4.1

