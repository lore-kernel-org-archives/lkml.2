Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab2JWUH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:07:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45254 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606Ab2JWUHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:07:54 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Geoff Levand <geoff@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 024/193] arch/powerpc/platforms/ps3: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:37 -0700
Message-Id: <1351022666-6960-25-git-send-email-keescook@chromium.org>
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

CC: Geoff Levand <geoff@infradead.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/platforms/ps3/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/ps3/Kconfig b/arch/powerpc/platforms/ps3/Kconfig
index 46b7f02..e87c194 100644
--- a/arch/powerpc/platforms/ps3/Kconfig
+++ b/arch/powerpc/platforms/ps3/Kconfig
@@ -48,7 +48,7 @@ config PS3_HTAB_SIZE
 	  system will have optimal runtime performance.
 
 config PS3_DYNAMIC_DMA
-	depends on PPC_PS3 && EXPERIMENTAL
+	depends on PPC_PS3
 	bool "PS3 Platform dynamic DMA page table management"
 	default n
 	help
-- 
1.7.9.5

