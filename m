Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab1KVK14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:27:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:65424 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1KVK1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:27:55 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Cc: kurt.hackel@oracle.com, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        annie.li@oracle.com
Subject: [PATCH 4/4] xen/granttable: Keep code format clean
Date: Tue, 22 Nov 2011 18:27:52 +0800
Message-Id: <1321957672-10317-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <4ECB77BB.9090401@oracle.com>
References: <4ECB77BB.9090401@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4ECB7927.00E5,ss=1,re=0.000,fgs=0
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
index 94831b8..d747cf3 100644
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

