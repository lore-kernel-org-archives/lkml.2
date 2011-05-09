Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1EJJyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:54:15 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46519
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754120Ab1EJJyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:54:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 162/206] Staging: hv: Cleanup the newly created header file
Date: Mon,  9 May 2011 14:57:24 -0700
Message-Id: <1304978288-22999-162-git-send-email-kys@microsoft.com>
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
 include/linux/hyperv.h |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 2751b10..f91e3a4 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
+#include <linux/device.h>
 
 #define MAX_PAGE_BUFFER_COUNT				16
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
@@ -757,8 +758,6 @@ extern unsigned int vmbus_loglevel;
 #define HV_DRV_VERSION           "3.1"
 
 
-#include <linux/device.h>
-#include <linux/workqueue.h>
 
 
 struct hv_driver;
@@ -821,11 +820,6 @@ struct hv_device {
 	void *ext;
 };
 
-#include <linux/device.h>
-
-
-
-
 static inline struct hv_device *device_to_hv_device(struct device *d)
 {
 	return container_of(d, struct hv_device, device);
-- 
1.7.4.1

