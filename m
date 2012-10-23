Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337Ab2JWUwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:52:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47407 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933765Ab2JWUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:21 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 022/193] arch/powerpc/platforms/85xx: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:35 -0700
Message-Id: <1351022666-6960-23-git-send-email-keescook@chromium.org>
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

CC: Kumar Gala <galak@kernel.crashing.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/platforms/85xx/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 02d02a0..92ab60a 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -277,7 +277,6 @@ config P5040_DS
 
 config PPC_QEMU_E500
 	bool "QEMU generic e500 platform"
-	depends on EXPERIMENTAL
 	select DEFAULT_UIMAGE
 	help
 	  This option enables support for running as a QEMU guest using
-- 
1.7.9.5

