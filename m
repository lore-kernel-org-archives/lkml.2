Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2KEX0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:26:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34631 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab2KEXFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:24 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 072/104] drivers/remoteproc: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:29 -0800
Message-Id: <1352156701-4038-73-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/remoteproc/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 96ce101..f2d2147 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -1,16 +1,14 @@
-menu "Remoteproc drivers (EXPERIMENTAL)"
+menu "Remoteproc drivers"
 
 # REMOTEPROC gets selected by whoever wants it
 config REMOTEPROC
 	tristate
-	depends on EXPERIMENTAL
 	depends on HAS_DMA
 	select FW_CONFIG
 	select VIRTIO
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
-	depends on EXPERIMENTAL
 	depends on HAS_DMA
 	depends on ARCH_OMAP4
 	depends on OMAP_IOMMU
-- 
1.7.9.5

