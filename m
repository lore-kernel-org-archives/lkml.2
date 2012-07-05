Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2GEKIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:08:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35246 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2GEKIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:08:40 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org
Cc: levinsasha928@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] virtio-blk: add back VIRTIO_BLK_F_FLUSH
Date: Thu,  5 Jul 2012 12:08:22 +0200
Message-Id: <1341482902-13318-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old name is part of the userspace API, add it back for compatibility.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/virtio_blk.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index 18a1027..83a3116 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -41,6 +41,9 @@
 #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
 #define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
 
+/* Backwards-compatibility #defines for renamed features.  */
+#define VIRTIO_BLK_F_FLUSH	VIRTIO_BLK_F_WCE
+
 #define VIRTIO_BLK_ID_BYTES	20	/* ID string length */
 
 struct virtio_blk_config {
-- 
1.7.1

