Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0JETpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:45:20 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:48958 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756513Ab0JETpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:45:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: L_azQAUVM1nu26n4IxcBhu8Jcw7nTdwIiVnufsTnbgj1zpX
 dfT73s6BHD3NwQIj2Iip7fKZTh4NhKJ24QTAbn8n7kfbte98a6P6NVr7FoPP
 CiEMpyh21Fj8BpV_TqZNqlfZjzOhE9bKs13VMqyWvfSwu.yC8yAhrCSc0y5Q
 YrnunAoLfRpRBc31_9o.0LkjzQyacXJNYKkPcqtv1SZeIkiXlx18qLqpkFxc
 cc60_QcIxntZENRCkm5tNDL36ORdc4YVv2_jbobdFYb08NPp7jKkZ_MBcwZk
 P9ksu_6duS7euQdqO
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101005185815.287555262@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 13:57:31 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>
Subject: [UnifiedV4 06/16] slub: Drop allocator announcement
References: <20101005185725.088808842@linux.com>
Content-Disposition: inline; filename=unified_remove_banner
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People get confused because the output repeats some basic hardware
configuration values. Some of the items listed no
longer have the same relevance in the queued form of SLUB.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-10-02 18:10:45.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-10-02 18:10:50.000000000 -0500
@@ -3249,12 +3249,6 @@ void __init kmem_cache_init(void)
 		}
 	}
 #endif
-	printk(KERN_INFO
-		"SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
-		" CPUs=%d, Nodes=%d\n",
-		caches, cache_line_size(),
-		slub_min_order, slub_max_order, slub_min_objects,
-		nr_cpu_ids, nr_node_ids);
 }
 
 void __init kmem_cache_init_late(void)

