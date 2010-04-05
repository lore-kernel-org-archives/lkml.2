Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0DEHF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 03:05:58 -0400
Received: from sajino.sajinet.com.pe ([76.74.239.193]:40172 "EHLO
	sajino.sajinet.com.pe" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab0DEHFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 03:05:51 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2010 03:05:51 EDT
From: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
Subject: [PATCH] documentation: slightly more correct value for MAP_HUGETLB in map_hugetlb.c
Date: Sun,  4 Apr 2010 23:54:53 -0700
Message-Id: <1270450493-8790-1-git-send-email-carenas@sajinet.com.pe>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

still not correct for alpha, mips, parisc or xtensa but working out of
the box in the most common architectures without having to deal with
complicated macros or including architecture specific headers.

Signed-off-by: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
---
 Documentation/vm/map_hugetlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/map_hugetlb.c b/Documentation/vm/map_hugetlb.c
index 9969c7d..eda1a6d 100644
--- a/Documentation/vm/map_hugetlb.c
+++ b/Documentation/vm/map_hugetlb.c
@@ -19,7 +19,7 @@
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
 #ifndef MAP_HUGETLB
-#define MAP_HUGETLB 0x40
+#define MAP_HUGETLB 0x40000 /* arch specific */
 #endif
 
 /* Only ia64 requires this */
-- 
1.5.4.3

