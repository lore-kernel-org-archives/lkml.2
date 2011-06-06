Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab1FFWrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:47:00 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37225
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757484Ab1FFWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 10/49] Staging: hv: mouse: Get rid of the unused initialization of the name field
Date: Mon,  6 Jun 2011 15:49:34 -0700
Message-Id: <1307400613-13234-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name field of hv_driver is unused in hv_mouse.c; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 359e737..b191810 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -936,7 +936,6 @@ static int __init mousevsc_init(void)
 	       sizeof(struct hv_guid));
 
 	drv->driver.name = driver_name;
-	drv->name = driver_name;
 
 	/* The driver belongs to vmbus */
 	vmbus_child_driver_register(&drv->driver);
-- 
1.7.4.1

