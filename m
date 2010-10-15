Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0JORUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:20:36 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:49187
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756620Ab0JORUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:20:32 -0400
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org
Subject: [PATCH 3/5] staging: hv: Convert camel cased parameter in channel_interface.h to lower case
Date: Fri, 15 Oct 2010 10:14:05 -0700
Message-Id: <1287162847-27536-3-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1287162847-27536-2-git-send-email-haiyangz@linuxonhyperv.com>
References: <1287162847-27536-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1287162847-27536-2-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Convert camel cased parameter in channel_interface.h to lower case

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_interface.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/channel_interface.h b/drivers/staging/hv/channel_interface.h
index 1007612..82cff3d 100644
--- a/drivers/staging/hv/channel_interface.h
+++ b/drivers/staging/hv/channel_interface.h
@@ -27,7 +27,7 @@
 
 #include "vmbus_api.h"
 
-void get_channel_info(struct hv_device *Device,
-		    struct hv_device_info *DeviceInfo);
+void get_channel_info(struct hv_device *device,
+		    struct hv_device_info *info);
 
 #endif /* _CHANNEL_INTERFACE_H_ */
-- 
1.6.3.2

