Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2J3KLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab2J3KLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:11:08 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, krkumar2@in.ibm.com
Cc: kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [rfc net-next v6 1/3] virtio_net: Introduce VIRTIO_NET_F_MULTIQUEUE
Date: Tue, 30 Oct 2012 18:03:21 +0800
Message-Id: <1351591403-23065-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1351591403-23065-1-git-send-email-jasowang@redhat.com>
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Introduce VIRTIO_NET_F_MULTIQUEUE.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/uapi/linux/virtio_net.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 2470f54..1bc7e30 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -51,6 +51,7 @@
 #define VIRTIO_NET_F_CTRL_RX_EXTRA 20	/* Extra RX mode control support */
 #define VIRTIO_NET_F_GUEST_ANNOUNCE 21	/* Guest can announce device on the
 					 * network */
+#define VIRTIO_NET_F_MULTIQUEUE	22	/* Device supports multiple TXQ/RXQ */
 
 #define VIRTIO_NET_S_LINK_UP	1	/* Link is up */
 #define VIRTIO_NET_S_ANNOUNCE	2	/* Announcement is needed */
-- 
1.7.1

