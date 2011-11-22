Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab1KVCAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:00:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:52880 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1KVCAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:00:00 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        annie.li@oracle.com
Subject: [PATCH 4/4] xen/granttable: Keep code format clean
Date: Tue, 22 Nov 2011 09:59:56 +0800
Message-Id: <1321927196-4022-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4ECA416D.90602@oracle.com>
References: <4ECA416D.90602@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4ECB021C.0068,ss=1,re=0.000,fgs=0
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
index 77a060c..b76f419 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -50,7 +50,6 @@
 #include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
-
 /* External tools reserve first few grant table entries. */
 #define NR_RESERVED_ENTRIES 8
 #define GNTTAB_LIST_END 0xffffffff
@@ -598,8 +597,8 @@ unsigned int gnttab_max_grant_frames(void)
 EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
 
 int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
-			struct gnttab_map_grant_ref *kmap_ops,
-			struct page **pages, unsigned int count)
+		    struct gnttab_map_grant_ref *kmap_ops,
+		    struct page **pages, unsigned int count)
 {
 	int i, ret;
 	pte_t *pte;
@@ -649,7 +648,7 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
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

