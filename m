Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1EIVqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:46:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54392
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755092Ab1EIVoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 124/206] Staging: hv: Get rid of unnecessary code/comments
Date: Mon,  9 May 2011 14:56:46 -0700
Message-Id: <1304978288-22999-124-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unnecessary code/comments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 8ff9a58..77b081c 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -174,24 +174,9 @@ static int blk_vsc_initialize(struct hv_driver *driver)
 
 	stor_driver = hvdr_to_stordr(driver);
 
-	/* Make sure we are at least 2 pages since 1 page is used for control */
-
 	driver->name = drv_name;
 	memcpy(&driver->dev_type, &dev_type, sizeof(struct hv_guid));
 
-
-	/*
-	 * Divide the ring buffer data size (which is 1 page less than the ring
-	 * buffer size since that page is reserved for the ring buffer indices)
-	 * by the max request size (which is
-	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
-	 */
-	stor_driver->max_outstanding_req_per_channel =
-		((stor_driver->ring_buffer_size - PAGE_SIZE) /
-		  ALIGN(MAX_MULTIPAGE_BUFFER_PACKET +
-			   sizeof(struct vstor_packet) + sizeof(u64),
-			   sizeof(u64)));
-
 	return ret;
 }
 
-- 
1.7.4.1

