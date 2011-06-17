Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1FQPFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:05:01 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33878
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932075Ab1FQPE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:04:59 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 1/5] staging: hv: fix some white spaces in netvsc driver
Date: Fri, 17 Jun 2011 07:58:04 -0700
Message-Id: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c     |    8 ++++----
 drivers/staging/hv/netvsc_drv.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 0ae35e7..b6e1fb9 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -525,10 +525,10 @@ int netvsc_send(struct hv_device *device,
 						  (unsigned long)packet);
 	} else {
 		ret = vmbus_sendpacket(device->channel, &sendMessage,
-				       sizeof(struct nvsp_message),
-				       (unsigned long)packet,
-				       VM_PKT_DATA_INBAND,
-				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+				sizeof(struct nvsp_message),
+				(unsigned long)packet,
+				VM_PKT_DATA_INBAND,
+				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
 	}
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index b339acc..8380fe9 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -122,7 +122,7 @@ static void netvsc_xmit_completion(void *context)
 		atomic_add(num_pages, &net_device_ctx->avail);
 		if (atomic_read(&net_device_ctx->avail) >=
 				PACKET_PAGES_HIWATER)
- 			netif_wake_queue(net);
+			netif_wake_queue(net);
 	}
 }
 
-- 
1.6.3.2

