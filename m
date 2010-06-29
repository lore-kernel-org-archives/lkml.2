Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0F2Hct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:32:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:50524 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab0F2Hcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:32:48 -0400
Date: Tue, 29 Jun 2010 16:32:42 +0900
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -next] tile: remove homegrown L1_CACHE_ALIGN macro
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100629163018L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 29 Jun 2010 16:32:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use the standard L1_CACHE_ALIGN macro instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/tile/include/asm/cache.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
index c2b7dcf..ee59714 100644
--- a/arch/tile/include/asm/cache.h
+++ b/arch/tile/include/asm/cache.h
@@ -20,7 +20,6 @@
 /* bytes per L1 data cache line */
 #define L1_CACHE_SHIFT		CHIP_L1D_LOG_LINE_SIZE()
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
-#define L1_CACHE_ALIGN(x)	(((x)+(L1_CACHE_BYTES-1)) & -L1_CACHE_BYTES)
 
 /* bytes per L1 instruction cache line */
 #define L1I_CACHE_SHIFT		CHIP_L1I_LOG_LINE_SIZE()
-- 
1.6.5

