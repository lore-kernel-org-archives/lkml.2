Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2KNIwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:52:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15890 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab2KNIvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:51:42 -0500
X-AuditID: cbfee61b-b7f616d00000319b-20-50a35b8164ae
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH 4/4] iommu/exynos: enhancements of System MMU driver with DT
Date: Wed, 14 Nov 2012 17:51:12 +0900
Message-id: <002401cdc245$32dbf3e0$9893dba0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3CRTKzPUQ/jEhGSVyNNxt67qnKyg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zA93G6MUBBmuWiVhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGV8mrOLreDcLuaKaX3qDYxLnzJ1MXJySAiYSNz5fI4F
	whaTuHBvPVsXIxeHkMAyRonJ5+cxwhQtOfOZHcQWEljEKPH4qiZE0T9GiQWNjWAJNgEtidVz
	jzOCJEQEehklLvR/ZQJxmAUeMEqsOPwQbJ+wgI/EvrUH2UBsFgFViWnNv8FW8ArYSmxvf88K
	YQtK/Jh8D+wmZqCp63ceZ4Kw5SU2r3nL3MXIAXSSusSjv7ogYREBPYnlM5cwQpSISOx78Y4R
	YryAxLfJh1ggymUlNh1gBjlHQmAyu8SxjcehXpaUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDI
	sopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjJHKkdzCuarA4xCjAwajEwxvQvyhAiDWxrLgy
	9xCjBAezkghvrNXiACHelMTKqtSi/Pii0pzU4kOMPkCXT2SWEk3OB0Z1Xkm8obGxiZmJqYm5
	pam5KQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTBycUg2M81Qr9SNXiu3TnazguKeUN2/bXc/7
	ByY/EVPRbv0q7m2z7tBEvkMOvxdPS/OWs/5hkXqn6W/h41Z9WbmH7SFK9tM4XnLd5fm0yX1d
	+q+CvRwyRl0Z03+X3eWYyHv802aeFV6r1PJqCp0O9S0IrxOvezvnoMPbVccO118Pui5349Xt
	KTWa/5WUlFiKMxINtZiLihMBQNEieckCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd3G6MUBBh3PuSwu75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzPs3ZxVZwbhdz
	xbQ+9QbGpU+Zuhg5OSQETCSWnPnMDmGLSVy4t54NxBYSWMQo8fiqZhcjF5D9j1FiQWMjWBGb
	gJbE6rnHGUESIgK9jBIX+r8ygTjMAg8YJVYcfgg2VljAR2Lf2oNgo1gEVCWmNf9mBLF5BWwl
	tre/Z4WwBSV+TL7HAmIzA01dv/M4E4QtL7F5zVvmLkYOoJPUJR791QUJiwjoSSyfuYQRokRE
	Yt+Ld4wTGAVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFw+
	k97BuKrB4hCjAAejEg9vQP+iACHWxLLiytxDjBIczEoivLFWiwOEeFMSK6tSi/Lji0pzUosP
	MfoAPTqRWUo0OR+YMvJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi
	4JRqYFTZYLnG4WxAjIr4b+4/dpvuN775I5XKWJoacei+/H3xxNPnPC69fJUv2qDn99o3MTFC
	PKRg8zauu8xTn7XmrC/7p2poNdG68IKvmcDjuZmdft8cNVWy+cQb/lxwO171eOf3k98viF6Q
	/fk/p8Ur8ssDjmsuRuaVq41PqBT7vFRxXOCjll7jqsRSnJFoqMVcVJwIAAPkV234AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit enhances power management of System MMU and its client
devices with the following changes:
 - Each System MMU device becomes the parent device of its client
   device while probe(). Thus, exynos-iommu driver must be initialized
   before client devices.
 - System MMU driver does not pm_runtime_get/put() by itself and runtime
   power gating is performed by client devices.
 - System is safe when suspend/resume without any care by client device
   drivers.

In addition, System MMUs can be seperate into several groups that are
belongs to a single client device like FIMC-IS block. If such blocks are
controlled by a single device descriptor, all System MMUs in the blocks
must be enabled/disabled by a single device descriptor. The problem is
that clock gating and power gating may be not the same among all System
MMUs in the blocks. Thus, System MMUs are grouped by clock gating and
power gating and they are chained by parent-child relationships.

exynos-iommu driver now also supports debugfs to identify the state of
each System MMU.

The last big change is to support DT. The desription of the properties
of DT nodes are described in the source file.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/Kconfig        |   17 +-
 drivers/iommu/exynos-iommu.c | 1420 +++++++++++++++++++++++++++++++-----------
 2 files changed, 1077 insertions(+), 360 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..548fdf0 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -168,7 +168,7 @@ config TEGRA_IOMMU_SMMU
 
 config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
-	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
+	depends on ARCH_EXYNOS
 	select IOMMU_API
 	help
 	  Support for the IOMMU(System MMU) of Samsung Exynos application
@@ -178,6 +178,21 @@ config EXYNOS_IOMMU
 
 	  If unsure, say N here.
 
+config EXYNOS_IOMMU_TLBINV_BY_ENTRY
+	bool "TLB invalidation in iommu_unmap() call"
+	depends on EXYNOS_IOMMU
+	default y
+	help
+	  TLB must be invalidated whenever a mapping information is removed from
+	  the page table and iommu_ops.unmap() is the proper place to invoke
+	  TLB invalidation. Since iommu_ops.unmap() is called per a page
+	  table entry, TLB invalidation can be invoked hundreds of times for
+	  unmapping just one IO region that consists of hundreds of pages.
+	  It is rather efficient not to invalidate TLB by entry but invalidate
+	  the entire TLB.
+	  Say n if your IO region mapper calls exynos_sysmmu_tlb_invalidate()
+	  directly not to perform TLB invalidation by entry.
+
 config EXYNOS_IOMMU_DEBUG
 	bool "Debugging log for Exynos IOMMU"
 	depends on EXYNOS_IOMMU
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7fe44f8..acf6486 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1,6 +1,6 @@
 /* linux/drivers/iommu/exynos_iommu.c
  *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * This program is free software; you can redistribute it and/or modify
@@ -12,24 +12,29 @@
 #define DEBUG
 #endif
 
+#include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
-#include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/mm.h>
-#include <linux/iommu.h>
 #include <linux/errno.h>
-#include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/iommu.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 #include <asm/cacheflush.h>
-#include <asm/pgtable.h>
 
-#include <mach/sysmmu.h>
+#define MODULE_NAME "exynos-sysmmu"
 
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
@@ -80,6 +85,13 @@
 #define CTRL_BLOCK	0x7
 #define CTRL_DISABLE	0x0
 
+#define CFG_LRU		0x1
+#define CFG_QOS(n)	((n & 0xF) << 7)
+#define CFG_MASK	0x0050FFFF /* Selecting bit 0-15, 20, 22 */
+#define CFG_SYSSEL	(1 << 22) /* System MMU 3.2 only */
+#define CFG_FLPDCACHE	(1 << 20) /* System MMU 3.2+ only */
+#define CFG_SHAREABLE	(1 << 12) /* System MMU 3.x only */
+
 #define REG_MMU_CTRL		0x000
 #define REG_MMU_CFG		0x004
 #define REG_MMU_STATUS		0x008
@@ -96,10 +108,31 @@
 
 #define REG_MMU_VERSION		0x034
 
