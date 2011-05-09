Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1EJJyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:54:10 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46518
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752777Ab1EJJyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:54:07 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 141/206] Staging: hv: Now get rid of an empty function
Date: Mon,  9 May 2011 14:57:03 -0700
Message-Id: <1304978288-22999-141-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3be4f1a..de6984f 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -74,18 +74,6 @@ struct storvsc_cmd_request {
 };
 
 
-/*
- * storvsc_initialize - Main entry point
- */
-static int storvsc_initialize(struct hv_driver *driver)
-{
-	struct storvsc_driver *stor_driver;
-
-	stor_driver = hvdr_to_stordr(driver);
-
-	return 0;
-}
-
 static int storvsc_device_alloc(struct scsi_device *sdevice)
 {
 	/*
@@ -775,7 +763,6 @@ static struct storvsc_driver storvsc_drv = {
 static int storvsc_drv_init(void)
 {
 	int ret;
-	struct storvsc_driver *storvsc_drv_obj = &storvsc_drv;
 	struct hv_driver *drv = &storvsc_drv.base;
 	u32 max_outstanding_req_per_channel;
 
@@ -792,9 +779,6 @@ static int storvsc_drv_init(void)
 	sizeof(struct vstor_packet) + sizeof(u64),
 	sizeof(u64)));
 
-	/* Callback to client driver to complete the initialization */
-	storvsc_initialize(&storvsc_drv_obj->base);
-
 	memcpy(&drv->dev_type, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
-- 
1.7.4.1

