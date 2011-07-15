Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1GORx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:53:26 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37137
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753857Ab1GOR35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:57 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 005/117] Staging: hv: vmbus: Introduce vmbus ID space in struct hv_driver
Date: Fri, 15 Jul 2011 10:45:53 -0700
Message-Id: <1310752065-27895-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for supporting auto-loading Hyper-V drivers
using vmbus specific aliases, introduce vmbus ID space in struct hv_driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 399d9fe..b8199f4 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -32,6 +32,7 @@
 #include <linux/workqueue.h>
 #include <linux/completion.h>
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 
 
 #include <asm/hyperv.h>
@@ -805,6 +806,7 @@ struct hv_driver {
 
 	/* the device type supported by this driver */
 	uuid_le dev_type;
+	const struct hv_vmbus_device_id *id_table;
 
 	struct device_driver driver;
 
-- 
1.7.4.1

