Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1GVPid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:38:33 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:40412
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754524Ab1GVPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:38:32 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH] staging: hv: fix some typos in netvsc.c
Date: Fri, 22 Jul 2011 08:56:32 -0700
Message-Id: <1311350192-13526-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 2b33e13..23328aa 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -249,7 +249,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	if (init_packet->msg.v1_msg.
 	    send_recv_buf_complete.status != NVSP_STAT_SUCCESS) {
 		netdev_err(ndev, "Unable to complete receive buffer "
-			   "initialzation with NetVsp - status %d\n",
+			   "initialization with NetVsp - status %d\n",
 			   init_packet->msg.v1_msg.
 			   send_recv_buf_complete.status);
 		ret = -EINVAL;
@@ -746,7 +746,7 @@ static void netvsc_receive(struct hv_device *device,
 	xferpage_packet->count = count - 1;
 
 	if (xferpage_packet->count != vmxferpage_packet->range_cnt) {
-		netdev_err(ndev, "Needed %d netvsc pkts to satisy "
+		netdev_err(ndev, "Needed %d netvsc pkts to satisfy "
 			"this xfer page...got %d\n",
 			vmxferpage_packet->range_cnt, xferpage_packet->count);
 	}
-- 
1.6.3.2

