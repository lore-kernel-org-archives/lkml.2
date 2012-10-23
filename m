Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416Ab2JWUzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:55:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37079 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933743Ab2JWUFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 117/193] drivers/remoteproc: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:10 -0700
Message-Id: <1351022666-6960-118-git-send-email-keescook@chromium.org>
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

