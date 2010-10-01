Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0JADJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 23:09:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47039 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0JADJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 23:09:19 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <tony@atomide.com>
Cc: <Hiroshi.DOYU@nokia.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH] scatterlist: define SG chain for arm architecture
Date: Thu, 30 Sep 2010 22:22:34 -0500
Message-Id: <1285903354-7378-1-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define SG chain for ARM architecture in order to work
with big buffers. This patch is needed in order to
iovmm users can pass a big buffer to map it and ARM
architecture has not issues using SG chain.

This change was suggested by FUJITA Tomonori.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/include/asm/scatterlist.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/scatterlist.h b/arch/arm/include/asm/scatterlist.h
index 2f87870..3de0a0b 100644
--- a/arch/arm/include/asm/scatterlist.h
+++ b/arch/arm/include/asm/scatterlist.h
@@ -5,4 +5,6 @@
 #include <asm/types.h>
 #include <asm-generic/scatterlist.h>
 
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* _ASMARM_SCATTERLIST_H */
-- 
1.6.3.3

