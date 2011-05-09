Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1EIV4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:56:25 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54292
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755000Ab1EIVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 084/206] Staging: hv: Get rid of dev_add from struct hv_driver
Date: Mon,  9 May 2011 14:56:06 -0700
Message-Id: <1304978288-22999-84-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have gotten rid of the indirection, get rid of the
unnecessary state struct hv_driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_api.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 50fbeb5..b1a7e88 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -96,7 +96,6 @@ struct hv_driver {
 
 	struct device_driver driver;
 
-	int (*dev_add)(struct hv_device *device, void *data);
 	int (*dev_rm)(struct hv_device *device);
 	void (*cleanup)(struct hv_driver *driver);
 
-- 
1.7.4.1

