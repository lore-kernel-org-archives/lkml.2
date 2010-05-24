Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0EXAIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:08:12 -0400
Received: from xenotime.net ([72.52.115.56]:47394 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755622Ab0EXAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:08:04 -0400
Date: Sun, 23 May 2010 17:02:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
Subject: [PATCH 5/9] Documentation/vm: use better value for MAP_HUGETLB
Message-ID: <12746593503067@xenotime.net>
In-Reply-To: <12746593501290@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>

documentation: slightly more correct value for MAP_HUGETLB in map_hugetlb.c

still not correct for alpha, mips, parisc or xtensa but working out of
the box in the most common architectures without having to deal with
complicated macros or including architecture specific headers.

Signed-off-by: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/vm/map_hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2634-docs.orig/Documentation/vm/map_hugetlb.c
+++ lnx-2634-docs/Documentation/vm/map_hugetlb.c
@@ -19,7 +19,7 @@
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
 #ifndef MAP_HUGETLB
-#define MAP_HUGETLB 0x40
+#define MAP_HUGETLB 0x40000 /* arch specific */
 #endif
 
 /* Only ia64 requires this */


-- 

