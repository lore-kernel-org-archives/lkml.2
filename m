Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab0KPVct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:32:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:64325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598Ab0KPVcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:32:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,207,1288594800"; 
   d="scan'208";a="574453889"
Message-Id: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 16 Nov 2010 13:23:50 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>
Subject: [patch 1/2] bootmem: add alloc_bootmem_align()
Content-Disposition: inline; filename=add_alloc_bootmem_align.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/bootmem.h |    2 ++
 1 file changed, 2 insertions(+)

Index: tree/include/linux/bootmem.h
===================================================================
--- tree.orig/include/linux/bootmem.h
+++ tree/include/linux/bootmem.h
@@ -105,6 +105,8 @@ extern void *__alloc_bootmem_low_node(pg
 
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_align(x, align) \
+	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_nopanic(x) \
 	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages(x) \


