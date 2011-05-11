Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab1EKW0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:26:01 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52984 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab1EKWZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:25:20 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] powerpc: tidy up dma_map_ops after adding new hook
Date: Wed, 11 May 2011 15:25:04 -0700
Message-Id: <1305152704-4864-9-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

The new get_required_mask hook name is longer than many of but not all
of the prior ops.  Tidy the struct initializers to align the equal signs
using the local whitespace.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/kernel/dma-iommu.c |   14 +++++++-------
 arch/powerpc/kernel/dma.c       |   16 ++++++++--------
 arch/powerpc/kernel/ibmebus.c   |   14 +++++++-------
 arch/powerpc/kernel/vio.c       |   14 +++++++-------
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index c1ad9db..6f04b9c 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -104,13 +104,13 @@ static u64 dma_iommu_get_required_mask(struct device *dev)
 }
 
 struct dma_map_ops dma_iommu_ops = {
-	.alloc_coherent	= dma_iommu_alloc_coherent,
-	.free_coherent	= dma_iommu_free_coherent,
-	.map_sg		= dma_iommu_map_sg,
-	.unmap_sg	= dma_iommu_unmap_sg,
-	.dma_supported	= dma_iommu_dma_supported,
-	.map_page	= dma_iommu_map_page,
-	.unmap_page	= dma_iommu_unmap_page,
+	.alloc_coherent		= dma_iommu_alloc_coherent,
+	.free_coherent		= dma_iommu_free_coherent,
+	.map_sg			= dma_iommu_map_sg,
+	.unmap_sg		= dma_iommu_unmap_sg,
+	.dma_supported		= dma_iommu_dma_supported,
+	.map_page		= dma_iommu_map_page,
+	.unmap_page		= dma_iommu_unmap_page,
 	.get_required_mask	= dma_iommu_get_required_mask,
 };
 EXPORT_SYMBOL(dma_iommu_ops);
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index df142d1..f94df52 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -149,14 +149,14 @@ static inline void dma_direct_sync_single(struct device *dev,
 #endif
 
 struct dma_map_ops dma_direct_ops = {
-	.alloc_coherent	= dma_direct_alloc_coherent,
-	.free_coherent	= dma_direct_free_coherent,
-	.map_sg		= dma_direct_map_sg,
-	.unmap_sg	= dma_direct_unmap_sg,
-	.dma_supported	= dma_direct_dma_supported,
-	.map_page	= dma_direct_map_page,
-	.unmap_page	= dma_direct_unmap_page,
-	.get_required_mask	= dma_direct_get_required_mask,
+	.alloc_coherent			= dma_direct_alloc_coherent,
+	.free_coherent			= dma_direct_free_coherent,
+	.map_sg				= dma_direct_map_sg,
+	.unmap_sg			= dma_direct_unmap_sg,
+	.dma_supported			= dma_direct_dma_supported,
+	.map_page			= dma_direct_map_page,
+	.unmap_page			= dma_direct_unmap_page,
+	.get_required_mask		= dma_direct_get_required_mask,
 #ifdef CONFIG_NOT_COHERENT_CACHE
 	.sync_single_for_cpu 		= dma_direct_sync_single,
 	.sync_single_for_device 	= dma_direct_sync_single,
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 90ef2a4..73110fb 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -134,14 +134,14 @@ static u64 ibmebus_dma_get_required_mask(struct device *dev)
 }
 
 static struct dma_map_ops ibmebus_dma_ops = {
-	.alloc_coherent = ibmebus_alloc_coherent,
-	.free_coherent  = ibmebus_free_coherent,
-	.map_sg         = ibmebus_map_sg,
-	.unmap_sg       = ibmebus_unmap_sg,
-	.dma_supported  = ibmebus_dma_supported,
+	.alloc_coherent     = ibmebus_alloc_coherent,
+	.free_coherent      = ibmebus_free_coherent,
+	.map_sg             = ibmebus_map_sg,
+	.unmap_sg           = ibmebus_unmap_sg,
+	.dma_supported      = ibmebus_dma_supported,
 	.get_required_mask  = ibmebus_dma_get_required_mask,
-	.map_page       = ibmebus_map_page,
-	.unmap_page     = ibmebus_unmap_page,
+	.map_page           = ibmebus_map_page,
+	.unmap_page         = ibmebus_unmap_page,
 };
 
 static int ibmebus_match_path(struct device *dev, void *data)
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index c049325..34d291d 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -611,13 +611,13 @@ static u64 vio_dma_get_required_mask(struct device *dev)
 }
 
 struct dma_map_ops vio_dma_mapping_ops = {
-	.alloc_coherent = vio_dma_iommu_alloc_coherent,
-	.free_coherent  = vio_dma_iommu_free_coherent,
-	.map_sg         = vio_dma_iommu_map_sg,
-	.unmap_sg       = vio_dma_iommu_unmap_sg,
-	.map_page       = vio_dma_iommu_map_page,
-	.unmap_page     = vio_dma_iommu_unmap_page,
-	.dma_supported  = vio_dma_iommu_dma_supported,
+	.alloc_coherent    = vio_dma_iommu_alloc_coherent,
+	.free_coherent     = vio_dma_iommu_free_coherent,
+	.map_sg            = vio_dma_iommu_map_sg,
+	.unmap_sg          = vio_dma_iommu_unmap_sg,
+	.map_page          = vio_dma_iommu_map_page,
+	.unmap_page        = vio_dma_iommu_unmap_page,
+	.dma_supported     = vio_dma_iommu_dma_supported,
 	.get_required_mask = vio_dma_get_required_mask,
 };
 
-- 
1.7.4.1

