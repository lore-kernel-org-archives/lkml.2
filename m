Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1HYQ3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:29:13 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60093
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753602Ab1HYQ27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 23/59] Staging: hv: vmbus: Get rid of some unnecessary comments
Date: Thu, 25 Aug 2011 09:48:49 -0700
Message-Id: <1314290965-2698-23-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some unnecessary comments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index dbb51b0..e467c56 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -44,8 +44,6 @@ static struct tasklet_struct event_dpc;
 
 unsigned int vmbus_loglevel = (ALL_MODULES << 16 | INFO_LVL);
 EXPORT_SYMBOL(vmbus_loglevel);
-	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
-	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
 
 static struct completion probe_event;
 static int irq;
-- 
1.7.4.1

