Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1AQIsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:48:09 -0500
Received: from hall.aurel32.net ([88.191.126.93]:55873 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab1AQIsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:48:06 -0500
X-Greylist: delayed 2014 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 03:48:06 EST
From: Aurelien Jarno <aurelien@aurel32.net>
To: linux-kernel@vger.kernel.org
Cc: Aurelien Jarno <aurelien@aurel32.net>, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] virtio-net: fix a typo
Date: Mon, 17 Jan 2011 09:14:19 +0100
Message-Id: <1295252059-27438-1-git-send-email-aurelien@aurel32.net>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fitler -> filter

Cc: netdev@vger.kernel.org
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 drivers/net/virtio_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 90a23e4..48a4297 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -787,7 +787,7 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
 				  VIRTIO_NET_CTRL_MAC_TABLE_SET,
 				  sg, 2, 0))
-		dev_warn(&dev->dev, "Failed to set MAC fitler table.\n");
+		dev_warn(&dev->dev, "Failed to set MAC filter table.\n");
 
 	kfree(buf);
 }
-- 
1.7.2.3

