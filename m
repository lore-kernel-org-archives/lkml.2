Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1EIV4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:56:50 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54284
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754993Ab1EIVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 082/206] Staging: hv: Get rid of the mouse cleanup() function
Date: Mon,  9 May 2011 14:56:04 -0700
Message-Id: <1304978288-22999-82-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mousevsc_on_cleanup() is an empty function; get rid of it.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index b7016e2..41bfa3f 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -782,9 +782,6 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 	return ret;
 }
 
-static void mousevsc_on_cleanup(struct hv_driver *drv)
-{
-}
 
 /*
  * Data types
@@ -994,7 +991,6 @@ static int mouse_vsc_initialize(struct hv_driver *driver)
 	/* Setup the dispatch table */
 	input_drv->base.dev_add = mousevsc_on_device_add;
 	input_drv->base.dev_rm = mousevsc_on_device_remove;
-	input_drv->base.cleanup = mousevsc_on_cleanup;
 
 	return ret;
 }
-- 
1.7.4.1

