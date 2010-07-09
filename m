Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0GITNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:13:51 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34393 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab0GITMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:25 -0400
Message-Id: <20100709190901.044653725@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:25 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q2 19/19] slub: Drop allocator announcement
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=mininum_objects
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People get confused because of the output and some of the items listed no
longer have the same relevance in the queued form of SLUB.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    8 --------
 1 file changed, 8 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-07 10:54:36.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-07 10:54:41.000000000 -0500
@@ -3153,14 +3153,6 @@ void __init kmem_cache_init(void)
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
 #endif
-
-	printk(KERN_INFO
-		"SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
-		" CPUs=%d, Nodes=%d\n",
-		caches, cache_line_size(),
-		slub_min_order, slub_max_order, slub_min_objects,
-		nr_cpu_ids, nr_node_ids);
-
 }
 
 void __init kmem_cache_init_late(void)

