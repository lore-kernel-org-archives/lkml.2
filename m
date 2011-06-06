Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab1FFWjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:39:22 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58075
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758197Ab1FFWfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 38/49] Staging: hv: vmbus: Get rid of a dated comment in channel_mgmt.c
Date: Mon,  6 Jun 2011 15:50:02 -0700
Message-Id: <1307400613-13234-38-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staging: hv: vmbus: Get rid of a dated comment in channel_mgmt.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 178e1c4..2d270ce 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -477,7 +477,6 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 	newchannel->monitor_grp = (u8)offer->monitorid / 32;
 	newchannel->monitor_bit = (u8)offer->monitorid % 32;
 
-	/* TODO: Make sure the offer comes from our parent partition */
 	INIT_WORK(&newchannel->work, vmbus_process_offer);
 	queue_work(newchannel->controlwq, &newchannel->work);
 }
-- 
1.7.4.1

