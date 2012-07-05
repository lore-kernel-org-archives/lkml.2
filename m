Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2GEKhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2GEKhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:37:41 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net
Cc: akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com,
        Jason Wang <jasowang@redhat.com>
Subject: [net-next RFC V5 1/5] virtio_net: Introduce VIRTIO_NET_F_MULTIQUEUE
Date: Thu,  5 Jul 2012 18:29:50 +0800
Message-Id: <1341484194-8108-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Introduce VIRTIO_NET_F_MULTIQUEUE.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/virtio_net.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 2470f54..1bc7e30 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -51,6 +51,7 @@
 #define VIRTIO_NET_F_CTRL_RX_EXTRA 20	/* Extra RX mode control support */
 #define VIRTIO_NET_F_GUEST_ANNOUNCE 21	/* Guest can announce device on the
 					 * network */
+#define VIRTIO_NET_F_MULTIQUEUE	22	/* Device supports multiple TXQ/RXQ */
 
 #define VIRTIO_NET_S_LINK_UP	1	/* Link is up */
 #define VIRTIO_NET_S_ANNOUNCE	2	/* Announcement is needed */
-- 
1.7.1

