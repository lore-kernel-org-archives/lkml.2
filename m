Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1EIWLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:11:46 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54093
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751835Ab1EIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 020/206] Staging: hv: Rename the function stor_vsc_get_major_info()
Date: Mon,  9 May 2011 14:55:02 -0700
Message-Id: <1304978288-22999-20-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    2 +-
 drivers/staging/hv/storvsc_api.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 2e69af0..457d0bb 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -958,7 +958,7 @@ static int blkvsc_probe(struct hv_device *dev)
 
 	dev_set_drvdata(&dev->device, blkdev);
 
-	ret = stor_vsc_get_major_info(&device_info, &major_info);
+	ret = storvsc_get_major_info(&device_info, &major_info);
 
 	if (ret)
 		goto cleanup;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 7074520..8ee1ad0 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -615,7 +615,7 @@ int storvsc_do_io(struct hv_device *device,
  *
  */
 
-int stor_vsc_get_major_info(struct storvsc_device_info *device_info,
+int storvsc_get_major_info(struct storvsc_device_info *device_info,
 			    struct storvsc_major_info *major_info)
 {
 	static bool ide0_registered;
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 84ee5a9..32228c0 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -170,7 +170,7 @@ int storvsc_dev_remove(struct hv_device *device);
 int storvsc_do_io(struct hv_device *device,
 				struct hv_storvsc_request *request);
 
-int stor_vsc_get_major_info(struct storvsc_device_info *device_info,
+int storvsc_get_major_info(struct storvsc_device_info *device_info,
 				struct storvsc_major_info *major_info);
 
 #endif /* _STORVSC_API_H_ */
-- 
1.7.4.1

