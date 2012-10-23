Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab2JWUog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:44:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36639 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429Ab2JWUF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:27 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 132/193] drivers/virtio: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:25 -0700
Message-Id: <1351022666-6960-133-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/virtio/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 8d5bddb..c6683f2 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -8,8 +8,8 @@ config VIRTIO
 menu "Virtio drivers"
 
 config VIRTIO_PCI
-	tristate "PCI driver for virtio devices (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "PCI driver for virtio devices"
+	depends on PCI
 	select VIRTIO
 	---help---
 	  This drivers provides support for virtio based paravirtual device
@@ -32,8 +32,8 @@ config VIRTIO_BALLOON
 	 If unsure, say M.
 
  config VIRTIO_MMIO
- 	tristate "Platform bus driver for memory mapped virtio devices (EXPERIMENTAL)"
- 	depends on HAS_IOMEM && EXPERIMENTAL
+	tristate "Platform bus driver for memory mapped virtio devices"
+	depends on HAS_IOMEM
  	select VIRTIO
  	---help---
  	 This drivers provides support for memory mapped virtio
-- 
1.7.9.5

