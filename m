Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab1IHOEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:04:09 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44669
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933088Ab1IHODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 04/25] Staging: hv: vmbus: Cleanup dated comments in channel_mgmt.c
Date: Thu,  8 Sep 2011 07:24:15 -0700
Message-Id: <1315491876-9554-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup dated comments in channel_mgmt.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 60ce1d1..c68e5fa 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -433,9 +433,6 @@ static void vmbus_process_offer(struct work_struct *work)
 /*
  * vmbus_onoffer - Handler for channel offers from vmbus in parent partition.
  *
- * We ignore all offers except network and storage offers. For each network and
- * storage offers, we create a channel object and queue a work item to the
- * channel object to process the offer synchronously
  */
 static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 {
-- 
1.7.4.1

