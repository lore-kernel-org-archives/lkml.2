Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab1KPNuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:50:39 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:39004 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab1KPNui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:50:38 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        annie.li@oracle.com
Subject: [PATCH 3/3] xen/granttable: Keep code format clean
Date: Wed, 16 Nov 2011 21:50:31 +0800
Message-Id: <1321451431-13632-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4EC3B62F.6080702@oracle.com>
References: <4EC3B62F.6080702@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EC3BFA9.0021,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Annie Li <annie.li@oracle.com>

Signed-off-by: Annie Li <annie.li@oracle.com>
---
 drivers/xen/grant-table.c |    7 +++----
 include/xen/grant_table.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 0b412ce..a7eabb0 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -50,7 +50,6 @@
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
-
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
 #define GNTTAB_LIST_END 0xffffffff
@@ -597,8 +596,8 @@ unsigned int gnttab_max_grant_frames(void)
 EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
-			struct gnttab_map_grant_ref *kmap_ops,
-			struct page **pages, unsigned int count)
+		    struct gnttab_map_grant_ref *kmap_ops,
+		    struct page **pages, unsigned int count)
 {
 	int i, ret;
 	pte_t *pte;
@@ -648,7 +647,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
 EXPORT_SYMBOL_GPL(gnttab_map_refs);
 
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
-		struct page **pages, unsigned int count)
+		      struct page **pages, unsigned int count)
 {
 	int i, ret;
 
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 5494c40..fea4954 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -157,7 +157,7 @@ unsigned int gnttab_max_grant_frames(void);
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
-			struct gnttab_map_grant_ref *kmap_ops,
+		    struct gnttab_map_grant_ref *kmap_ops,
 		    struct page **pages, unsigned int count);
 int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
 		      struct page **pages, unsigned int count);
-- 
1.7.6.4

