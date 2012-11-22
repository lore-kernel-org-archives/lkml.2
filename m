Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2KVTpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:45:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59549 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab2KVTps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:45:48 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-59-50ae0d96cdb6
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 11/12] iommu/exynos: add literal name of System MMU for
 debugging
Date: Thu, 22 Nov 2012 20:33:41 +0900
Message-id: <002c01cdc8a5$3976abd0$ac640370$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpTktbufXLw2oRj+8CCKi5uMPHw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfd1pvOsCDM5s1LG4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mpo+PiQpWCrWcW+TTOYGhivancxcnJICJhIXHuzjxHC
	FpO4cG89WxcjF4eQwDJGienz9rLCFE18NJsRIjGdUeL640ksEM4/Ron3D5tYQKrYBLQkVs89
	DlYlItDLKHGh/ysTiMMs8ANo1uZfYFXCAmESTc8/MXcxcnCwCKhK/D0nCxLmFbCVuPn9CiOE
	LSjxY/I9sHJmoKHrdx5ngrDlJTaveQvWKiGgLvHory6IKSKgJzFlmhdEhYjEvhfvwKawCAhI
	fJt8iAWiWlZi0wFmkGMkBCazS7yesxrqMUmJgytusExgFJuFZPEsJItnIVk8C8mKBYwsqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzFCokZqB+PKBotDjAIcjEo8vJrOawOEWBPLiitzDzFK
	cDArifDe414XIMSbklhZlVqUH19UmpNafIjRB+jyicxSosn5wIjOK4k3NDY2MTMxNTG3NDU3
	xSGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoGx4cRN/aTXVl56L5ZMONMYNOumbbmOUZPt
	RT+mfRu0VqhVlmpOST4xL/N3ayIP25Izy6IdrzE8kmWQdnFRl5gmutjz+Cqt7BNp6l1Pe/KS
	/9zsu6ewp/vCNjmTbaIqOlYGh++tSvKpCngxa5dgUe6k5/v95iyNu/boqOp75gt3HZhXJ28N
	Y56rxFKckWioxVxUnAgAKHz24ccCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jQd1pvOsCDGbcV7W4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMaPj4kKVgq1nF
	vk0zmBoYr2p3MXJySAiYSEx8NJsRwhaTuHBvPVsXIxeHkMB0RonrjyexQDj/GCXeP2xiAali
	E9CSWD33OCNIQkSgl1HiQv9XJhCHWeAHo8T0zb/AqoQFwiSann9i7mLk4GARUJX4e04WJMwr
	YCtx8/sVRghbUOLH5Htg5cxAQ9fvPM4EYctLbF7zFqxVQkBd4tFfXRBTREBPYso0L4gKEYl9
	L94xTmAUmIVk0Cwkg2YhGTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEx+Uxq
	B+PKBotDjAIcjEo8vJrOawOEWBPLiitzDzFKcDArifDe414XIMSbklhZlVqUH19UmpNafIjR
	B+jNicxSosn5wHSRVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwen
	VAPjWt4CwwblDcl8P9IS5/utlbt1WX5S3Vp1ZuaXK4/7nxQ3VQgQLHomHux2dI6G6bk0pcpe
	nj7Vf2bZ8eUmy82qrJke84rcbo3sYZbeYrxk65z9j7sXWLp1r01jiFs2sW3B66WHjxU+9Y02
	Emzd861ZhW/PowU8cltbuPKNbgme3VDSNCF633clluKMREMt5qLiRADvc6wT9gIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds System MMU name to the driver data of each System
MMU. It is used by fault information.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 100 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 76 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 985d317..4981afe 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/string.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 
@@ -150,15 +151,21 @@ enum exynos_sysmmu_inttype {
 	SYSMMU_FAULTS_NUM
 };
 
-/*
+/**
+ * fault handler function type
+ * @dev: the client device
+ * @mmuname: name of the System MMU that generates fault
  * @itype: type of fault.
  * @pgtable_base: the physical address of page table base. This is 0 if @itype
  *                is SYSMMU_BUSERROR.
  * @fault_addr: the device (virtual) address that the System MMU tried to
  *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
  */
-typedef int (*sysmmu_fault_handler_t)(enum exynos_sysmmu_inttype itype,
-			unsigned long pgtable_base, unsigned long fault_addr);
+typedef int (*sysmmu_fault_handler_t)(struct device *dev,
+				      const char *mmuname,
+				      enum exynos_sysmmu_inttype itype,
+				      unsigned long pgtable_base,
+				      unsigned long fault_addr);
 
 static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
 	REG_PAGE_FAULT_ADDR,
@@ -234,6 +241,7 @@ struct sysmmu_drvdata {
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
 	bool runtime_active;
+	const char **mmuname;
 	void __iomem *sfrbases[0];
 };
 
