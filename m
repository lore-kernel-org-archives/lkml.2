Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab2KUFEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:04:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:33543 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2KUFEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:04:39 -0500
X-AuditID: cbfee61b-b7f616d00000319b-16-50ac60c66937
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 04/12] iommu/exynos: support for device tree
Date: Wed, 21 Nov 2012 14:04:06 +0900
Message-id: <002b01cdc7a5$a1f79120$e5e6b360$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HpaHV4H0tM9e9QUO7DtOZ4ypDHQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI91jCWsCDI48M7O4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrY9f8Nc8G3rIoTE5uZGxhPh3YxcnJICJhIHP+zgAXC
	FpO4cG89WxcjF4eQwDJGiYmX77PBFD1a1cUEkVjEKNE6eTcjhPOPUeL+uWeMIFVsAloSq+ce
	B0uICPQySlzo/wrWwizwg1Fi8Zs3zF2MHBzCAvYS66emgDSwCKhKbH36kBEkzCtgKzGxA+wk
	XgFBiR+T74GdxAw0c/3O40wQtrzE5jVvwaZICKhLPPqrCxIWEdCTmNZzCKpERGLfi3eMENMF
	JL5NPsQCUS4rsekAM8gxEgKT2SVOfVnJCvGYpMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFRI72DcVWDxSFGAQ5GJR5eiX2rA4RYE8uKK3MP
	MUpwMCuJ8DLIrwkQ4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5HxgROeVxBsaG5uYmZiamFua
	mpviEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwMg898DsCT6pKcXblF+97JkYfKF0paZU
	uGG/6668yeL7i31/a9colygUPLrZ1ugVe8sh39qWXbFvXYJAvq/+tMPqVw7Pq1AJeKg0X0lq
	vfGZ7ew/UydPeLDkWu7aKScmzYp6YXnTItQg7XZfWue5TXrzv86+Nisw8LhEcVL/3ztLatdP
	jz3Ex6rEUpyRaKjFXFScCABcsgm/xwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd1jCWsCDDo7DS0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzdv1/w1zwLavi
	xMRm5gbG06FdjJwcEgImEo9WdTFB2GISF+6tZ+ti5OIQEljEKNE6eTcjhPOPUeL+uWeMIFVs
	AloSq+ceB0uICPQySlzo/8oE4jAL/GCUWPzmDXMXIweHsIC9xPqpKSANLAKqElufPmQECfMK
	2EpM7ADbzCsgKPFj8j0WEJsZaOb6nceZIGx5ic1r3oJNkRBQl3j0VxckLCKgJzGt5xBUiYjE
	vhfvGCcwCsxCMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgmHwm
	vYNxVYPFIUYBDkYlHl6JfasDhFgTy4orcw8xSnAwK4nwMsivCRDiTUmsrEotyo8vKs1JLT7E
	6AP050RmKdHkfGC6yCuJNzQ2MTOyNDKzMDIxN8chrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomD
	U6qB0W7WbdEDTyP2rb8R6ugl42c+4+yaVQslWVfd2BXYw2hTtHNrks/2HGY1/dPW6mtrJ9w0
	XvNQ4m2fAZOzyfTVr24cLX7llFN4ebmMzcd9p7ZsLc5XXpsmv8/IadGUSwdUb5ksPbEyRWmJ
	R1R/DE9Prx7HKY6F50/xy8++qvd+uryHfdLGLtZ2TSWW4oxEQy3mouJEAIyVtnH2AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds device tree support for System MMU.

Change-Id: If695448af4bd7829ad1543814281dfa8ce1e7aae
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/Kconfig        |   2 +-
 drivers/iommu/exynos-iommu.c | 289 ++++++++++++++++++++++++++-----------------
 2 files changed, 177 insertions(+), 114 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..64586f1 100644
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
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7fe44f8..53972c8 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1,6 +1,6 @@
-/* linux/drivers/iommu/exynos_iommu.c
+/* linux/drivers/iommu/exynos-iommu.c
  *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * This program is free software; you can redistribute it and/or modify
@@ -12,6 +12,7 @@
 #define DEBUG
 #endif
 
+#include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -25,11 +26,10 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 #include <asm/cacheflush.h>
-#include <asm/pgtable.h>
-
-#include <mach/sysmmu.h>
 
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
@@ -169,15 +169,14 @@ struct sysmmu_drvdata {
 	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *dev;	/* Owner of system MMU */
