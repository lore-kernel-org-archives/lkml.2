Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab1AaGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 01:16:28 -0500
Received: from ozlabs.org ([203.10.76.45]:50244 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1AaGQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 01:16:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] virtio: update MAINTAINERS
Date: Mon, 31 Jan 2011 16:46:20 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311646.20873.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches should keep coming through Rusty but it
helps if I'm Cc'd as well.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 23d0436..7de75ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6439,6 +6439,16 @@ S:	Maintained
 F:	drivers/char/virtio_console.c
 F:	include/linux/virtio_console.h
 
+VIRTIO CORE, NET AND BLOCK DRIVERS
+M:	Rusty Russell <rusty@rustcorp.com.au>
+M:	"Michael S. Tsirkin" <mst@redhat.com>
+L:	virtualization@lists.linux-foundation.org
+S:	Maintained
+F:	drivers/virtio/
+F:	drivers/net/virtio_net.c
+F:	drivers/block/virtio_blk.c
+F:	include/linux/virtio_*.h
+
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
