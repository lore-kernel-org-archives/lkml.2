Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0GITQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:16:16 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34309 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0GITMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:19 -0400
Message-Id: <20100709190852.622630369@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:11 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [S+Q2 05/19] SLUB: Constants need UL
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=slub_constant_ul
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UL suffix is missing in some constants. Conform to how slab.h uses constants.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-06 14:53:16.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-06 15:08:24.000000000 -0500
@@ -162,8 +162,8 @@
 #define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
 
 /* Internal SLUB flags */
-#define __OBJECT_POISON		0x80000000 /* Poison object */
-#define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
+#define __OBJECT_POISON		0x80000000UL /* Poison object */
+#define __SYSFS_ADD_DEFERRED	0x40000000UL /* Not yet visible via sysfs */
 
 static int kmem_size = sizeof(struct kmem_cache);
 


