Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1KJUH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 15:07:58 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:38919 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1KJUHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 15:07:54 -0500
Subject: [PATCH] hexagon: drop selects of bogus Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 21:07:47 +0100
Message-ID: <1320955667.27598.72.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no Kconfig symbols named GENERIC_HARDIRQS_NO__DO_IRQ and
GENERIC_HARDIRQS_NO_DEPRECATED. The two select statements for these
symbols are nops. Drop these.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by running "yes "" | make ARCH=hexagon config" before and after
applying this patch. Identical .config files were generated.
 
 arch/hexagon/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 02513c2..f03740e 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -18,8 +18,6 @@ config HEXAGON
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
-	select GENERIC_HARDIRQS_NO__DO_IRQ
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	# GENERIC_ALLOCATOR is used by dma_alloc_coherent()
 	select GENERIC_ALLOCATOR
 	select GENERIC_IRQ_SHOW
-- 
1.7.4.4