-#define REG_PB0_SADDR		0x04C
-#define REG_PB0_EADDR		0x050
-#define REG_PB1_SADDR		0x054
-#define REG_PB1_EADDR		0x058
+#define MMU_MAJ_VER(reg)	(reg >> 28)
+#define MMU_MIN_VER(reg)	((reg >> 21) & 0x7F)
+
+#define MAX_NUM_PBUF		3
+
+#define NUM_MINOR_OF_SYSMMU_V3	4
+
+static void *sysmmu_placeholder; /* Inidcate if a device is System MMU */
+
+#define is_sysmmu(sysmmu) (sysmmu->archdata.iommu == &sysmmu_placeholder)
+#define has_sysmmu(dev)							\
+	(dev->parent && dev->archdata.iommu && is_sysmmu(dev->parent))
+#define for_each_sysmmu(dev, sysmmu)					\
+	for (sysmmu = dev->parent; sysmmu && is_sysmmu(sysmmu);		\
+			sysmmu = sysmmu->parent)
+#define for_each_sysmmu_until(dev, sysmmu, until)			\
+	for (sysmmu = dev->parent; sysmmu != until; sysmmu = sysmmu->parent)
+
+/* Offset of prefetch buffer setting registers are different
+ * between SysMMU 3.1 and 3.2
+ */
+static unsigned short
+	pbuf_offset[NUM_MINOR_OF_SYSMMU_V3] = {0x04C, 0x04C, 0x070, 0x000};
+
+static struct kmem_cache *lv2table_kmem_cache;
 
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
 {
@@ -124,16 +157,6 @@ enum exynos_sysmmu_inttype {
 	SYSMMU_FAULTS_NUM
 };
 
-/*
- * @itype: type of fault.
- * @pgtable_base: the physical address of page table base. This is 0 if @itype
- *                is SYSMMU_BUSERROR.
- * @fault_addr: the device (virtual) address that the System MMU tried to
- *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
- */
-typedef int (*sysmmu_fault_handler_t)(enum exynos_sysmmu_inttype itype,
-			unsigned long pgtable_base, unsigned long fault_addr);
-
 static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
 	REG_PAGE_FAULT_ADDR,
 	REG_AR_FAULT_ADDR,
@@ -157,27 +180,64 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
 	"UNKNOWN FAULT"
 };
 
-struct exynos_iommu_domain {
-	struct list_head clients; /* list of sysmmu_drvdata.node */
-	unsigned long *pgtable; /* lv1 page table, 16KB */
-	short *lv2entcnt; /* free lv2 entry counter for each section */
-	spinlock_t lock; /* lock for this structure */
-	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
+/*
+ * @itype: type of fault.
+ * @pgtable_base: the physical address of page table base. This is 0 if @itype
+ *                is SYSMMU_BUSERROR.
+ * @fault_addr: the device (virtual) address that the System MMU tried to
+ *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
+ */
+typedef int (*sysmmu_fault_handler_t)(struct device *dev,
+				      const char *mmuname,
+				      enum exynos_sysmmu_inttype itype,
+				      unsigned long pgtable_base,
+				      unsigned long fault_addr);
+/* exynos_iommu_owner
+ * Metadata attached to the owner of a group of System MMUs that belong
+ * to the same owner device.
+ */
+struct exynos_iommu_owner {
+	struct list_head client; /* entry of exynos_iommu_domain.clients */
+	struct device *dev;
+	spinlock_t lock;	/* Lock to preserve consistency of System MMU */
+};
+
+struct sysmmu_version {
+	unsigned char major; /* major = 0 means that driver must use MMU_VERSION
+				register instead of this structure */
+	unsigned char minor;
+};
+
+struct sysmmu_prefbuf {
+	unsigned long base;
+	unsigned long size;
 };
 
 struct sysmmu_drvdata {
-	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
-	struct device *dev;	/* Owner of system MMU */
-	char *dbgname;
+	struct device *master;	/* Client device that needs System MMU */
 	int nsfrs;
-	void __iomem **sfrbases;
-	struct clk *clk[2];
+	struct clk *clk;
 	int activations;
-	rwlock_t lock;
-	struct iommu_domain *domain;
+	struct iommu_domain *domain; /* domain given to iommu_attach_device() */
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
+	struct sysmmu_version ver; /* mach/sysmmu.h */
+	spinlock_t lock;
+	struct sysmmu_prefbuf pbufs[MAX_NUM_PBUF];
+	int num_pbufs;
+	struct dentry *debugfs_root;
+	bool runtime_active;
+	const char **mmuname;
+	void __iomem *sfrbases[0];
+};
+
+struct exynos_iommu_domain {
+	struct list_head clients; /* list of sysmmu_drvdata.node */
+	unsigned long *pgtable; /* lv1 page table, 16KB */
+	short *lv2entcnt; /* free lv2 entry counter for each section */
+	spinlock_t lock; /* lock for this structure */
+	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
@@ -199,6 +259,25 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
 	return data->activations > 0;
 }
 
+static unsigned int __sysmmu_version(struct sysmmu_drvdata *drvdata,
+					int idx, unsigned int *minor)
+{
+	unsigned int major;
+
+	if (drvdata->ver.major == 0) {
+		major = readl(
+			drvdata->sfrbases[idx] + REG_MMU_VERSION);
+		if (minor)
+			*minor = MMU_MIN_VER(major);
+		major = MMU_MAJ_VER(major);
+	} else {
+		major = drvdata->ver.major;
+		if (minor)
+			*minor = drvdata->ver.minor;
+	}
+	return major;
+}
+
 static void sysmmu_unblock(void __iomem *sfrbase)
 {
 	__raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
@@ -225,12 +304,6 @@ static void __sysmmu_tlb_invalidate(void __iomem *sfrbase)
 	__raw_writel(0x1, sfrbase + REG_MMU_FLUSH);
 }
 
-static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
-						unsigned long iova)
-{
-	__raw_writel((iova & SPAGE_MASK) | 1, sfrbase + REG_MMU_FLUSH_ENTRY);
-}
-
 static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 				       unsigned long pgd)
 {
@@ -240,85 +313,239 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 	__sysmmu_tlb_invalidate(sfrbase);
 }
 
-static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
-						unsigned long size, int idx)
+static void __sysmmu_set_prefbuf(void __iomem *pbufbase, unsigned long base,
+					unsigned long size, int idx)
 {
-	__raw_writel(base, sfrbase + REG_PB0_SADDR + idx * 8);
-	__raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
+	__raw_writel(base, pbufbase + idx * 8);
+	__raw_writel(size - 1 + base,  pbufbase + 4 + idx * 8);
 }
 
