Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472Ab2JWU7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:59:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55812 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933722Ab2JWUFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:15 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Pete Zaitcev <zaitcev@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH 038/193] drivers/block: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:51 -0700
Message-Id: <1351022666-6960-39-git-send-email-keescook@chromium.org>
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

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Asai Thambi S P <asamymuthupa@micron.com>
CC: Pete Zaitcev <zaitcev@redhat.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>
CC: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f529407..6983a65 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -166,8 +166,8 @@ config BLK_DEV_DAC960
 	  module will be called DAC960.
 
 config BLK_DEV_UMEM
-	tristate "Micro Memory MM5415 Battery Backed RAM support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Micro Memory MM5415 Battery Backed RAM support"
+	depends on PCI
 	---help---
 	  Saying Y here will include support for the MM5415 family of
 	  battery backed (Non-volatile) RAM cards.
@@ -430,8 +430,8 @@ config CDROM_PKTCDVD_BUFFERS
 	  a disc is opened for writing.
 
 config CDROM_PKTCDVD_WCACHE
-	bool "Enable write caching (EXPERIMENTAL)"
-	depends on CDROM_PKTCDVD && EXPERIMENTAL
+	bool "Enable write caching"
+	depends on CDROM_PKTCDVD
 	help
 	  If enabled, write caching will be set for the CD-R/W device. For now
 	  this option is dangerous unless the CD-RW media is known good, as we
@@ -508,8 +508,8 @@ config XEN_BLKDEV_BACKEND
 
 
 config VIRTIO_BLK
-	tristate "Virtio block driver (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && VIRTIO
+	tristate "Virtio block driver"
+	depends on VIRTIO
 	---help---
 	  This is the virtual block driver for virtio.  It can be used with
           lguest or QEMU based VMMs (like KVM or Xen).  Say Y or M.
@@ -528,7 +528,7 @@ config BLK_DEV_HD
 
 config BLK_DEV_RBD
 	tristate "Rados block device (RBD)"
-	depends on INET && EXPERIMENTAL && BLOCK
+	depends on INET && BLOCK
 	select CEPH_LIB
 	select LIBCRC32C
 	select CRYPTO_AES
-- 
1.7.9.5

