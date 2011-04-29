Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab1D2Ud7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:33:59 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41633
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933765Ab1D2Uc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:32:28 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 18/18] Staging: hv: Get rid of an unused variable from struct hv_driver
Date: Fri, 29 Apr 2011 13:45:16 -0700
Message-Id: <1304109916-24874-18-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304109916-24874-1-git-send-email-kys@microsoft.com>
References: <1304109779-24819-1-git-send-email-kys@microsoft.com>
 <1304109916-24874-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name field is unused in struct hv_driver. Get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_api.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 8e6c107..50fbeb5 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -108,8 +108,6 @@ struct hv_driver {
 
 /* Base device object */
 struct hv_device {
-	char name[64];
-
 	/* the device type id of this device */
 	struct hv_guid dev_type;
 
-- 
1.7.4.1

