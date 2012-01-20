Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2ATIU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2ATIUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:20:55 -0500
Subject: [PATCH 1/2] virtio: fix typos of memory barriers
To: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org
Date: Fri, 20 Jan 2012 16:16:59 +0800
Message-ID: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/3.1-rc9-1929-g8b3408
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 79e1b29..78428a8 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -35,7 +35,7 @@
 #define virtio_rmb(vq) \
 	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
 #define virtio_wmb(vq) \
-	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
+	do { if ((vq)->weak_barriers) smp_wmb(); else wmb(); } while(0)
 #else
 /* We must force memory ordering even if guest is UP since host could be
  * running on another CPU, but SMP barriers are defined to barrier() in that