-void exynos_sysmmu_set_prefbuf(struct device *dev,
-				unsigned long base0, unsigned long size0,
-				unsigned long base1, unsigned long size1)
+static void __exynos_sysmmu_set_pbuf_ver31(struct sysmmu_drvdata *drvdata,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-	unsigned long flags;
-	int i;
+	unsigned long cfg =
+		__raw_readl(drvdata->sfrbases[idx] + REG_MMU_CFG) & CFG_MASK;
+
+	if (nbufs > 1) {
+		unsigned long base = prefbuf[1].base;
+		unsigned long end = prefbuf[1].base + prefbuf[1].size;
+
+		/* merging buffers from the second to the last */
+		while (nbufs-- > 2) {
+			base = min(base, prefbuf[nbufs - 1].base);
+			end = max(end, prefbuf[nbufs - 1].base +
+					prefbuf[nbufs - 1].size);
+		}
 
-	BUG_ON((base0 + size0) <= base0);
-	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
+		/* Separate PB mode */
+		cfg |= 2 << 28;
 
-	read_lock_irqsave(&data->lock, flags);
-	if (!is_sysmmu_active(data))
-		goto finish;
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[1],
+					base, end - base, 1);
 
-	for (i = 0; i < data->nsfrs; i++) {
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			if (!sysmmu_block(data->sfrbases[i]))
-				continue;
-
-			if (size1 == 0) {
-				if (size0 <= SZ_128K) {
-					base1 = base0;
-					size1 = size0;
-				} else {
-					size1 = size0 -
-						ALIGN(size0 / 2, SZ_64K);
-					size0 = size0 - size1;
-					base1 = base0 + size0;
-				}
+		drvdata->num_pbufs = 2;
+		drvdata->pbufs[0] = prefbuf[0];
+		drvdata->pbufs[1] = prefbuf[1];
+
+	} else {
+		/* Combined PB mode */
+		cfg |= 3 << 28;
+		drvdata->num_pbufs = 1;
+		drvdata->pbufs[0] = prefbuf[0];
+	}
+
+	__raw_writel(cfg, drvdata->sfrbases[idx] + REG_MMU_CFG);
+
+	__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[1],
+				prefbuf[0].base, prefbuf[0].size, 0);
+}
+
+static void __exynos_sysmmu_set_pbuf_ver32(struct sysmmu_drvdata *drvdata,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
+{
+	unsigned long cfg =
+		__raw_readl(drvdata->sfrbases[idx] + REG_MMU_CFG) & CFG_MASK;
+
+	cfg |= 7 << 16; /* enabling PB0 ~ PB2 */
+
+	switch (nbufs) {
+	case 1:
+	{
+		/* Combined PB mode (0 ~ 2) */
+		cfg |= 1 << 19;
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+				prefbuf[0].base, prefbuf[0].size, 0);
+		drvdata->num_pbufs = 1;
+		drvdata->pbufs[0] = prefbuf[0];
+		break;
+	}
+	case 2:
+	{
+		/* Combined PB mode (0 ~ 1) */
+		cfg |= 1 << 21;
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+				prefbuf[0].base, prefbuf[0].size, 0);
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+				prefbuf[1].base, prefbuf[1].size, 2);
+		drvdata->num_pbufs = 2;
+		drvdata->pbufs[0] = prefbuf[0];
+		drvdata->pbufs[1] = prefbuf[1];
+		break;
+	}
+	case 3:
+	{
+		/* Finding largest buffer and set it to prefbuf 2 */
+		int i, j, k = 0;
+		for (j = 1; j < 3; j++)
+			if (prefbuf[j].size > prefbuf[0].size)
+				k = j;
+		/* Set to k-th buf to prefbuf 2 */
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+					prefbuf[k].base, prefbuf[k].size, 2);
+
+		/* Set other buffers to prefbuf 0 and 1 */
+		for (i = 0, j = 0; i < 3; i++) {
+			if (i != k) {
+				/*set i-th buffer to j-th prefbuf */
+				__sysmmu_set_prefbuf(
+					drvdata->sfrbases[idx] + pbuf_offset[2],
+					prefbuf[i].base, prefbuf[i].size,
+					j++);
 			}
+		}
+		drvdata->num_pbufs = 3;
+		drvdata->pbufs[0] = prefbuf[0];
+		drvdata->pbufs[1] = prefbuf[1];
+		drvdata->pbufs[2] = prefbuf[2];
+		break;
+	}
+	default:
+	{
+		unsigned long base = prefbuf[2].base;
+		unsigned long end = prefbuf[2].base + prefbuf[2].size;
+
+		/* Merging all buffers from the third to the last */
+		while (nbufs-- > 3) {
+			base = min(base, prefbuf[nbufs - 1].base);
+			end = max(end, prefbuf[nbufs - 1].base +
+					prefbuf[nbufs - 1].size);
+		}
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+					prefbuf[0].base, prefbuf[0].size, 0);
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+					prefbuf[1].base, prefbuf[1].size, 1);
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+					base, end - base, 2);
+		drvdata->num_pbufs = 3;
+		drvdata->pbufs[0] = prefbuf[0];
+		drvdata->pbufs[1] = prefbuf[1];
+		drvdata->pbufs[2] = prefbuf[2];
+	}
+	} /* switch (nbufs) */
+
+	__raw_writel(cfg, drvdata->sfrbases[idx] + REG_MMU_CFG);
+}
+
+static void __exynos_sysmmu_set_pbuf_ver33(struct sysmmu_drvdata *drvdata,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
+{
+	WARN(1, "System MMU ver. 3.3 is not available now\n");
+}
+
+static void (*func_set_pbuf[NUM_MINOR_OF_SYSMMU_V3])
+	(struct sysmmu_drvdata *, int, int, struct sysmmu_prefbuf []) = {
+		__exynos_sysmmu_set_pbuf_ver31,
+		__exynos_sysmmu_set_pbuf_ver31,
+		__exynos_sysmmu_set_pbuf_ver32,
+		__exynos_sysmmu_set_pbuf_ver33,
+};
+
+void exynos_sysmmu_set_pbuf(struct device *dev, int nbufs,
+				struct sysmmu_prefbuf prefbuf[])
+{
+	struct device *sysmmu;
+	int nsfrs;
+
+	if (WARN_ON(nbufs < 1))
+		return;
+
+	for_each_sysmmu(dev, sysmmu) {
+		unsigned long flags;
+		struct sysmmu_drvdata *drvdata;
 
-			__sysmmu_set_prefbuf(
-					data->sfrbases[i], base0, size0, 0);
-			__sysmmu_set_prefbuf(
-					data->sfrbases[i], base1, size1, 1);
+		drvdata = dev_get_drvdata(sysmmu);
 
-			sysmmu_unblock(data->sfrbases[i]);
+		spin_lock_irqsave(&drvdata->lock, flags);
+		if (!is_sysmmu_active(drvdata)) {
+			spin_unlock_irqrestore(&drvdata->lock, flags);
+			continue;
+		}
+
+		for (nsfrs = 0; nsfrs < drvdata->nsfrs; nsfrs++) {
+			unsigned int maj, min;
+
+			maj = __sysmmu_version(drvdata, nsfrs, &min);
+
+			BUG_ON(min > 3);
+
+			if (sysmmu_block(drvdata->sfrbases[nsfrs])) {
+				func_set_pbuf[min](drvdata, nsfrs,
+							nbufs, prefbuf);
+				sysmmu_unblock(drvdata->sfrbases[nsfrs]);
+			}
+		} /* while (nsfrs < drvdata->nsfrs) */
+		spin_unlock_irqrestore(&drvdata->lock, flags);
+	}
+}
+
+static void __sysmmu_restore_state(struct sysmmu_drvdata *drvdata)
+{
+	int i, min;
+
+	for (i = 0; i < drvdata->nsfrs; i++) {
+		if (__sysmmu_version(drvdata, i, &min) == 3) {
+			if (sysmmu_block(drvdata->sfrbases[i])) {
+				func_set_pbuf[min](drvdata, i,
+					drvdata->num_pbufs, drvdata->pbufs);
+				sysmmu_unblock(drvdata->sfrbases[i]);
+			}
 		}
 	}
-finish:
-	read_unlock_irqrestore(&data->lock, flags);
 }
 
 static void __set_fault_handler(struct sysmmu_drvdata *data,
 					sysmmu_fault_handler_t handler)
 {
-	unsigned long flags;
-
-	write_lock_irqsave(&data->lock, flags);
 	data->fault_handler = handler;
-	write_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_set_fault_handler(struct device *dev,
 					sysmmu_fault_handler_t handler)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct device *sysmmu;
+	unsigned long flags;
+
+	spin_lock_irqsave(&owner->lock, flags);
 
-	__set_fault_handler(data, handler);
+	for_each_sysmmu(dev, sysmmu)
+		__set_fault_handler(dev_get_drvdata(sysmmu), handler);
+
+	spin_unlock_irqrestore(&owner->lock, flags);
 }
 
-static int default_fault_handler(enum exynos_sysmmu_inttype itype,
-		     unsigned long pgtable_base, unsigned long fault_addr)
+static int default_fault_handler(struct device *dev, const char *mmuname,
+					enum exynos_sysmmu_inttype itype,
+					unsigned long pgtable_base,
+					unsigned long fault_addr)
 {
 	unsigned long *ent;
 
 	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
 		itype = SYSMMU_FAULT_UNKNOWN;
 
-	pr_err("%s occurred at 0x%lx(Page table base: 0x%lx)\n",
-			sysmmu_fault_name[itype], fault_addr, pgtable_base);
+	pr_err("%s occured at 0x%lx by '%s'(Page table base: 0x%lx)\n",
+		sysmmu_fault_name[itype], fault_addr, mmuname, pgtable_base);
 
 	ent = section_entry(__va(pgtable_base), fault_addr);
 	pr_err("\tLv1 entry: 0x%lx\n", *ent);
@@ -338,366 +565,642 @@ static int default_fault_handler(enum exynos_sysmmu_inttype itype,
 static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 {
 	/* SYSMMU is in blocked when interrupt occurred. */
-	struct sysmmu_drvdata *data = dev_id;
-	struct resource *irqres;
-	struct platform_device *pdev;
+	struct sysmmu_drvdata *drvdata = dev_id;
+	struct exynos_iommu_owner *owner = NULL;
 	enum exynos_sysmmu_inttype itype;
 	unsigned long addr = -1;
-
+	const char *mmuname = NULL;
 	int i, ret = -ENOSYS;
 
-	read_lock(&data->lock);
+	if (drvdata->master)
+		owner = drvdata->master->archdata.iommu;
+
+	if (owner)
+		spin_lock(&owner->lock);
 
-	WARN_ON(!is_sysmmu_active(data));
+	WARN_ON(!is_sysmmu_active(drvdata));
 
-	pdev = to_platform_device(data->sysmmu);
-	for (i = 0; i < (pdev->num_resources / 2); i++) {
-		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+	for (i = 0; i < drvdata->nsfrs; i++) {
+		struct resource *irqres;
+		irqres = platform_get_resource(
+				to_platform_device(drvdata->sysmmu),
+				IORESOURCE_IRQ, i);
 		if (irqres && ((int)irqres->start == irq))
 			break;
 	}
 
-	if (i == pdev->num_resources) {
+	if (i == drvdata->nsfrs) {
 		itype = SYSMMU_FAULT_UNKNOWN;
 	} else {
 		itype = (enum exynos_sysmmu_inttype)
-			__ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
+			__ffs(__raw_readl(
+					drvdata->sfrbases[i] + REG_INT_STATUS));
 		if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
 			itype = SYSMMU_FAULT_UNKNOWN;
 		else
 			addr = __raw_readl(
-				data->sfrbases[i] + fault_reg_offset[itype]);
+				drvdata->sfrbases[i] + fault_reg_offset[itype]);
 	}
 
-	if (data->domain)
-		ret = report_iommu_fault(data->domain, data->dev,
-				addr, itype);
+	if (drvdata->domain) /* owner is always set if drvdata->domain exists */
+		ret = report_iommu_fault(drvdata->domain,
+					owner->dev, addr, itype);
+
+	if ((ret == -ENOSYS) && drvdata->fault_handler) {
+		unsigned long base = drvdata->pgtable;
+		mmuname = (drvdata->mmuname) ?  drvdata->mmuname[i]
+						: dev_name(drvdata->sysmmu);
 
-	if ((ret == -ENOSYS) && data->fault_handler) {
-		unsigned long base = data->pgtable;
 		if (itype != SYSMMU_FAULT_UNKNOWN)
 			base = __raw_readl(
-					data->sfrbases[i] + REG_PT_BASE_ADDR);
-		ret = data->fault_handler(itype, base, addr);
+				drvdata->sfrbases[i] + REG_PT_BASE_ADDR);
+		ret = drvdata->fault_handler(
+					owner ? owner->dev : drvdata->sysmmu,
+					mmuname, itype, base, addr);
 	}
 
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
-		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
+		__raw_writel(1 << itype, drvdata->sfrbases[i] + REG_INT_CLEAR);
 	else
-		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
-				data->dbgname, sysmmu_fault_name[itype]);
+		dev_dbg(owner ? owner->dev : drvdata->sysmmu,
+				"%s is not handled by %s\n",
+				sysmmu_fault_name[itype],
+				dev_name(drvdata->sysmmu));
 
-	if (itype != SYSMMU_FAULT_UNKNOWN)
-		sysmmu_unblock(data->sfrbases[i]);
+	sysmmu_unblock(drvdata->sfrbases[i]);
 
-	read_unlock(&data->lock);
+	if (owner)
+		spin_unlock(&owner->lock);
 
 	return IRQ_HANDLED;
 }
 
-static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
+static void __sysmmu_disable_nocount(struct sysmmu_drvdata *drvdata)
 {
-	unsigned long flags;
-	bool disabled = false;
 	int i;
 
-	write_lock_irqsave(&data->lock, flags);
+	for (i = 0; i < drvdata->nsfrs; i++)
+		__raw_writel(CTRL_DISABLE,
+			drvdata->sfrbases[i] + REG_MMU_CTRL);
+
+	clk_disable(drvdata->clk);
+}
+
+static bool __sysmmu_disable(struct sysmmu_drvdata *drvdata)
+{
+	bool disabled;
+	unsigned long flags;
 
-	if (!set_sysmmu_inactive(data))
-		goto finish;
+	spin_lock_irqsave(&drvdata->lock, flags);
 
-	for (i = 0; i < data->nsfrs; i++)
-		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
+	disabled = set_sysmmu_inactive(drvdata);
 
-	if (data->clk[1])
-		clk_disable(data->clk[1]);
-	if (data->clk[0])
-		clk_disable(data->clk[0]);
+	if (disabled) {
+		drvdata->pgtable = 0;
+		drvdata->domain = NULL;
 
-	disabled = true;
-	data->pgtable = 0;
-	data->domain = NULL;
-finish:
-	write_unlock_irqrestore(&data->lock, flags);
+		if (drvdata->runtime_active)
+			__sysmmu_disable_nocount(drvdata);
 
-	if (disabled)
-		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
-	else
-		dev_dbg(data->sysmmu, "(%s) %d times left to be disabled\n",
-					data->dbgname, data->activations);
+		dev_dbg(drvdata->sysmmu, "Disabled\n");
+	} else  {
+		dev_dbg(drvdata->sysmmu, "%d times left to be disabled\n",
+						drvdata->activations);
+	}
+
+	spin_unlock_irqrestore(&drvdata->lock, flags);
 
 	return disabled;
 }
 
+static void __sysmmu_init_prefbuf(struct sysmmu_drvdata *drvdata, int idx,
+							int maj, int min)
+{
+	if (maj == 3) {
+		struct sysmmu_prefbuf pbuf[1] = { {0, ~0} };
+
+		func_set_pbuf[min](drvdata, idx, 1, pbuf);
+	}
+}
+
+static void __sysmmu_enable_nocount(struct sysmmu_drvdata *drvdata)
+{
+	int i;
+
+	clk_enable(drvdata->clk);
+
+	for (i = 0; i < drvdata->nsfrs; i++) {
+		int maj, min;
+		unsigned long cfg = CFG_LRU | CFG_QOS(15);
+
+		__sysmmu_set_ptbase(drvdata->sfrbases[i], drvdata->pgtable);
+
+		/* Initialization of REG_MMU_CFG must be prior to
+		   call to __sysmmu_init_prefbuf() */
+		maj = __sysmmu_version(drvdata, i, &min);
+		if (maj == 3) {
+			cfg |= CFG_SHAREABLE;
+			if (min == 2)
+				cfg |= CFG_FLPDCACHE | CFG_SYSSEL;
+		}
+		__raw_writel(cfg, drvdata->sfrbases[i] + REG_MMU_CFG);
+
+		__sysmmu_init_prefbuf(drvdata, i, maj, min);
+
+		__raw_writel(CTRL_ENABLE, drvdata->sfrbases[i] + REG_MMU_CTRL);
+	}
+}
+
+static int __sysmmu_enable(struct sysmmu_drvdata *drvdata,
+			unsigned long pgtable, struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&drvdata->lock, flags);
+	if (set_sysmmu_active(drvdata)) {
+		drvdata->pgtable = pgtable;
+		drvdata->domain = domain;
+
+		if (drvdata->runtime_active)
+			__sysmmu_enable_nocount(drvdata);
+
+		dev_dbg(drvdata->sysmmu, "Enabled\n");
+	} else {
+		ret = (pgtable == drvdata->pgtable) ? 1 : -EBUSY;
+
+		dev_dbg(drvdata->sysmmu, "Already enabled\n");
+	}
+
+	if (WARN_ON(ret < 0))
+		set_sysmmu_inactive(drvdata); /* decrement count */
+
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+
+	return ret;
+}
+
 /* __exynos_sysmmu_enable: Enables System MMU
  *
  * returns -error if an error occurred and System MMU is not enabled,
  * 0 if the System MMU has been just enabled and 1 if System MMU was already
  * enabled before.
  */
-static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
-			unsigned long pgtable, struct iommu_domain *domain)
+static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
+				struct iommu_domain *domain)
 {
-	int i, ret = 0;
+	int ret = 0;
 	unsigned long flags;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct device *sysmmu;
 
-	write_lock_irqsave(&data->lock, flags);
-
-	if (!set_sysmmu_active(data)) {
-		if (WARN_ON(pgtable != data->pgtable)) {
-			ret = -EBUSY;
-			set_sysmmu_inactive(data);
-		} else {
-			ret = 1;
-		}
-
-		dev_dbg(data->sysmmu, "(%s) Already enabled\n", data->dbgname);
-		goto finish;
-	}
-
-	if (data->clk[0])
-		clk_enable(data->clk[0]);
-	if (data->clk[1])
-		clk_enable(data->clk[1]);
+	BUG_ON(!has_sysmmu(dev));
 
-	data->pgtable = pgtable;
+	spin_lock_irqsave(&owner->lock, flags);
 
-	for (i = 0; i < data->nsfrs; i++) {
-		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
-
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
-			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
-					data->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
+	for_each_sysmmu(dev, sysmmu) {
+		struct sysmmu_drvdata *drvdata = dev_get_drvdata(sysmmu);
+		ret = __sysmmu_enable(drvdata, pgtable, domain);
+		if (ret < 0) {
+			struct device *iter;
+			for_each_sysmmu_until(dev, iter, sysmmu) {
+				drvdata = dev_get_drvdata(iter);
+				__sysmmu_disable(drvdata);
+			}
+		} else {
+			drvdata->master = dev;
 		}
-
-		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
 	}
 
-	data->domain = domain;
-
-	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
-finish:
-	write_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&owner->lock, flags);
 
 	return ret;
 }
 
 int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	int ret;
 
 	BUG_ON(!memblock_is_memory(pgtable));
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0) {
-		dev_dbg(data->sysmmu, "(%s) Failed to enable\n", data->dbgname);
-		return ret;
-	}
-
-	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
-	if (WARN_ON(ret < 0)) {
-		pm_runtime_put(data->sysmmu);
-		dev_err(data->sysmmu,
-			"(%s) Already enabled with page table %#lx\n",
-			data->dbgname, data->pgtable);
-	} else {
-		data->dev = dev;
-	}
+	ret = __exynos_sysmmu_enable(dev, pgtable, NULL);
 
 	return ret;
 }
 
 bool exynos_sysmmu_disable(struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-	bool disabled;
+	unsigned long flags;
+	bool disabled = true;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct device *sysmmu;
+
+	BUG_ON(!has_sysmmu(dev));
 
-	disabled = __exynos_sysmmu_disable(data);
-	pm_runtime_put(data->sysmmu);
+	spin_lock_irqsave(&owner->lock, flags);
+
+	/* Every call to __sysmmu_disable() must return same result */
+	for_each_sysmmu(dev, sysmmu) {
+		struct sysmmu_drvdata *drvdata = dev_get_drvdata(sysmmu);
+		disabled = __sysmmu_disable(drvdata);
+		if (disabled)
+			drvdata->master = NULL;
+	}
+
+	spin_unlock_irqrestore(&owner->lock, flags);
 
 	return disabled;
 }
 
