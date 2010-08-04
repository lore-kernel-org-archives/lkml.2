Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab0HDCy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:54:29 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:28829 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758214Ab0HDCwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _3C30koVM1l7O.7tq21hEZd3GcbmuaQqgzaSy_FyabXowpy
 Hfuwa9GwM0JHPh42jJzS.O8clbtjXa7QYg20Gy3Ec1lq4JKX8r8Hh50VubeN
 P6.FELTOmaU91Iumih5y9aFPMwlsbiP8A1bqVUJ4NbrBn5FfhQW4o1UaaGRP
 pyeXr8RIbU91eR45RMnFklvopiMWfTdP7JaecyftmSB7XBDZ0p1EHjBioYoy
 IlSkW1jBTOpobwXtD5QpjMFVHVBelrC18NA9nGKe40EHAf6Gj
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024534.202416229@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:32 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 18/23] slub: Drop allocator announcement
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=unified_remove_banner
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People get confused because the output repeats some basic hardware
configuration values. Some of the items listed no
longer have the same relevance in the queued form of SLUB.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-30 18:45:28.628439648 -0500
+++ linux-2.6/mm/slub.c	2010-07-30 18:45:32.632522338 -0500
@@ -3229,13 +3229,6 @@
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
 }
 
 void __init kmem_cache_init_late(void)

