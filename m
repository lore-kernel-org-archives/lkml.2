Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1EIWJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:09:39 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54113
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752928Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 030/206] Staging: hv: Get rid of/change some dated comments
Date: Mon,  9 May 2011 14:55:12 -0700
Message-Id: <1304978288-22999-30-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 234ce8b..5d5aec3 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -17,8 +17,8 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *   K. Y. Srinivasan <kys@microsoft.com>
  *
- * 4/3/2011: K. Y. Srinivasan - Significant restructuring and cleanup.
  */
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -442,10 +442,6 @@ static int storvsc_connect_to_vsp(struct hv_device *device)
 	return ret;
 }
 
-/*
- * stor_vsc_on_device_add - Callback when the device belonging to this driver
- * is added
- */
 int storvsc_dev_add(struct hv_device *device,
 					void *additional_info)
 {
@@ -484,9 +480,6 @@ cleanup:
 	return ret;
 }
 
-/*
- * stor_vsc_on_device_remove - Callback when the our device is being removed
- */
 int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
@@ -518,9 +511,6 @@ int storvsc_dev_remove(struct hv_device *device)
 	return 0;
 }
 
-/*
- * stor_vsc_on_io_request - Callback to initiate an I/O request
- */
 int storvsc_do_io(struct hv_device *device,
 			      struct hv_storvsc_request *request)
 {
-- 
1.7.4.1

