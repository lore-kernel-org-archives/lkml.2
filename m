Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab1FFWmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:42:03 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58054
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758186Ab1FFWfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 31/49] Staging: hv: vmbus: Get rid of some dated comments in channel.c
Date: Mon,  6 Jun 2011 15:49:55 -0700
Message-Id: <1307400613-13234-31-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some dated comments in channel.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 3e4422b..95b410f 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -633,7 +633,6 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
-	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
@@ -695,7 +694,6 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
-	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
@@ -758,7 +756,6 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
-	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
-- 
1.7.4.1

