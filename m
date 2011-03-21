Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1CULg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:36:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53327 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab1CULgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:36:23 -0400
From: manjunatha_halli@ti.com
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 1/2] [media] radio: wl128x: Fix printk format warning
Date: Mon, 21 Mar 2011 08:03:03 -0400
Message-Id: <1300708983-18036-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 12f4c65..96a95c5 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -272,7 +272,7 @@ static void recv_tasklet(unsigned long arg)
 	while ((skb = skb_dequeue(&fmdev->rx_q))) {
 		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
 			fmerr("skb(%p) has only %d bytes"
-				"atleast need %d bytes to decode\n", skb,
+				"need at least %zd bytes to decode\n", skb,
 				skb->len, sizeof(struct fm_event_msg_hdr));
 			kfree_skb(skb);
 			continue;
-- 
1.7.0.4

