Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2FYJXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:23:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab2FYJXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:23:13 -0400
Subject: [net-next RFC V4 PATCH 1/4] virtio_net: Introduce
 VIRTIO_NET_F_MULTIQUEUE
To: krkumar2@in.ibm.com, habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        mst@redhat.com, netdev@vger.kernel.org, mashirle@us.ibm.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, akong@redhat.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Date: Mon, 25 Jun 2012 17:17:01 +0800
Message-ID: <20120625091701.7263.19689.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120625090829.7263.65026.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

