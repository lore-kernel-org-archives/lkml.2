Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab1FFWl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:41:27 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39447
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758187Ab1FFWfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 30/49] Staging: hv: vmbus: Get rid of the unused function vmbus_ontimer()
Date: Mon,  6 Jun 2011 15:49:54 -0700
Message-Id: <1307400613-13234-30-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of the unused function vmbus_ontimer().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index b91b369..3e4422b 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -874,15 +874,3 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
-
-/*
- * vmbus_ontimer - Timer event callback
- */
-void vmbus_ontimer(unsigned long data)
-{
-	struct vmbus_channel *channel = (struct vmbus_channel *)data;
-
-	if (channel->onchannel_callback)
-		channel->onchannel_callback(channel->channel_callback_context);
-}
-
-- 
1.7.4.1

