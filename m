Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab2KEX2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:28:55 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51231 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab2KEXFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:23 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 034/104] arch/powerpc/platforms/85xx: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:51 -0800
Message-Id: <1352156701-4038-35-git-send-email-keescook@chromium.org>
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

