Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2KUFHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:07:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58924 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2KUFHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:07:41 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ef-50ac619c72fa
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 11/12] iommu/exynos: add literal name of System MMU for
 debugging
Date: Wed, 21 Nov 2012 14:07:39 +0900
Message-id: <003201cdc7a6$21468260$63d38720$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HpiErl3t2ZMqDQiiqjLw7VsHzIw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zA905iWsCDHo6JSwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK2fMgqeG1WcXzvV6YGxg6dLkZODgkBE4mW67PYIWwx
	iQv31rN1MXJxCAksY5RYve0DM0zRjIbbTBCJ6YwSbx4vZIRw/jFKPLv9kgWkik1AS2L13ONg
	CRGBXkaJC/1fwVqYBX4wSix+8wZslrBAmMSCwz8YQWwWAVWJNXs3s4LYvAK2EmuWbWSEsAUl
	fky+BzaVGWjq+p3HmSBseYnNa94CzeEAukld4tFfXZCwiICexKzmf6wQJSIS+168gxovIPFt
	8iEWiHJZiU0HmEHOkRCYzC4x88AUFojXJCUOrrjBMoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiJG+kdjKsaLA4xCnAwKvHwSuxbHSDEmlhWXJl7iFGC
	g1lJhJdBfk2AEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJJucDYzqvJN7Q2NjEzMTUxNzS1NwU
	h7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsaEdq+3boFBboIVYjGxe0uqZl8UM5p5/HPs
	ZBPFj89XCL5MK3oi9MEio2JPZO/RfSWlEo4OttN+XRawbJBfsuXk2XML1fetuc/pFpXRvGPz
	bu3UxQwc0xRemO9qktxSLvTvbFrJGc4nih9nRylLGt67u73x8H7B9gqhsx+Xx808dPqz7arv
	5iFKLMUZiYZazEXFiQA9bOS5yAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd05iWsCDLb2Cltc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmbPmQVfDarOL4
	3q9MDYwdOl2MnBwSAiYSMxpuM0HYYhIX7q1n62Lk4hASmM4o8ebxQkYI5x+jxLPbL1lAqtgE
	tCRWzz0OlhAR6GWUuND/lQnEYRb4wSix+M0bZpAqYYEwiQWHfzCC2CwCqhJr9m5mBbF5BWwl
	1izbyAhhC0r8mHwPbCoz0NT1O48zQdjyEpvXvAWawwF0k7rEo7+6IGERAT2JWc3/WCFKRCT2
	vXjHOIFRYBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH5TPp
	HYyrGiwOMQpwMCrx8ErsWx0gxJpYVlyZe4hRgoNZSYSXQX5NgBBvSmJlVWpRfnxRaU5q8SFG
	H6BHJzJLiSbnAxNGXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTByc
	Ug2MbcHL5B/NWigV52atvZqN93ZE9OT9n+9Pm9b5ZsblNokS5/4wmVjTY6c7X548167tY/x9
	Ub96AI/g4r/dV1Sv8G1ccJgzwvVS6epa82kXdy5053zcoqS/d97xlm1fd93PdWDvOVDOE7SW
	9fm7bccD5S5sXTBVLfdNmKd9uMaiIz31dV37pY+KK7EUZyQaajEXFScCALcGglz3AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds System MMU name to the driver data of each System
MMU. It is used by fault information.

Change-Id: If6720b69609880873ebaf160188f1e726a67b806
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 100 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 76 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index bcfa9b0..886fae5 100644
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
@@ -1048,6 +1069,30 @@ err_dev_put:
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
@@ -1059,9 +1104,14 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
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
@@ -1105,6 +1155,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = __sysmmu_setup(dev, data);
 	if (!ret) {
+		__sysmmu_init_mmuname(dev, data);
+
 		data->runtime_active = !pm_runtime_enabled(dev);
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
-- 
1.8.0


