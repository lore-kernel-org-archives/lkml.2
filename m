Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab1EIWIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:08:35 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47388
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753108Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 032/206] Staging: hv: Rename g_driver_name
Date: Mon,  9 May 2011 14:55:14 -0700
Message-Id: <1304978288-22999-32-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index c54a5fe..d19df02 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -40,7 +40,7 @@
 #include "channel.h"
 
 
-static const char *g_driver_name = "storvsc";
+static const char *driver_name = "storvsc";
 
 /* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
 static const struct hv_guid gStorVscDeviceType = {
@@ -91,7 +91,7 @@ static int stor_vsc_initialize(struct hv_driver *driver)
 
 	/* Make sure we are at least 2 pages since 1 page is used for control */
 
-	driver->name = g_driver_name;
+	driver->name = driver_name;
 	memcpy(&driver->dev_type, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
-- 
1.7.4.1