-	char *dbgname;
 	int nsfrs;
-	void __iomem **sfrbases;
-	struct clk *clk[2];
+	struct clk *clk;
 	int activations;
 	rwlock_t lock;
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
+	void __iomem *sfrbases[0];
 };
 
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
@@ -384,8 +383,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
 		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
 	else
-		dev_dbg(data->sysmmu, "(%s) %s is not handled.\n",
-				data->dbgname, sysmmu_fault_name[itype]);
+		dev_dbg(data->sysmmu, "%s is not handled.\n",
+				sysmmu_fault_name[itype]);
 
 	if (itype != SYSMMU_FAULT_UNKNOWN)
 		sysmmu_unblock(data->sfrbases[i]);
@@ -409,10 +408,8 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 	for (i = 0; i < data->nsfrs; i++)
 		__raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
 
-	if (data->clk[1])
-		clk_disable(data->clk[1]);
-	if (data->clk[0])
-		clk_disable(data->clk[0]);
+	if (data->clk)
+		clk_disable(data->clk);
 
 	disabled = true;
 	data->pgtable = 0;
@@ -421,10 +418,10 @@ finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
 	if (disabled)
-		dev_dbg(data->sysmmu, "(%s) Disabled\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Disabled\n");
 	else
-		dev_dbg(data->sysmmu, "(%s) %d times left to be disabled\n",
-					data->dbgname, data->activations);
+		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
+					data->activations);
 
 	return disabled;
 }
@@ -451,14 +448,12 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 			ret = 1;
 		}
 
-		dev_dbg(data->sysmmu, "(%s) Already enabled\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Already enabled\n");
 		goto finish;
 	}
 
-	if (data->clk[0])
-		clk_enable(data->clk[0]);
-	if (data->clk[1])
-		clk_enable(data->clk[1]);
+	if (data->clk)
+		clk_enable(data->clk);
 
 	data->pgtable = pgtable;
 
@@ -478,7 +473,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 
 	data->domain = domain;
 
-	dev_dbg(data->sysmmu, "(%s) Enabled\n", data->dbgname);
+	dev_dbg(data->sysmmu, "Enabled\n");
 finish:
 	write_unlock_irqrestore(&data->lock, flags);
 
@@ -494,7 +489,7 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 
 	ret = pm_runtime_get_sync(data->sysmmu);
 	if (ret < 0) {
-		dev_dbg(data->sysmmu, "(%s) Failed to enable\n", data->dbgname);
+		dev_dbg(data->sysmmu, "Failed to enable\n");
 		return ret;
 	}
 
@@ -502,8 +497,8 @@ int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 	if (WARN_ON(ret < 0)) {
 		pm_runtime_put(data->sysmmu);
 		dev_err(data->sysmmu,
-			"(%s) Already enabled with page table %#lx\n",
-			data->dbgname, data->pgtable);
+			"Already enabled with page table %#lx\n",
+			data->pgtable);
 	} else {
 		data->dev = dev;
 	}
