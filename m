Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab2KUFHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:07:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47702 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2KUFHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:07:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-52-50ac6162b2dc
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 08/12] iommu/exynos: set System MMU as the parent of client
 device
Date: Wed, 21 Nov 2012 14:06:41 +0900
Message-id: <002f01cdc7a5$fe9a2aa0$fbce7fe0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Hpf5uqKZWUJrlSISDWY87baQHSw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zfd2kxDUBBufniVpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVcnfKBtWDFNsaKto1rWRoYN05i7GLk5JAQMJFoXfSc
	HcIWk7hwbz1bFyMXh5DAMkaJs4s/ssMUNZ3YCdYgJDCdUWLVVBuIon+MEidfz2ABSbAJaEms
	nnucESQhItDLKHGh/ysTiMMs8INRYvGbN8wgVcIC4RK/dt4B62ARUJW49XYmE4jNK2Arsf3f
	MzYIW1Dix+R7YDXMQFPX7zzOBGHLS2xe8xZoDgfQSeoSj/7qgoRFBPQkzu7YwwpRIiKx78U7
	RojxAhLfJh9igSiXldh0gBnkHAmB6ewSvYsXsEJ8JilxcMUNlgmMYrOQbJ6FZPMsJJtnIVmx
	gJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZI7EjvYFzVYHGIUYCDUYmHV2Lf6gAh1sSy
	4srcQ4wSHMxKIrwM8msChHhTEiurUovy44tKc1KLDzH6AF0+kVlKNDkfGNd5JfGGxsYmZiam
	JuaWpuamOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTAy9kxULZhmzmAYUBPGuGl9mWBT
	XBf3r1rXd/sta9pWKrvEyR1gu5R/KmadKkeJTEzb8jXTFCfsurahfm3WcxeGD0l97ybMfbly
	cbnga96101Ve9EmoPj+Wvu3JuuvpOSE7SvY2ZLj5/3GovnjtAdvsOwm+ywPYDjZdyvof8+NV
	GO8dM6NLayOUWIozEg21mIuKEwGACPtIygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd2kxDUBBq938Fpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXJ3ygbVgxTbG
	iraNa1kaGDdOYuxi5OSQEDCRaDqxE8oWk7hwbz0biC0kMJ1RYtVUmy5GLiD7H6PEydczWEAS
	bAJaEqvnHmcESYgI9DJKXOj/ygTiMAv8YJRY/OYNM0iVsEC4xK+dd8A6WARUJW69nckEYvMK
	2Eps//eMDcIWlPgx+R5YDTPQ1PU7jzNB2PISm9e8BZrDAXSSusSjv7ogYREBPYmzO/awQpSI
	SOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7M
	Z9I7GFc1WBxiFOBgVOLhldi3OkCINbGsuDL3EKMEB7OSCC+D/JoAId6UxMqq1KL8+KLSnNTi
	Q4w+QI9OZJYSTc4HJo28knhDYxMzI0sjMwsjE3NzHMJK4rzNHikBQgLpiSWp2ampBalFMOOY
	ODilGhhdo032dCvMEORuKtgl5Zzt+p/j/+FPN3/12uwv4Q3z1fVrZPn/lYFjAw/vC72nV2ZJ
	XND3U4o5s/nB1IrVQYW7zATVwz2VOOLko3fHSFWsW/T/dPlDg6Qna5ZLzN5VrOkUweMyy/fR
	6m+HYx++ftLq7+NaELNmO2vYReZ/H0xtmhNqrsyybFBiKc5INNRiLipOBAC21H84+QIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sets System MM as the parent of the client device for
power management. If System MMU is the parent of a device, it is
guaranteed that System MMU is suspended later than the device and
resumed earlier. Runtime suspend/resume on the device is also
propagated to the System MMU.
If a device is configured to have more than one System MMU, the
advantage of power management also works and the System MMUs are
also have relationships of parent and child. In this situation,
the client device is still the descendant of its System MMUs.