-static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
+void exynos_sysmmu_tlb_invalidate(struct device *dev)
 {
-	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-
-	read_lock_irqsave(&data->lock, flags);
-
-	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate_entry(
-						data->sfrbases[i], iova);
-				sysmmu_unblock(data->sfrbases[i]);
+	struct device *sysmmu;
+
+	for_each_sysmmu(dev, sysmmu) {
+		unsigned long flags;
+		struct sysmmu_drvdata *drvdata;
+
+		drvdata = dev_get_drvdata(sysmmu);
+
+		spin_lock_irqsave(&drvdata->lock, flags);
+		if (is_sysmmu_active(drvdata) &&
+				drvdata->runtime_active) {
+			int i;
+			for (i = 0; i < drvdata->nsfrs; i++) {
+				if (sysmmu_block(drvdata->sfrbases[i])) {
+					__sysmmu_tlb_invalidate(
+							drvdata->sfrbases[i]);
+					sysmmu_unblock(drvdata->sfrbases[i]);
+				}
 			}
+		} else {
+			dev_dbg(dev, "Disabled. Skipping TLB invalidation\n");
 		}
-	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+		spin_unlock_irqrestore(&drvdata->lock, flags);
 	}
+}
 
-	read_unlock_irqrestore(&data->lock, flags);
+#ifdef CONFIG_EXYNOS_IOMMU_TLBINV_BY_ENTRY
+static void _sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
+{
+	struct device *sysmmu;
+
+	for_each_sysmmu(dev, sysmmu) {
+		unsigned long flags;
+		struct sysmmu_drvdata *drvdata;
+
+		drvdata = dev_get_drvdata(sysmmu);
+
+		spin_lock_irqsave(&drvdata->lock, flags);
+		if (is_sysmmu_active(drvdata) &&
+				drvdata->runtime_active) {
+			int i;
+			for (i = 0; i < drvdata->nsfrs; i++) {
+				if (sysmmu_block(drvdata->sfrbases[i])) {
+					__raw_writel((iova & SPAGE_MASK) | 1,
+							drvdata->sfrbases[i] +
+							REG_MMU_FLUSH_ENTRY);
+					sysmmu_unblock(drvdata->sfrbases[i]);
+				} else {
+					dev_err(dev,
+					"%s failed due to blocking timeout\n",
+					__func__);
+				}
+			}
+		} else {
+			dev_dbg(dev,
+			"Disabled. Skipping TLB invalidation for %#lx\n", iova);
+		}
+		spin_unlock_irqrestore(&drvdata->lock, flags);
+	}
 }
