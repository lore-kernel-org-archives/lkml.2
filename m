Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1EIWBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:01:31 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47492
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754920Ab1EIVor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:47 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 058/206] Staging: hv: Rename the driver variable
Date: Mon,  9 May 2011 14:55:40 -0700
Message-Id: <1304978288-22999-58-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 37bc4dd..d246678 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -768,7 +768,7 @@ static DEF_SCSI_QCMD(storvsc_queuecommand)
 
 
 /* The one and only one */
-static struct storvsc_driver g_storvsc_drv;
+static struct storvsc_driver storvsc_drv;
 
 /* Scsi driver */
 static struct scsi_host_template scsi_driver = {
@@ -879,8 +879,8 @@ static int storvsc_probe(struct hv_device *device)
 static int storvsc_drv_init(void)
 {
 	int ret;
-	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
-	struct hv_driver *drv = &g_storvsc_drv.base;
+	struct storvsc_driver *storvsc_drv_obj = &storvsc_drv;
+	struct hv_driver *drv = &storvsc_drv.base;
 
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
@@ -915,8 +915,8 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void storvsc_drv_exit(void)
 {
-	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
-	struct hv_driver *drv = &g_storvsc_drv.base;
+	struct storvsc_driver *storvsc_drv_obj = &storvsc_drv;
+	struct hv_driver *drv = &storvsc_drv.base;
 	struct device *current_dev = NULL;
 	int ret;
 
-- 
1.7.4.1

