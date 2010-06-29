Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0F2H3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:29:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:50508 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab0F2H3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:29:17 -0400
Date: Tue, 29 Jun 2010 16:29:02 +0900
To: mattst88@gmail.com
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net, linux-alpha@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: remove homegrown L1_CACHE_ALIGN macro
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100629162252L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 29 Jun 2010 16:29:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use the standard L1_CACHE_ALIGN macro instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/include/asm/cache.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/cache.h b/arch/alpha/include/asm/cache.h
index f199e69..ad368a9 100644
--- a/arch/alpha/include/asm/cache.h
+++ b/arch/alpha/include/asm/cache.h
@@ -17,7 +17,6 @@
 # define L1_CACHE_SHIFT     5
 #endif
 
-#define L1_CACHE_ALIGN(x)  (((x)+(L1_CACHE_BYTES-1))&~(L1_CACHE_BYTES-1))
 #define SMP_CACHE_BYTES    L1_CACHE_BYTES
 
 #endif
-- 
1.6.5

