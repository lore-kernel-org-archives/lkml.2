Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1EJIls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:41:48 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35368
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756055Ab1EJIav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 151/206] Staging: hv: Get rid of some unused code
Date: Mon,  9 May 2011 14:57:13 -0700
Message-Id: <1304978288-22999-151-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of struct mousevsc_drv_obj.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 0eca451..af4db64 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -45,20 +45,6 @@ struct hv_input_dev_info {
 	char name[128];
 };
 
-/* Represents the input vsc driver */
-/* FIXME - can be removed entirely */
-struct mousevsc_drv_obj {
-	struct hv_driver base;
-};
-
-
-static inline
-struct mousevsc_drv_obj *drv_to_mousedrv(struct device_driver *d)
-{
-	struct hv_driver *hvdrv = drv_to_hv_drv(d);
-	return container_of(hvdrv, struct mousevsc_drv_obj, base);
-}
-
 /* The maximum size of a synthetic input message. */
 #define SYNTHHID_MAX_INPUT_REPORT_SIZE 16
 
-- 
1.7.4.1

