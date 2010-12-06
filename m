Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0LFUb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:31:28 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40421
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753448Ab0LFU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:57 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 7/8] staging: hv: Convert camel case function names in blkvsc.c to lowercase
Date: Mon,  6 Dec 2010 12:26:50 -0800
Message-Id: <1291667211-1865-7-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1291667211-1865-6-git-send-email-hjanssen@microsoft.com>
References: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-3-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-4-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-5-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-6-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Convert camel case function names in blkvsc.c to lowercase
 
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 208492c..4f4a65c 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -35,7 +35,7 @@ static const struct hv_guid gBlkVscDeviceType = {
 	}
 };
 
-static int BlkVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
+static int blk_vsc_on_device_add(struct hv_device *Device, void *AdditionalInfo)
 {
 	struct storvsc_device_info *deviceInfo;
 	int ret = 0;
@@ -93,7 +93,7 @@ int blk_vsc_initialize(struct hv_driver *Driver)
 		    storDriver->max_outstanding_req_per_channel);
 
 	/* Setup the dispatch table */
-	storDriver->base.OnDeviceAdd = BlkVscOnDeviceAdd;
+	storDriver->base.OnDeviceAdd = blk_vsc_on_device_add;
 	storDriver->base.OnDeviceRemove = stor_vsc_on_device_remove;
 	storDriver->base.OnCleanup = stor_vsc_on_cleanup;
 	storDriver->on_io_request = stor_vsc_on_io_request;
-- 
1.6.0.2

