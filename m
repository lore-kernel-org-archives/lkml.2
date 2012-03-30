Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab2C3Wt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:49:58 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935006Ab2C3VGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:15 -0400
Message-Id: <201203302105.q2UL59tD006309@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 15:55:13 -0400
Subject: [PATCH] arch/tile: fix a reference to cpu_possible_map in a comment
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:09.0225 (UTC) FILETIME=[CA2BC590:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 1d43be6..ee68fd2 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1158,7 +1158,7 @@ EXPORT_SYMBOL(hash_for_home_map);
 
 /*
  * cpu_cacheable_map lists all the cpus whose caches the hypervisor can
- * flush on our behalf.  It is set to cpu_possible_map OR'ed with
+ * flush on our behalf.  It is set to cpu_possible_mask OR'ed with
  * hash_for_home_map, and it is what should be passed to
  * hv_flush_remote() to flush all caches.  Note that if there are
  * dedicated hypervisor driver tiles that have authorized use of their
-- 
1.6.5.2

