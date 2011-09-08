Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab1IHOW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:22:59 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50555
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750746Ab1IHOW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:22:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 25/25] Staging: hv: netvsc: Rename deviceInfo as device_info
Date: Thu,  8 Sep 2011 07:24:36 -0700
Message-Id: <1315491876-9554-25-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename deviceInfo as device_info.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index cb9d4f6..732dfe7 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -696,7 +696,7 @@ int rndis_filter_device_add(struct hv_device *dev,
 	int ret;
 	struct netvsc_device *net_device;
 	struct rndis_device *rndis_device;
-	struct netvsc_device_info *deviceInfo = additional_info;
+	struct netvsc_device_info *device_info = additional_info;
 
 	rndis_device = get_rndis_device();
 	if (!rndis_device)
@@ -737,15 +737,15 @@ int rndis_filter_device_add(struct hv_device *dev,
 		 */
 	}
 
-	memcpy(deviceInfo->mac_adr, rndis_device->hw_mac_adr, ETH_ALEN);
+	memcpy(device_info->mac_adr, rndis_device->hw_mac_adr, ETH_ALEN);
 
 	rndis_filter_query_device_link_status(rndis_device);
 
-	deviceInfo->link_state = rndis_device->link_stat;
+	device_info->link_state = rndis_device->link_stat;
 
 	dev_info(&dev->device, "Device MAC %pM link state %s",
 		 rndis_device->hw_mac_adr,
-		 ((deviceInfo->link_state) ? ("down\n") : ("up\n")));
+		 ((device_info->link_state) ? ("down\n") : ("up\n")));
 
 	return ret;
 }
-- 
1.7.4.1

