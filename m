Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2DMD0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 23:26:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37762 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab2DMD0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 23:26:11 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, stefanha@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] virtio_ring: remove unused code in virtqueue_notify()
Date: Fri, 13 Apr 2012 11:26:03 +0800
Message-Id: <1334287563-8865-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041303-9360-0000-0000-0000056056AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/virtio/virtio_ring.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..c6a54e6 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -343,8 +343,6 @@ EXPORT_SYMBOL_GPL(virtqueue_kick_prepare);
  */
 void virtqueue_notify(struct virtqueue *_vq)
 {
-	struct vring_virtqueue *vq = to_vvq(_vq);
-
 	/* Prod other side to tell it about changes. */
 	vq->notify(_vq);
 }
-- 
1.7.6

