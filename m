Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1CGVN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:13:59 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40077
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753215Ab1CGVN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:13:59 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 04/16] Staging: hv: Remove unnecessary function pointers in driver_context
Date: Mon,  7 Mar 2011 13:23:18 -0800
Message-Id: <1299532998-22581-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the unnecessary function pointers for probe(),
remove() and shutdown() from struct driver_context.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index 42f2adb..8bcfb40 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -33,14 +33,6 @@ struct driver_context {
 
 	struct device_driver driver;
 
-	/*
-	 * Use these methods instead of the struct device_driver so 2.6 kernel
-	 * stops complaining
-	 * TODO - fix this!
-	 */
-	int (*probe)(struct device *);
-	int (*remove)(struct device *);
-	void (*shutdown)(struct device *);
 };
 
 struct vm_device {
-- 
1.5.5.6

