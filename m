Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095Ab2JWUkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:40:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39273 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816Ab2JWUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:30 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 008/193] arch/arm/mach-s3c24xx: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:21 -0700
Message-Id: <1351022666-6960-9-git-send-email-keescook@chromium.org>
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

CC: Ben Dooks <ben-linux@fluff.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/mach-s3c24xx/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 2b6cb5f..c2ca287 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -291,8 +291,8 @@ config MACH_JIVE
 	  Say Y here if you are using the Logitech Jive.
 
 config MACH_JIVE_SHOW_BOOTLOADER
-	bool "Allow access to bootloader partitions in MTD (EXPERIMENTAL)"
-	depends on MACH_JIVE && EXPERIMENTAL
+	bool "Allow access to bootloader partitions in MTD"
+	depends on MACH_JIVE
 
 config MACH_S3C2413
 	bool
-- 
1.7.9.5