Change-Id: Idd1a28e95e5610feaaa3f43ee1bd12390e5f171c
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 538 ++++++++++++++++++++++++++++---------------
 1 file changed, 358 insertions(+), 180 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index e39ddac..f7dff54 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -104,6 +104,17 @@
 #define REG_PB1_SADDR		0x054
 #define REG_PB1_EADDR		0x058
 
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
 static struct kmem_cache *lv2table_kmem_cache;
 
 static unsigned long *section_entry(unsigned long *pgtable, unsigned long iova)
@@ -170,6 +181,16 @@ struct exynos_iommu_domain {
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
 };
 
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
 struct sysmmu_version {
 	unsigned char major; /* major = 0 means that driver must use MMU_VERSION
 				register instead of this structure */
@@ -177,9 +198,8 @@ struct sysmmu_version {
 };
 
 struct sysmmu_drvdata {
-	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
-	struct device *dev;	/* Owner of system MMU */
+	struct device *master;	/* Client device that needs System MMU */
 	int nsfrs;
 	struct clk *clk;
 	int activations;
@@ -281,62 +301,70 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 				unsigned long base0, unsigned long size0,
 				unsigned long base1, unsigned long size1)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-	unsigned long flags;
-	int i;
+	struct device *sysmmu;
 
-	BUG_ON((base0 + size0) <= base0);
-	BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
+	for_each_sysmmu(dev, sysmmu) {
+		int i;
+		unsigned long flags;
+		struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
 
-	spin_lock_irqsave(&data->lock, flags);
-	if (!is_sysmmu_active(data))
-		goto finish;
+		BUG_ON((base0 + size0) <= base0);
+		BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
 
-	for (i = 0; i < data->nsfrs; i++) {
-		if (__sysmmu_version(data, i, NULL) == 3) {
-			if (!sysmmu_block(data->sfrbases[i]))
-				continue;
-
-			if (size1 == 0) {
-				if (size0 <= SZ_128K) {
-					base1 = base0;
-					size1 = size0;
-				} else {
-					size1 = size0 -
+		spin_lock_irqsave(&data->lock, flags);
+		if (!is_sysmmu_active(data)) {
+			spin_unlock_irqrestore(&data->lock, flags);
+			continue;
+		}
+
+		for (i = 0; i < data->nsfrs; i++) {
+			if (__sysmmu_version(data, i, NULL) == 3) {
+				if (!sysmmu_block(data->sfrbases[i]))
+					continue;
+
+				if (size1 == 0) {
+					if (size0 <= SZ_128K) {
+						base1 = base0;
+						size1 = size0;
+					} else {
+						size1 = size0 -
 						ALIGN(size0 / 2, SZ_64K);
-					size0 = size0 - size1;
-					base1 = base0 + size0;
+						size0 = size0 - size1;
+						base1 = base0 + size0;
+					}
 				}
-			}
 
-			__sysmmu_set_prefbuf(
+				__sysmmu_set_prefbuf(
 					data->sfrbases[i], base0, size0, 0);
-			__sysmmu_set_prefbuf(
+				__sysmmu_set_prefbuf(
 					data->sfrbases[i], base1, size1, 1);
 
-			sysmmu_unblock(data->sfrbases[i]);
+				sysmmu_unblock(data->sfrbases[i]);
+			}
 		}
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
-finish:
-	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void __set_fault_handler(struct sysmmu_drvdata *data,
 					sysmmu_fault_handler_t handler)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&data->lock, flags);
 	data->fault_handler = handler;
-	spin_unlock_irqrestore(&data->lock, flags);
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
 
 static int default_fault_handler(enum exynos_sysmmu_inttype itype,
@@ -400,7 +428,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	}
 
 	if (data->domain)
-		ret = report_iommu_fault(data->domain, data->dev,
+		ret = report_iommu_fault(data->domain, data->master,
 				addr, itype);
 
 	if ((ret == -ENOSYS) && data->fault_handler) {
@@ -425,174 +453,264 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
+static void __sysmmu_disable_nocount(struct sysmmu_drvdata *drvdata)
 {
-	unsigned long flags;
-	bool disabled = false;
 	int i;
 
-	spin_lock_irqsave(&data->lock, flags);
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
 
-	if (data->clk)
-		clk_disable(data->clk);
+	if (disabled) {
+		drvdata->pgtable = 0;
+		drvdata->domain = NULL;
 
-	disabled = true;
-	data->pgtable = 0;
-	data->domain = NULL;
-finish:
-	spin_unlock_irqrestore(&data->lock, flags);
+		__sysmmu_disable_nocount(drvdata);
 
-	if (disabled)
-		dev_dbg(data->sysmmu, "Disabled\n");
-	else
-		dev_dbg(data->sysmmu, "%d times left to be disabled\n",
-					data->activations);
+		dev_dbg(drvdata->sysmmu, "Disabled\n");
+	} else  {
+		dev_dbg(drvdata->sysmmu, "%d times left to be disabled\n",
+						drvdata->activations);
+	}
+
+	spin_unlock_irqrestore(&drvdata->lock, flags);
 
 	return disabled;
 }
 
-/* __exynos_sysmmu_enable: Enables System MMU
- *
- * returns -error if an error occurred and System MMU is not enabled,
- * 0 if the System MMU has been just enabled and 1 if System MMU was already
- * enabled before.
- */
-static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
-			unsigned long pgtable, struct iommu_domain *domain)
+static bool __exynos_sysmmu_disable(struct device *dev)
 {
-	int i, ret = 0;
 	unsigned long flags;
+	bool disabled = true;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct device *sysmmu;
 
-	spin_lock_irqsave(&data->lock, flags);
+	BUG_ON(!has_sysmmu(dev));
 
-	if (!set_sysmmu_active(data)) {
-		if (WARN_ON(pgtable != data->pgtable)) {
-			ret = -EBUSY;
-			set_sysmmu_inactive(data);
-		} else {
-			ret = 1;
-		}
+	spin_lock_irqsave(&owner->lock, flags);
 
-		dev_dbg(data->sysmmu, "Already enabled\n");
-		goto finish;
+	/* Every call to __sysmmu_disable() must return same result */
+	for_each_sysmmu(dev, sysmmu) {
+		struct sysmmu_drvdata *drvdata = dev_get_drvdata(sysmmu);
+		disabled = __sysmmu_disable(drvdata);
+		if (disabled)
+			drvdata->master = NULL;
 	}
 
-	if (data->clk)
-		clk_enable(data->clk);
+	spin_unlock_irqrestore(&owner->lock, flags);
 
-	data->pgtable = pgtable;
+	return disabled;
+}
 
-	for (i = 0; i < data->nsfrs; i++) {
-		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
+static void __sysmmu_enable_nocount(struct sysmmu_drvdata *drvdata)
+{
+	int i;
+
+	clk_enable(drvdata->clk);
+
+	for (i = 0; i < drvdata->nsfrs; i++) {
+		int maj, min;
+		unsigned long cfg = 1;
 
-		if (__sysmmu_version(data, i, NULL)  == 3) {
+		__sysmmu_set_ptbase(drvdata->sfrbases[i], drvdata->pgtable);
+
+		/* Initialization of REG_MMU_CFG must be prior to
+		   call to __sysmmu_init_prefbuf() */
+		maj = __sysmmu_version(drvdata, i, &min);
+		if (maj == 3) {
 			/* System MMU version is 3.x */
 			__raw_writel((1 << 12) | (2 << 28),
-					data->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
+					drvdata->sfrbases[i] + REG_MMU_CFG);
+			__sysmmu_set_prefbuf(drvdata->sfrbases[i], 0, -1, 0);
+			__sysmmu_set_prefbuf(drvdata->sfrbases[i], 0, -1, 1);
 		}
 
-		__raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
+		__raw_writel(cfg, drvdata->sfrbases[i] + REG_MMU_CFG);
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
+		__sysmmu_enable_nocount(drvdata);
+
+		dev_dbg(drvdata->sysmmu, "Enabled\n");
+	} else {
+		ret = (pgtable == drvdata->pgtable) ? 1 : -EBUSY;
+
+		dev_dbg(drvdata->sysmmu, "Already enabled\n");
 	}
 
-	data->domain = domain;
+	if (WARN_ON(ret < 0))
+		set_sysmmu_inactive(drvdata); /* decrement count */
 
-	dev_dbg(data->sysmmu, "Enabled\n");
-finish:
-	spin_unlock_irqrestore(&data->lock, flags);
+	spin_unlock_irqrestore(&drvdata->lock, flags);
+
+	return ret;
+}
+
+/* __exynos_sysmmu_enable: Enables System MMU
+ *
+ * returns -error if an error occurred and System MMU is not enabled,
+ * 0 if the System MMU has been just enabled and 1 if System MMU was already
+ * enabled before.
+ */
+static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
+				struct iommu_domain *domain)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
+	struct device *sysmmu;
+
+	BUG_ON(!has_sysmmu(dev));
+
+	spin_lock_irqsave(&owner->lock, flags);
+
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
+		}
+	}
+
+	spin_unlock_irqrestore(&owner->lock, flags);
 
 	return ret;
 }
 
 int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	int ret;
+	struct device *sysmmu;
 
 	BUG_ON(!memblock_is_memory(pgtable));
 
-	ret = pm_runtime_get_sync(data->sysmmu);
+	for_each_sysmmu(dev, sysmmu) {
+		ret = pm_runtime_get_sync(sysmmu);
+		if (ret < 0)
+			break;
+	}
+
 	if (ret < 0) {
-		dev_dbg(data->sysmmu, "Failed to enable\n");
+		struct device *start;
+		for_each_sysmmu_until(dev, start, sysmmu)
+			pm_runtime_put(start);
+
 		return ret;
 	}
 
-	ret = __exynos_sysmmu_enable(data, pgtable, NULL);
-	if (WARN_ON(ret < 0)) {
-		pm_runtime_put(data->sysmmu);
-		dev_err(data->sysmmu,
-			"Already enabled with page table %#lx\n",
-			data->pgtable);
-	} else {
-		data->dev = dev;
-	}
+	ret = __exynos_sysmmu_enable(dev, pgtable, NULL);
+	if (ret < 0)
+		for_each_sysmmu(dev, sysmmu)
+			pm_runtime_put(sysmmu);
 
 	return ret;
 }
 
 bool exynos_sysmmu_disable(struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
 	bool disabled;
+	struct device *sysmmu;
 
-	disabled = __exynos_sysmmu_disable(data);
-	pm_runtime_put(data->sysmmu);
+	disabled = __exynos_sysmmu_disable(dev);
+
+	for_each_sysmmu(dev, sysmmu)
+		pm_runtime_put(sysmmu);
 
 	return disabled;
 }
 
 static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
 {
-	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct device *sysmmu;
 
-	spin_lock_irqsave(&data->lock, flags);
+	for_each_sysmmu(dev, sysmmu) {
+		unsigned long flags;
+		struct sysmmu_drvdata *data;
 
-	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate_entry(
+		data = dev_get_drvdata(sysmmu);
+
+		spin_lock_irqsave(&data->lock, flags);
+		if (is_sysmmu_active(data)) {
+			int i;
+			for (i = 0; i < data->nsfrs; i++) {
+				if (sysmmu_block(data->sfrbases[i])) {
+					__sysmmu_tlb_invalidate_entry(
 						data->sfrbases[i], iova);
-				sysmmu_unblock(data->sfrbases[i]);
+					sysmmu_unblock(data->sfrbases[i]);
+				} else {
+					dev_err(dev,
+					"%s failed due to blocking timeout\n",
+					__func__);
+				}
 			}
+		} else {
+			dev_dbg(dev,
+			"Disabled. Skipping TLB invalidation for %#lx\n", iova);
 		}
-	} else {
-		dev_dbg(data->sysmmu,
-			"Disabled. Skipping invalidating TLB.\n");
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
-
-	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 void exynos_sysmmu_tlb_invalidate(struct device *dev)
 {
-	unsigned long flags;
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
-
-	spin_lock_irqsave(&data->lock, flags);
-
-	if (is_sysmmu_active(data)) {
-		int i;
-		for (i = 0; i < data->nsfrs; i++) {
-			if (sysmmu_block(data->sfrbases[i])) {
-				__sysmmu_tlb_invalidate(data->sfrbases[i]);
-				sysmmu_unblock(data->sfrbases[i]);
+	struct device *sysmmu;
+
+	for_each_sysmmu(dev, sysmmu) {
+		unsigned long flags;
+		struct sysmmu_drvdata *data;
+
+		data = dev_get_drvdata(sysmmu);
+
+		spin_lock_irqsave(&data->lock, flags);
+		if (is_sysmmu_active(data)) {
+			int i;
+			for (i = 0; i < data->nsfrs; i++) {
+				if (sysmmu_block(data->sfrbases[i])) {
+					__sysmmu_tlb_invalidate(
+							data->sfrbases[i]);
+					sysmmu_unblock(data->sfrbases[i]);
+				} else {
+					dev_err(dev,
+					"%s failed due to blocking timeout\n",
+					__func__);
+				}
 			}
+		} else {
+			dev_dbg(dev, "Disabled. Skipping TLB invalidation\n");
 		}
-	} else {
-		dev_dbg(data->sysmmu,
-			"Disabled. Skipping invalidating TLB.\n");
+		spin_unlock_irqrestore(&data->lock, flags);
 	}
-
-	spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static int __init __sysmmu_init_clock(struct device *sysmmu,
@@ -645,7 +763,9 @@ static int __init __sysmmu_init_clock(struct device *sysmmu,
 static int __init __sysmmu_setup(struct device *sysmmu,
 				struct sysmmu_drvdata *drvdata)
 {
+	struct exynos_iommu_owner *owner;
 	struct device_node *master_node;
+	struct device *child;
 	const char *compat;
 	struct platform_device *pmaster = NULL;
 	u32 master_inst_no = -1;
@@ -679,12 +799,38 @@ static int __init __sysmmu_setup(struct device *sysmmu,
 		return __sysmmu_init_clock(sysmmu, drvdata, NULL);
 	}
 
-	pmaster->dev.archdata.iommu = sysmmu;
+	child = &pmaster->dev;
+
+	while (child->parent && is_sysmmu(child->parent))
+		child = child->parent;
+
+	owner = devm_kzalloc(sysmmu, sizeof(*owner), GFP_KERNEL);
+	if (!owner) {
+		ret = -ENOMEM;
+		dev_err(sysmmu, "Failed to allocate iommu data\n");
+		goto err_dev_put;
+	}
+
+	INIT_LIST_HEAD(&owner->client);
+	owner->dev = &pmaster->dev;
+	spin_lock_init(&owner->lock);
+
+	ret = device_move(child, sysmmu, DPM_ORDER_PARENT_BEFORE_DEV);
+	if (ret) {
+		dev_err(sysmmu, "Failed to set parent of %s\n",
+						dev_name(child));
+		goto err_dev_put;
+	}
+
+	pmaster->dev.archdata.iommu = owner;
 
 	ret = __sysmmu_init_clock(sysmmu, drvdata, &pmaster->dev);
 	if (ret)
 		dev_err(sysmmu, "Failed to initialize gating clocks\n");
-
+	else
+		dev_dbg(sysmmu, "Assigned master device %s\n",
+						dev_name(owner->dev));
+err_dev_put:
 	of_dev_put(pmaster);
 
 	return ret;
@@ -749,13 +895,13 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 	if (!ret) {
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
-		INIT_LIST_HEAD(&data->node);
 
 		__set_fault_handler(data, &default_fault_handler);
 
 		platform_set_drvdata(pdev, data);
 
-		dev_dbg(dev, "Initialized\n");
+		dev->archdata.iommu = &sysmmu_placeholder;
+		dev_dbg(dev, "Initialized successfully!\n");
 	}
 
 	return ret;
@@ -850,7 +996,7 @@ err_pgtable:
 static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
+	struct exynos_iommu_owner *owner, *n;
 	unsigned long flags;
 	int i;
 
@@ -858,9 +1004,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	list_for_each_entry(data, &priv->clients, node) {
-		while (!exynos_sysmmu_disable(data->dev))
+	list_for_each_entry_safe(owner, n, &priv->clients, client) {
+		struct device *sysmmu;
+		while (!__exynos_sysmmu_disable(owner->dev))
 			; /* until System MMU is actually disabled */
+		list_del_init(&owner->client);
+
+		for_each_sysmmu(owner->dev, sysmmu)
+			pm_runtime_put(sysmmu);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -879,37 +1030,68 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 static int exynos_iommu_attach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
-	struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
+	struct exynos_iommu_owner *owner = dev->archdata.iommu;
 	struct exynos_iommu_domain *priv = domain->priv;
 	unsigned long flags;
 	int ret;
+	struct device *sysmmu;
 
-	ret = pm_runtime_get_sync(data->sysmmu);
-	if (ret < 0)
-		return ret;
+	if (WARN_ON(!list_empty(&owner->client))) {
+		bool found = false;
+		struct exynos_iommu_owner *tmpowner;
 
-	ret = 0;
+		spin_lock_irqsave(&priv->lock, flags);
+		list_for_each_entry(tmpowner, &priv->clients, client) {
+			if (tmpowner == owner) {
+				found = true;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&priv->lock, flags);
 
-	spin_lock_irqsave(&priv->lock, flags);
+		if (!found) {
+			dev_err(dev, "%s: Already attached to another domain\n",
+								__func__);
+			return -EBUSY;
+		}
+
+		dev_dbg(dev, "%s: Already attached to this domain\n", __func__);
+		return 0;
+	}
+
+	for_each_sysmmu(dev, sysmmu) {
+		ret = pm_runtime_get_sync(sysmmu);
+		if (ret < 0)
+			break;
+	}
 
-	ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
+	if (ret < 0) {
+		struct device *start;
+		for_each_sysmmu_until(dev, start, sysmmu)
+			pm_runtime_put(start);
 
-	if (ret == 0) {
-		/* 'data->node' must not be appeared in priv->clients */
-		BUG_ON(!list_empty(&data->node));
-		data->dev = dev;
-		list_add_tail(&data->node, &priv->clients);
+		return ret;
 	}
 
+	spin_lock_irqsave(&priv->lock, flags);
+
+	ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
+
+	/*
+	 * __exynos_sysmmu_enable() returns 1
+	 * if the System MMU of dev is already enabled
+	 */
+	BUG_ON(ret > 0);
+
+	list_add_tail(&owner->client, &priv->clients);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-		pm_runtime_put(data->sysmmu);
-	} else if (ret > 0) {
-		dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
-					__func__, __pa(priv->pgtable));
+		for_each_sysmmu(dev, sysmmu)
+			pm_runtime_put(sysmmu);
 	} else {
 		dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
 					__func__, __pa(priv->pgtable));
@@ -921,39 +1103,33 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
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
+			if (__exynos_sysmmu_disable(dev))
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
+	if (owner == dev->archdata.iommu) {
+		struct device *sysmmu;
 		dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
 					__func__, __pa(priv->pgtable));
-		list_del_init(&data->node);
-
-	} else {
-		dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
-					__func__, __pa(priv->pgtable));
-	}
+		for_each_sysmmu(dev, sysmmu)
+			pm_runtime_put(sysmmu);
 
-finish:
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (found)
-		pm_runtime_put(data->sysmmu);
+	} else
+		dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
 }
 
 static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
@@ -1068,7 +1244,6 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					       unsigned long iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
-	struct sysmmu_drvdata *data;
 	unsigned long flags;
 	unsigned long *ent;
 
@@ -1120,8 +1295,11 @@ done:
 	spin_unlock_irqrestore(&priv->pgtablelock, flags);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	list_for_each_entry(data, &priv->clients, node)
-		sysmmu_tlb_invalidate_entry(data->dev, iova);
+	{
+		struct exynos_iommu_owner *owner;
+		list_for_each_entry(owner, &priv->clients, client)
+			sysmmu_tlb_invalidate_entry(owner->dev, iova);
+	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 
-- 
1.8.0