+#endif
 
-void exynos_sysmmu_tlb_invalidate(struct device *dev)
+static int __init __sysmmu_init_clock(struct device *sysmmu,
+					struct sysmmu_drvdata *drvdata,
+					struct device *master)
 {
-	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	char *conid;
+	struct clk *parent_clk;
+	int ret;
+
+	drvdata->clk = clk_get(sysmmu, "sysmmu");
+	if (IS_ERR(drvdata->clk)) {
+		dev_dbg(sysmmu, "No gating clock found.\n");
+		drvdata->clk = NULL;
+		return 0;
+	}
 
-	read_lock_irqsave(&data->lock, flags);
+	if (!master)
+		return 0;
 
-	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate(data->sfrbases[i]);
-				sysmmu_unblock(data->sfrbases[i]);
-			}
+	conid = dev_get_platdata(sysmmu);
+	if (!conid) {
+		dev_dbg(sysmmu, "No parent clock specified.\n");
+		return 0;
+	}
+
+	parent_clk = clk_get(master, conid);
+	if (IS_ERR(parent_clk)) {
+		parent_clk = clk_get(NULL, conid);
+		if (IS_ERR(parent_clk)) {
+			clk_put(drvdata->clk);
+			dev_err(sysmmu, "No parent clock '%s,%s' found\n",
+				dev_name(master), conid);
+			return PTR_ERR(parent_clk);
 		}
-	} else {
-		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
 	}
 
