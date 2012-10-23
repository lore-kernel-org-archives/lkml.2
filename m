Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab2JWVPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:15:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35216 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636Ab2JWUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:00 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 037/193] drivers/base: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:50 -0700
Message-Id: <1351022666-6960-38-git-send-email-keescook@chromium.org>
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
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/base/Kconfig |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 08b4c52..e439ebc 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -57,7 +57,7 @@ config DEVTMPFS_MOUNT
 	  on the rootfs is completely empty.
 
 config STANDALONE
-	bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
+	bool "Select only drivers that don't need compile-time external firmware"
 	default y
 	help
 	  Select this option if you don't have magic firmware for drivers that
@@ -185,7 +185,6 @@ config DMA_SHARED_BUFFER
 	bool
 	default n
 	select ANON_INODES
-	depends on EXPERIMENTAL
 	help
 	  This option enables the framework for buffer-sharing between
 	  multiple drivers. A buffer is associated with a file using driver
@@ -193,8 +192,8 @@ config DMA_SHARED_BUFFER
 	  driver.
 
 config CMA
-	bool "Contiguous Memory Allocator (EXPERIMENTAL)"
-	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK && EXPERIMENTAL
+	bool "Contiguous Memory Allocator"
+	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK
 	select MIGRATION
 	select MEMORY_ISOLATION
 	help
-- 
1.7.9.5

