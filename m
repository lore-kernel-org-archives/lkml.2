Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab0HDCw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:52:59 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:35853 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932540Ab0HDCw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: bNQ4tB8VM1m8XTNXoRjL9ofCmGodHQkN11VkRorcupANkmc
 xVQoLmY.CYSi0UkpLr7qs2jNQDSFMAyA4t_BZAOWVPbnx8VBmf1v58RZjazZ
 gQdUUHpwyUtXnsayYWSuHsu4cPoQWz7vIiWGgJi8a.ZHGer7.Wf_lMOyyALB
 DJLZr.xjqzaWwUw_p2b1N7.1dMW4iMee.Fvd18LD7bJQgFuH4sXos7XOK4uN
 u8HfgIhWts2C3PCO5XOoMCSEqYqo2Ze31Asm9U4m1U.QGqDLmJh5et1GLIdL
 yLYvKNZhngOCKk70o
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024526.143898224@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:18 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [S+Q3 04/23] SLUB: Constants need UL
References: <20100804024514.139976032@linux.com>
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
 