-	read_unlock_irqrestore(&data->lock, flags);
+	ret = clk_set_parent(drvdata->clk, parent_clk);
+	if (ret) {
+		clk_put(drvdata->clk);
+		dev_err(sysmmu, "Failed to set parent clock '%s,%s'\n",
+				dev_name(master), conid);
+	}
+
+	clk_put(parent_clk);
+
+	return ret;
 }
 
-static int exynos_sysmmu_probe(struct platform_device *pdev)
+static int __init __sysmmu_setup(struct device *sysmmu,
+				struct sysmmu_drvdata *drvdata)
 {
-	int i, ret;
-	struct device *dev;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner;
+	struct device_node *master_node;
+	struct device *child;
+	const char *compat;
+	struct platform_device *pmaster = NULL;
+	u32 master_inst_no = -1;
+	u32 ver[2];
+	int ret;
 
-	dev = &pdev->dev;
+	if (!of_property_read_u32_array(sysmmu->of_node, "version", ver, 2)) {
+		drvdata->ver.major = (unsigned char)ver[0];
+		drvdata->ver.minor = (unsigned char)ver[1];
+		dev_dbg(sysmmu, "Found version %d.%d\n", ver[0], ver[1]);
+	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_dbg(dev, "Not enough memory\n");
+	master_node = of_parse_phandle(sysmmu->of_node, "mmu-master", 0);
+	if (!master_node && !of_property_read_string(
+			sysmmu->of_node, "mmu-master-compat", &compat)) {
+		of_property_read_u32_array(sysmmu->of_node,
+					"mmu-master-no", &master_inst_no, 1);
+		for_each_compatible_node(master_node, NULL, compat) {
+			pmaster = of_find_device_by_node(master_node);
+			if (pmaster && (pmaster->id == master_inst_no))
+				break;
+			of_dev_put(pmaster);
+			pmaster = NULL;
+		}
+	} else if (master_node) {
+		pmaster = of_find_device_by_node(master_node);
+	}
+
+	if (!pmaster) {
+		dev_dbg(sysmmu, "No master device is specified.\n");
+		return __sysmmu_init_clock(sysmmu, drvdata, NULL);
+	}
+
+	child = &pmaster->dev;
+
+	while (child->parent && is_sysmmu(child->parent))
+		child = child->parent;
+
+	owner = devm_kzalloc(sysmmu, sizeof(*owner), GFP_KERNEL);
+	if (!owner) {
 		ret = -ENOMEM;
-		goto err_alloc;
+		dev_err(sysmmu, "Failed to allocate iommu data\n");
+		goto err_dev_put;
 	}
 
-	ret = dev_set_drvdata(dev, data);
+	INIT_LIST_HEAD(&owner->client);
+	owner->dev = &pmaster->dev;
+	spin_lock_init(&owner->lock);
+
+	ret = device_move(child, sysmmu, DPM_ORDER_PARENT_BEFORE_DEV);
 	if (ret) {
-		dev_dbg(dev, "Unabled to initialize driver data\n");
-		goto err_init;
+		dev_err(sysmmu, "Failed to set parent of %s\n",
+						dev_name(child));
+		goto err_dev_put;
 	}
 
-	data->nsfrs = pdev->num_resources / 2;
-	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
-								GFP_KERNEL);
-	if (data->sfrbases == NULL) {
-		dev_dbg(dev, "Not enough memory\n");
-		ret = -ENOMEM;
-		goto err_init;
+	pmaster->dev.archdata.iommu = owner;
+
+	ret = __sysmmu_init_clock(sysmmu, drvdata, owner->dev);
+	if (ret)
+		dev_err(sysmmu, "Failed to initialize gating clocks\n");
+	else
+		dev_dbg(sysmmu, "Assigned master device %s\n",
+						dev_name(owner->dev));
+err_dev_put:
+	of_dev_put(pmaster);
+
+	return ret;
+}
+
+static void __init __sysmmu_init_mmuname(struct device *sysmmu,
+					struct sysmmu_drvdata *drvdata)
+{
+	int i;
+
+	if (of_property_count_strings(sysmmu->of_node, "mmuname") !=
+							drvdata->nsfrs)
+		return;
+
+	drvdata->mmuname = (void *)drvdata + sizeof(*drvdata) +
+				sizeof(*drvdata->sfrbases) * drvdata->nsfrs;
+
+	for (i = 0; i < drvdata->nsfrs; i++) {
+		if (of_property_read_string_index(sysmmu->of_node,
+					"mmuname", i, &drvdata->mmuname[i])) {
+			dev_err(sysmmu, "Failed read mmuname[%d]\n", i);
+			drvdata->mmuname[i] = "noname";
+		}
+	}
+}
+
+static void __create_debugfs_entry(struct sysmmu_drvdata *drvdata);
+
+static int __init exynos_sysmmu_probe(struct platform_device *pdev)
+{
+	int i, ret;
+	struct device *dev = &pdev->dev;
+	struct sysmmu_drvdata *data;
+
+	if (pdev->num_resources == 0) {
+		dev_err(dev, "No System MMU resource defined\n");
+		return -ENODEV;
+	}
+
+	ret = of_property_count_strings(pdev->dev.of_node, "mmuname");
+	if (ret != (int)pdev->num_resources)
+		ret = 0;
+
+	data = devm_kzalloc(dev,
+			sizeof(*data)
+			+ sizeof(*data->sfrbases) * (pdev->num_resources / 2)
+			+ sizeof(*data->mmuname) * ret,
+			GFP_KERNEL);
+	if (!data) {
+		dev_err(dev, "Not enough memory\n");
+		return -ENOMEM;
 	}
 
+	data->nsfrs = pdev->num_resources / 2;
+
 	for (i = 0; i < data->nsfrs; i++) {
 		struct resource *res;
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res) {
-			dev_dbg(dev, "Unable to find IOMEM region\n");
-			ret = -ENOENT;
-			goto err_res;
+			dev_err(dev, "Unable to find IOMEM region\n");
+			return -ENOENT;
 		}
 
-		data->sfrbases[i] = ioremap(res->start, resource_size(res));
+		data->sfrbases[i] = devm_request_and_ioremap(dev, res);
 		if (!data->sfrbases[i]) {
-			dev_dbg(dev, "Unable to map IOMEM @ PA:%#x\n",
+			dev_err(dev, "Unable to map IOMEM @ PA:%#x\n",
 							res->start);
-			ret = -ENOENT;
-			goto err_res;
+			return -EBUSY;
 		}
 	}
 
 	for (i = 0; i < data->nsfrs; i++) {
 		ret = platform_get_irq(pdev, i);
 		if (ret <= 0) {
-			dev_dbg(dev, "Unable to find IRQ resource\n");
-			goto err_irq;
+			dev_err(dev, "Unable to find IRQ resource\n");
+			return ret;
 		}
 
-		ret = request_irq(ret, exynos_sysmmu_irq, 0,
+		ret = devm_request_irq(dev, ret, exynos_sysmmu_irq, 0,
 					dev_name(dev), data);
 		if (ret) {
-			dev_dbg(dev, "Unabled to register interrupt handler\n");
-			goto err_irq;
+			dev_err(dev, "Unabled to register interrupt handler\n");
+			return ret;
 		}
 	}
 
-	if (dev_get_platdata(dev)) {
-		char *deli, *beg;
-		struct sysmmu_platform_data *platdata = dev_get_platdata(dev);
+	pm_runtime_enable(dev);
 
-		beg = platdata->clockname;
+	ret = __sysmmu_setup(dev, data);
+	if (!ret) {
+		__sysmmu_init_mmuname(dev, data);
 
-		for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
-			/* NOTHING */;
+		data->runtime_active = !pm_runtime_enabled(dev);
+		data->sysmmu = dev;
+		spin_lock_init(&data->lock);
 
-		if (*deli == '\0')
-			deli = NULL;
-		else
-			*deli = '\0';
+		__set_fault_handler(data, &default_fault_handler);
 
-		data->clk[0] = clk_get(dev, beg);
-		if (IS_ERR(data->clk[0])) {
-			data->clk[0] = NULL;
-			dev_dbg(dev, "No clock descriptor registered\n");
-		}
+		__create_debugfs_entry(data);
 
-		if (data->clk[0] && deli) {
-			*deli = ',';
-			data->clk[1] = clk_get(dev, deli + 1);
-			if (IS_ERR(data->clk[1]))
-				data->clk[1] = NULL;
-		}
+		platform_set_drvdata(pdev, data);
 
-		data->dbgname = platdata->dbgname;
+		dev->archdata.iommu = &sysmmu_placeholder;
+		dev_dbg(dev, "Initialized successfully!\n");
 	}
 
-	data->sysmmu = dev;
-	rwlock_init(&data->lock);
-	INIT_LIST_HEAD(&data->node);
+	return ret;
+}
 
-	__set_fault_handler(data, &default_fault_handler);
+#ifdef CONFIG_PM_SLEEP
+static int sysmmu_suspend(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	if (is_sysmmu_active(drvdata) &&
+		(!pm_runtime_enabled(dev) || drvdata->runtime_active))
+		__sysmmu_disable_nocount(drvdata);
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+	return 0;
+}
 
-	if (dev->parent)
-		pm_runtime_enable(dev);
+static int sysmmu_resume(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	if (is_sysmmu_active(drvdata) &&
+		(!pm_runtime_enabled(dev) || drvdata->runtime_active)) {
+		__sysmmu_enable_nocount(drvdata);
+		__sysmmu_restore_state(drvdata);
+	}
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+	return 0;
+}
+#endif
 
-	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
+#ifdef CONFIG_PM_RUNTIME
+static int sysmmu_runtime_suspend(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	if (is_sysmmu_active(drvdata))
+		__sysmmu_disable_nocount(drvdata);
+	drvdata->runtime_active = false;
+	spin_unlock_irqrestore(&drvdata->lock, flags);
 	return 0;
-err_irq:
-	while (i-- > 0) {
-		int irq;
+}
 
-		irq = platform_get_irq(pdev, i);
-		free_irq(irq, data);
-	}
-err_res:
-	while (data->nsfrs-- > 0)
-		iounmap(data->sfrbases[data->nsfrs]);
-	kfree(data->sfrbases);
-err_init:
-	kfree(data);
-err_alloc:
-	dev_err(dev, "Failed to initialize\n");
-	return ret;
+static int sysmmu_runtime_resume(struct device *dev)
+{
+	struct sysmmu_drvdata *drvdata = dev_get_drvdata(dev);
+	unsigned long flags;
+	spin_lock_irqsave(&drvdata->lock, flags);
+	drvdata->runtime_active = true;
+	if (is_sysmmu_active(drvdata))
+		__sysmmu_enable_nocount(drvdata);
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+	return 0;
 }
+#endif
+
+static const struct dev_pm_ops __pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(sysmmu_suspend, sysmmu_resume)
+	SET_RUNTIME_PM_OPS(sysmmu_runtime_resume, sysmmu_runtime_suspend, NULL)
+};
+
+/*
+ * Descriptions of Device Tree node for System MMU
+ *
+ * A System MMU should be described by a single tree node.
+ *
+ * A System MMU node should have the following properties:
+ * - reg: tuples of the base address and the size of the IO region of System MMU
+ * - compatible: it must be "samsung,exynos-sysmmu".
+ * - interrupt-parent = specify if the interrupt of System MMU is generated by
+ *   interrupt combiner or interrupt controller.
+ * - interrupts: tuples of interrupt numbers. a tuple has 2 elements if
+ *   @interrupt-parent is '<&combiner>', 3 elements otherwise.
+ *
+ * 'mmuname', 'reg' and 'interrupts' properties can be an array if the System
+ * MMU driver controls several number of System MMUs at the same time. Note that
+ * the number of elements in those three properties must be the same.
+ *
+ * The following properties are optional:
+ * - mmuname: name of the System MMU for debugging purpose
+ * - mmu-master: reference to the node of the master device.
+ * - mmu-master-compat: 'compatible' proberty of the node of the master device
+ *    of System MMU. This is ignored if @mmu-master is currectly specified.
+ * - mmu-master-no: instance number of the master device of System MMU. This is
+ *    ignored if @mmu-master is correctly specified. This is '0' by default.
+ */
+#ifdef CONFIG_OF
+static struct of_device_id sysmmu_of_match[] __initconst = {
+	{ .compatible = "samsung,exynos-sysmmu", },
+	{ },
+};
+#endif
 
-static struct platform_driver exynos_sysmmu_driver = {
+static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.probe		= exynos_sysmmu_probe,
 	.driver		= {
 		.owner		= THIS_MODULE,
-		.name		= "exynos-sysmmu",
+		.name		= MODULE_NAME,
+		.pm		= &__pm_ops,
+		.of_match_table = of_match_ptr(sysmmu_of_match),
 	}
 };
 
@@ -732,10 +1235,6 @@ static int exynos_iommu_domain_init(struct iommu_domain *domain)
 	spin_lock_init(&priv->pgtablelock);
 	INIT_LIST_HEAD(&priv->clients);
 
-	domain->geometry.aperture_start = 0;
-	domain->geometry.aperture_end   = ~0UL;
-	domain->geometry.force_aperture = true;
-
 	domain->priv = priv;
 	return 0;
 
@@ -749,7 +1248,7 @@ err_pgtable:
 static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner, *n;
 	unsigned long flags;
 	int i;
 
@@ -757,16 +1256,18 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each_entry(data, &priv->clients, node) {
-		while (!exynos_sysmmu_disable(data->dev))
+	list_for_each_entry_safe(owner, n, &priv->clients, client) {
+		while (!exynos_sysmmu_disable(owner->dev))
 			; /* until System MMU is actually disabled */
+		list_del_init(&owner->client);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	for (i = 0; i < NUM_LV1ENTRIES; i++)
 		if (lv1ent_page(priv->pgtable + i))
-			kfree(__va(lv2table_base(priv->pgtable + i)));
+			kmem_cache_free(lv2table_kmem_cache,
+					__va(lv2table_base(priv->pgtable + i)));
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
@@ -777,41 +1278,54 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 static int exynos_iommu_attach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	struct exynos_iommu_domain *priv = domain->priv;
 	unsigned long flags;
 	int ret;
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0)
-		return ret;
+	if (WARN_ON(!list_empty(&owner->client))) {
+		bool found = false;
+		struct exynos_iommu_owner *tmpowner;
+
+		spin_lock_irqsave(&priv->lock, flags);
+		list_for_each_entry(tmpowner, &priv->clients, client) {
+			if (tmpowner == owner) {
+				found = true;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&priv->lock, flags);
 
-	ret = 0;
+		if (!found) {
+			dev_err(dev, "%s: Already attached to another domain\n",
+								__func__);
+			return -EBUSY;
+		}
+
+		dev_dbg(dev, "%s: Already attached to this domain\n", __func__);
+		return 0;
+	}
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
+	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
 
-	if (ret == 0) {
-		/* 'data->node' must not be appeared in priv->clients */
-		BUG_ON(!list_empty(&data->node));
-		data->dev = dev;
-		list_add_tail(&data->node, &priv->clients);
-	}
+	/*
+	 * __exynos_sysmmu_enable() returns 1
+	 * if the System MMU of dev is already enabled
+	 */
+	BUG_ON(ret > 0);
+
+	list_add_tail(&owner->client, &priv->clients);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-		pm_runtime_put(data->sysmmu);
-	} else if (ret > 0) {
-		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
-					__func__, __pa(priv->pgtable));
-	} else {
+	else
 		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
 					__func__, __pa(priv->pgtable));
-	}
 
 	return ret;
 }