@@ -611,16 +619,18 @@ void exynos_sysmmu_set_fault_handler(struct device *dev,
 	spin_unlock_irqrestore(&owner->lock, flags);
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
+	dev_err(dev, "%s occured at 0x%lx by '%s'(Page table base: 0x%lx)\n",
+		sysmmu_fault_name[itype], fault_addr, mmuname, pgtable_base);
 
 	ent = section_entry(__va(pgtable_base), fault_addr);
 	pr_err("\tLv1 entry: 0x%lx\n", *ent);
@@ -641,25 +651,30 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 {
 	/* SYSMMU is in blocked when interrupt occurred. */
 	struct sysmmu_drvdata *data = dev_id;
-	struct resource *irqres;
-	struct platform_device *pdev;
+	struct exynos_iommu_owner *owner = NULL;
 	enum exynos_sysmmu_inttype itype;
 	unsigned long addr = -1;
-
+	const char *mmuname = NULL;
 	int i, ret = -ENOSYS;
 
-	spin_lock(&data->lock);
+	if (data->master)
+		owner = data->master->archdata.iommu;
+
+	if (owner)
+		spin_lock(&owner->lock);
 
 	WARN_ON(!is_sysmmu_active(data));
 
-	pdev = to_platform_device(data->sysmmu);
-	for (i = 0; i < (pdev->num_resources / 2); i++) {
-		irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
+	for (i = 0; i < data->nsfrs; i++) {
+		struct resource *irqres;
+		irqres = platform_get_resource(
+				to_platform_device(data->sysmmu),
+				IORESOURCE_IRQ, i);
 		if (irqres && ((int)irqres->start == irq))
 			break;
 	}
 
-	if (i == pdev->num_resources) {
+	if (i == data->nsfrs) {
 		itype = SYSMMU_FAULT_UNKNOWN;
 	} else {
 		itype = (enum exynos_sysmmu_inttype)
@@ -671,28 +686,34 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 				data->sfrbases[i] + fault_reg_offset[itype]);
 	}
 
-	if (data->domain)
-		ret = report_iommu_fault(data->domain, data->master,
+	if (data->domain) /* owner is always set if data->domain exists */
+		ret = report_iommu_fault(data->domain, owner->dev,
 				addr, itype);
 
 	if ((ret == -ENOSYS) && data->fault_handler) {
 		unsigned long base = data->pgtable;
+		mmuname = (data->mmuname) ?  data->mmuname[i]
+						: dev_name(data->sysmmu);
+
 		if (itype != SYSMMU_FAULT_UNKNOWN)
 			base = __raw_readl(
 					data->sfrbases[i] + REG_PT_BASE_ADDR);
-		ret = data->fault_handler(itype, base, addr);
+		ret = data->fault_handler(owner ? owner->dev : data->sysmmu,
+					mmuname, itype, base, addr);
 	}
 
 	if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
 		__raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
 	else
-		dev_dbg(data->sysmmu, "%s is not handled.\n",
-				sysmmu_fault_name[itype]);
+		dev_dbg(owner ? owner->dev : data->sysmmu,
+				"%s is not handled by %s\n",
+				sysmmu_fault_name[itype],
+				dev_name(data->sysmmu));
 
-	if (itype != SYSMMU_FAULT_UNKNOWN)
-		sysmmu_unblock(data->sfrbases[i]);
+	sysmmu_unblock(data->sfrbases[i]);
 
-	spin_unlock(&data->lock);
+	if (owner)
+		spin_unlock(&owner->lock);
 
 	return IRQ_HANDLED;
 }
@@ -1050,6 +1071,30 @@ err_dev_put:
 	return ret;
 }
 
+static void __init __sysmmu_init_mmuname(struct device *sysmmu,
+					struct sysmmu_drvdata *drvdata)
+{
+	int i;
+	const char *mmuname;
+
+	if (of_property_count_strings(sysmmu->of_node, "mmuname") !=
+							drvdata->nsfrs)
+		return;
+
+	drvdata->mmuname = (void *)drvdata->sfrbases +
+				sizeof(drvdata->sfrbases[0]) * drvdata->nsfrs;
+
+	for (i = 0; i < drvdata->nsfrs; i++) {
+		if (of_property_read_string_index(sysmmu->of_node,
+					"mmuname", i, &mmuname))
+			dev_err(sysmmu, "Failed read mmuname[%d]\n", i);
+		else
+			drvdata->mmuname[i] = kstrdup(mmuname, GFP_KERNEL);
+		if (!drvdata->mmuname[i])
+			drvdata->mmuname[i] = "noname";
+	}
+}
+
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int i, ret;
@@ -1061,9 +1106,14 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	ret = of_property_count_strings(pdev->dev.of_node, "mmuname");
+	if (ret != (int)(pdev->num_resources / 2))
+		ret = 0;
+
 	data = devm_kzalloc(dev,
 			sizeof(*data)
-			+ sizeof(*data->sfrbases) * (pdev->num_resources / 2),
+			+ sizeof(*data->sfrbases) * (pdev->num_resources / 2)
+			+ sizeof(*data->mmuname) * ret,
 			GFP_KERNEL);
 	if (!data) {
 		dev_err(dev, "Not enough memory\n");
@@ -1107,6 +1157,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = __sysmmu_setup(dev, data);
 	if (!ret) {
+		__sysmmu_init_mmuname(dev, data);
+
 		data->runtime_active = !pm_runtime_enabled(dev);
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
-- 
1.8.0


