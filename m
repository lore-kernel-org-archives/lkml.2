Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2KEX0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:26:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40843 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab2KEXFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:24 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 032/104] arch/parisc: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:49 -0800
Message-Id: <1352156701-4038-33-git-send-email-keescook@chromium.org>
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

CC: "James E.J. Bottomley" <jejb@parisc-linux.org>
CC: Helge Deller <deller@gmx.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/parisc/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 11def45..452a1ce 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -193,12 +193,12 @@ config PARISC_PAGE_SIZE_4KB
 	  If you don't know what to do, choose 4KB.
 
 config PARISC_PAGE_SIZE_16KB
-	bool "16KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	bool "16KB"
+	depends on PA8X00
 
 config PARISC_PAGE_SIZE_64KB
-	bool "64KB (EXPERIMENTAL)"
-	depends on PA8X00 && EXPERIMENTAL
+	bool "64KB"
+	depends on PA8X00
 
 endchoice
 
-- 
1.7.9.5