@@ -819,39 +1333,29 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 static void exynos_iommu_detach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner, *n;
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct list_head *pos;
 	unsigned long flags;
-	bool found = false;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each(pos, &priv->clients) {
-		if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
-			found = true;
+	list_for_each_entry_safe(owner, n, &priv->clients, client) {
+		if (owner == dev->archdata.iommu) {
+			if (exynos_sysmmu_disable(dev))
+				list_del_init(&owner->client);
+			else
+				BUG();
 			break;
 		}
 	}
 
-	if (!found)
-		goto finish;
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (__exynos_sysmmu_disable(data)) {
+	if (owner == dev->archdata.iommu)
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
 					__func__, __pa(priv->pgtable));
-		list_del_init(&data->node);
-
-	} else {
-		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
-					__func__, __pa(priv->pgtable));
-	}
-
-finish:
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (found)
-		pm_runtime_put(data->sysmmu);
+	else
+		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
@@ -860,7 +1364,7 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
 	if (lv1ent_fault(sent)) {
 		unsigned long *pent;
 
-		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
+		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
 		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
 		if (!pent)
 			return NULL;
@@ -883,7 +1387,7 @@ static int lv1set_section(unsigned long *sent, phys_addr_t paddr, short *pgcnt)
 		if (*pgcnt != NUM_LV2ENTRIES)
 			return -EADDRINUSE;
 
-		kfree(page_entry(sent, 0));
+		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
 
 		*pgcnt = 0;
 	}
