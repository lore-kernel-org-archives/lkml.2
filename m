Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1EIVzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:55:25 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47572
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755012Ab1EIVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 078/206] Staging: hv: Get rid of unnecessary code in netvsc.c
Date: Mon,  9 May 2011 14:56:00 -0700
Message-Id: <1304978288-22999-78-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we had gotten rid of the indirection; get rid of some
unnecessary code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 34828c4..832f62e 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -1184,9 +1184,6 @@ int netvsc_initialize(struct hv_driver *drv)
 	drv->name = driver_name;
 	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
 
-	/* Setup the dispatch table */
-	driver->base.dev_add	= netvsc_device_add;
-	driver->base.dev_rm	= netvsc_device_remove;
 
 	driver->send			= netvsc_send;
 
-- 
1.7.4.1

