Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965163Ab2JWUmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:42:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51422 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933810Ab2JWUF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:27 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH 041/193] drivers/dma: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:54 -0700
Message-Id: <1351022666-6960-42-git-send-email-keescook@chromium.org>
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

CC: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/dma/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 677cd6e..dc8f4d1 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -51,7 +51,7 @@ config ASYNC_TX_ENABLE_CHANNEL_SWITCH
 
 config AMBA_PL08X
 	bool "ARM PrimeCell PL080 or PL081 support"
-	depends on ARM_AMBA && EXPERIMENTAL
+	depends on ARM_AMBA
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
1.7.9.5

