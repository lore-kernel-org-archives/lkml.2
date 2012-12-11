Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2LKVu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:50:27 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:55360 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab2LKVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:17 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/19] MAINTAINERS: fix arch/arm/mach-at91/include/mach/at_hdmac.h
Date: Tue, 11 Dec 2012 19:49:47 -0200
Message-Id: <1355262601-4263-6-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to include/linux/platform_data/dma-atmel.h by commit
7cdc39e (ARM: at91: move platform_data definitions).

Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f5df323..1fb780e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1389,7 +1389,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	drivers/dma/at_hdmac.c
 F:	drivers/dma/at_hdmac_regs.h
-F:	arch/arm/mach-at91/include/mach/at_hdmac.h
+F:	include/linux/platform_data/dma-atmel.h
 
 ATMEL ISI DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
-- 
1.7.11.7