@@ -966,7 +1470,6 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					       unsigned long iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
 
@@ -1017,11 +1520,15 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 done:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
+#ifdef CONFIG_EXYNOS_IOMMU_TLBINV_BY_ENTRY
 	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova);
+	{
+		struct exynos_iommu_owner *owner;
+		list_for_each_entry(owner, &priv->clients, client)
+			_sysmmu_tlb_invalidate_entry(owner->dev, iova);
+	}
 	spin_unlock_irqrestore(&priv->lock, flags);
-
+#endif
 
 	return size;
 }
@@ -1065,15 +1572,210 @@ static struct iommu_ops exynos_iommu_ops = {
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
+static struct dentry *sysmmu_debugfs_root; /* /sys/kernel/debug/sysmmu */
+
 static int __init exynos_iommu_init(void)
 {
 	int ret;
 
-	ret = platform_driver_register(&exynos_sysmmu_driver);
+	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
+		LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
+	if (!lv2table_kmem_cache) {
+		pr_err("%s: failed to create kmem cache\n", __func__);
+		return -ENOMEM;
+	}
+
+	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	if (ret) {
+		kmem_cache_destroy(lv2table_kmem_cache);
+		pr_err("%s: Failed to register IOMMU ops\n", __func__);
+		return -EFAULT;
+	}
+
+	sysmmu_debugfs_root = debugfs_create_dir("sysmmu", NULL);
+	if (!sysmmu_debugfs_root)
+		pr_err("%s: Failed to create debugfs entry, 'sysmmu'\n",
+							__func__);
+	if (IS_ERR(sysmmu_debugfs_root))
+		sysmmu_debugfs_root = NULL;
 
-	if (ret == 0)
-		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	ret = platform_driver_register(&exynos_sysmmu_driver);
+	if (ret) {
+		kmem_cache_destroy(lv2table_kmem_cache);
+		pr_err("%s: Failed to register System MMU driver\n", __func__);
+	}
 
 	return ret;
 }
 subsys_initcall(exynos_iommu_init);
+
+static int debug_string_show(struct seq_file *s, void *unused)
+{
+	char *str = s->private;
+
+	seq_printf(s, "%s\n", str);
+
+	return 0;
+}
+
+static int debug_sysmmu_list_show(struct seq_file *s, void *unused)
+{
+	struct sysmmu_drvdata *drvdata = s->private;
+	struct platform_device *pdev = to_platform_device(drvdata->sysmmu);
+	int idx, maj, min, ret;
+
+	seq_printf(s, "SysMMU Name | Ver | SFR Base\n");
+
+	if (pm_runtime_enabled(drvdata->sysmmu)) {
+		ret = pm_runtime_get_sync(drvdata->sysmmu);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (idx = 0; idx < drvdata->nsfrs; idx++) {
+		struct resource *res;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, idx);
+		if (!res)
+			break;
+
+		maj = __sysmmu_version(drvdata, idx, &min);
+
+		if (drvdata->mmuname) {
+			if (maj == 0)
+				seq_printf(s, "%11.s | N/A | 0x%08x\n",
+					drvdata->mmuname[idx], res->start);
+			else
+				seq_printf(s, "%11.s | %d.%d | 0x%08x\n",
+				drvdata->mmuname[idx], maj, min, res->start);
+		} else {
+			if (maj == 0)
+				seq_printf(s, "N/A | 0x%08x\n", res->start);
+			else
+				seq_printf(s, "%d.%d | 0x%08x\n",
+							maj, min, res->start);
+		}
+	}
+
+	if (pm_runtime_enabled(drvdata->sysmmu))
+		pm_runtime_put(drvdata->sysmmu);
+
+	return 0;
+}
+
+static int debug_next_sibling_show(struct seq_file *s, void *unused)
+{
+	struct device *dev = s->private;
+
+	if (dev->parent &&
+		!strncmp(dev_name(dev->parent),
+			MODULE_NAME, strlen(MODULE_NAME)))
+		seq_printf(s, "%s\n", dev_name(dev->parent));
+	return 0;
+}
+
+static int __show_master(struct device *dev, void *data)
+{
+	struct seq_file *s = data;
+
+	if (strncmp(dev_name(dev), MODULE_NAME, strlen(MODULE_NAME)))
+		seq_printf(s, "%s\n", dev_name(dev));
+	return 0;
+}
+
+static int debug_master_show(struct seq_file *s, void *unused)
+{
+	struct device *dev = s->private;
+
+	device_for_each_child(dev, s, __show_master);
+	return 0;
+}
+
+static int debug_string_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_string_show, inode->i_private);
+}
+
+static int debug_sysmmu_list_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_sysmmu_list_show, inode->i_private);
+}
+
+static int debug_next_sibling_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_next_sibling_show, inode->i_private);
+}
+
+static int debug_master_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_master_show, inode->i_private);
+}
+
+static const struct file_operations debug_string_fops = {
+	.open = debug_string_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_sysmmu_list_fops = {
+	.open = debug_sysmmu_list_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_next_sibling_fops = {
+	.open = debug_next_sibling_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_master_fops = {
+	.open = debug_master_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void __init __create_debugfs_entry(struct sysmmu_drvdata *drvdata)
+{
+	if (!sysmmu_debugfs_root)
+		return;
+
+	drvdata->debugfs_root = debugfs_create_dir(dev_name(drvdata->sysmmu),
+							sysmmu_debugfs_root);
+	if (!drvdata->debugfs_root)
+		dev_err(drvdata->sysmmu, "Failed to create debugfs dentry\n");
+	if (IS_ERR(drvdata->debugfs_root))
+		drvdata->debugfs_root = NULL;
+
+	if (!drvdata->debugfs_root)
+		return;
+
+	if (!debugfs_create_u32("enable", 0664, drvdata->debugfs_root,
+						&drvdata->activations))
+		dev_err(drvdata->sysmmu,
+				"Failed to create debugfs file 'enable'\n");
+
+	if (!debugfs_create_x32("pagetable", 0664, drvdata->debugfs_root,
+						(u32 *)&drvdata->pgtable))
+		dev_err(drvdata->sysmmu,
+				"Failed to create debugfs file 'pagetable'\n");
+
+	if (!debugfs_create_file("sysmmu_list", 0444, drvdata->debugfs_root,
+					drvdata, &debug_sysmmu_list_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'sysmmu_list'\n");
+
+	if (!debugfs_create_file("next_sibling", 0x444, drvdata->debugfs_root,
+				drvdata->sysmmu, &debug_next_sibling_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'next_siblings'\n");
+
+	if (!debugfs_create_file("master", 0x444, drvdata->debugfs_root,
+				drvdata->sysmmu, &debug_master_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'next_siblings'\n");
+}
-- 
1.8.0