@@ -540,8 +535,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 		}
 	} else {
 		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+			"Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
@@ -564,140 +558,209 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 		}
 	} else {
 		dev_dbg(data->sysmmu,
-			"(%s) Disabled. Skipping invalidating TLB.\n",
-			data->dbgname);
+			"Disabled. Skipping invalidating TLB.\n");
 	}
 
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
-static int exynos_sysmmu_probe(struct platform_device *pdev)
+static int __init __sysmmu_init_clock(struct device *sysmmu,
+					struct sysmmu_drvdata *drvdata,
+					struct device *master)
 {
-	int i, ret;
-	struct device *dev;
-	struct sysmmu_drvdata *data;
+	char *conid;
+	struct clk *parent_clk;
+	int ret;
 
-	dev = &pdev->dev;
+	drvdata->clk = clk_get(sysmmu, "sysmmu");
+	if (IS_ERR(drvdata->clk)) {
+		dev_dbg(sysmmu, "No gating clock found.\n");
+		drvdata->clk = NULL;
+		return 0;
+	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_dbg(dev, "Not enough memory\n");
-		ret = -ENOMEM;
-		goto err_alloc;
+	if (!master)
+		return 0;
+
+	conid = dev_get_platdata(sysmmu);
+	if (!conid) {
+		dev_dbg(sysmmu, "No parent clock specified.\n");
+		return 0;
 	}
 
-	ret = dev_set_drvdata(dev, data);
+	parent_clk = clk_get(master, conid);
+	if (IS_ERR(parent_clk)) {
+		parent_clk = clk_get(NULL, conid);
+		if (IS_ERR(parent_clk)) {
+			clk_put(drvdata->clk);
+			dev_err(sysmmu, "No parent clock '%s,%s' found\n",
+				dev_name(master), conid);
+			return PTR_ERR(parent_clk);
+		}
+	}
+
+	ret = clk_set_parent(drvdata->clk, parent_clk);
 	if (ret) {
-		dev_dbg(dev, "Unabled to initialize driver data\n");
-		goto err_init;
+		clk_put(drvdata->clk);
+		dev_err(sysmmu, "Failed to set parent clock '%s,%s'\n",
+				dev_name(master), conid);
 	}
 
-	data->nsfrs = pdev->num_resources / 2;
-	data->sfrbases = kmalloc(sizeof(*data->sfrbases) * data->nsfrs,
-								GFP_KERNEL);
-	if (data->sfrbases == NULL) {
-		dev_dbg(dev, "Not enough memory\n");
-		ret = -ENOMEM;
-		goto err_init;
+	clk_put(parent_clk);
+
+	return ret;
+}
+
+static int __init __sysmmu_setup(struct device *sysmmu,
+				struct sysmmu_drvdata *drvdata)
+{
+	struct device_node *master_node;
+	const char *compat;
+	struct platform_device *pmaster = NULL;
+	u32 master_inst_no = -1;
+	int ret;
+
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
 	}
 
+	if (!pmaster) {
+		dev_dbg(sysmmu, "No master device is specified.\n");
+		return __sysmmu_init_clock(sysmmu, drvdata, NULL);
+	}
+
+	pmaster->dev.archdata.iommu = sysmmu;
+
+	ret = __sysmmu_init_clock(sysmmu, drvdata, &pmaster->dev);
+	if (ret)
+		dev_err(sysmmu, "Failed to initialize gating clocks\n");
+
+	of_dev_put(pmaster);
+
+	return ret;
+}
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
+	data = devm_kzalloc(dev,
+			sizeof(*data)
+			+ sizeof(*data->sfrbases) * (pdev->num_resources / 2),
+			GFP_KERNEL);
+	if (!data) {
+		dev_err(dev, "Not enough memory\n");
+		return -ENOMEM;
+	}
+
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
-
-		beg = platdata->clockname;
+	pm_runtime_enable(dev);
 
-		for (deli = beg; (*deli != '\0') && (*deli != ','); deli++)
-			/* NOTHING */;
+	ret = __sysmmu_setup(dev, data);
+	if (!ret) {
+		data->sysmmu = dev;
+		rwlock_init(&data->lock);
+		INIT_LIST_HEAD(&data->node);
 
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
+		platform_set_drvdata(pdev, data);
 
-		if (data->clk[0] && deli) {
-			*deli = ',';
-			data->clk[1] = clk_get(dev, deli + 1);
-			if (IS_ERR(data->clk[1]))
-				data->clk[1] = NULL;
-		}
-
-		data->dbgname = platdata->dbgname;
+		dev_dbg(dev, "Initialized\n");
 	}
 
-	data->sysmmu = dev;
-	rwlock_init(&data->lock);
-	INIT_LIST_HEAD(&data->node);
-
-	__set_fault_handler(data, &default_fault_handler);
-
-	if (dev->parent)
-		pm_runtime_enable(dev);
-
-	dev_dbg(dev, "(%s) Initialized\n", data->dbgname);
-	return 0;
-err_irq:
-	while (i-- > 0) {
-		int irq;
-
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
 	return ret;
 }
 
-static struct platform_driver exynos_sysmmu_driver = {
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
+
+static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.probe		= exynos_sysmmu_probe,
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.of_match_table = of_match_ptr(sysmmu_of_match),
 	}
 };
 
-- 
1.8.0


