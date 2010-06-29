Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab0F2H3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:29:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:50510 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab0F2H3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:29:21 -0400
Date: Tue, 29 Jun 2010 16:29:04 +0900
To: kyle@mcmartin.ca
Cc: linux-parisc@vger.kernel.org, deller@gmx.de, jejb@parisc-linux.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: remove homegrown L1_CACHE_ALIGN macro
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100629162611B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 29 Jun 2010 16:29:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use the standard L1_CACHE_ALIGN macro instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/parisc/include/asm/cache.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
index 45effe6..a050f9f 100644
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -24,8 +24,6 @@
 
 #ifndef __ASSEMBLY__
 
-#define L1_CACHE_ALIGN(x)       (((x)+(L1_CACHE_BYTES-1))&~(L1_CACHE_BYTES-1))
-
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
-- 
1.6.5

