Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab1DFWzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:55:55 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52213
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756627Ab1DFWyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 20/22] Staging: hv: Fix a jump label (Remove) in blkvsc_drv.c
Date: Wed,  6 Apr 2011 16:05:20 -0700
Message-Id: <1302131122-15530-20-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the jump labels was named Remove; change it to remove.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index a47581c..3229ebc 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -1005,7 +1005,7 @@ static int blkvsc_probe(struct device *device)
 				DPRINT_ERR(BLKVSC_DRV,
 					   "register_blkdev() failed! ret %d",
 					   ret);
-				goto Remove;
+				goto remove;
 			}
 
 			ide0_registered = 1;
@@ -1020,7 +1020,7 @@ static int blkvsc_probe(struct device *device)
 				DPRINT_ERR(BLKVSC_DRV,
 					   "register_blkdev() failed! ret %d",
 					   ret);
-				goto Remove;
+				goto remove;
 			}
 
 			ide1_registered = 1;
@@ -1071,7 +1071,7 @@ static int blkvsc_probe(struct device *device)
 
 	return ret;
 
-Remove:
+remove:
 	storvsc_drv_obj->base.dev_rm(device_obj);
 
 cleanup:
-- 
1.7.4.1

