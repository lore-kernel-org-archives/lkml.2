Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999Ab0GSX6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:58:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64318 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760979Ab0GSX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:41 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 04/49] memblock: No reason to include asm/memblock.h late
Date: Mon, 19 Jul 2010 16:56:13 -0700
Message-Id: <1279583818-14249-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C44E688.004C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 86e7daf..4b69313 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -16,6 +16,8 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 
+#include <asm/memblock.h>
+
 #define MAX_MEMBLOCK_REGIONS 128
 
 struct memblock_region {
@@ -82,8 +84,6 @@ memblock_end_pfn(struct memblock_type *type, unsigned long region_nr)
 	       memblock_size_pages(type, region_nr);
 }
 
-#include <asm/memblock.h>
-
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_MEMBLOCK_H */
-- 
1.6.4.2

