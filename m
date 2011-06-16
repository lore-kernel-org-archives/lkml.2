Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab1FPUNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:13:31 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42446
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758704Ab1FPUB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 38/77] Staging: hv: vmbus: Get rid of the unused dev_type field in hv_device and hv_driver
Date: Thu, 16 Jun 2011 13:17:11 -0700
Message-Id: <1308255470-3826-38-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of the unused dev_type field in hv_device and hv_driver as they
are not used.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 3bf1c46..370b096 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -808,7 +808,6 @@ struct hv_vmbus_device_id {
 /* Base driver object */
 struct hv_driver {
 	/* the device type supported by this driver */
-	struct hv_guid dev_type;
 	const struct hv_vmbus_device_id *id_table;
 
 	struct device_driver driver;
@@ -822,7 +821,6 @@ struct hv_driver {
 /* Base device object */
 struct hv_device {
 	/* the device type id of this device */
-	struct hv_guid dev_type;
 	const char *device_type;
 
 	/* the device instance id of this device */
-- 
1.7.4.1

