Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2KTHa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:30:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43148 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2KTHax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:53 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-24-50ab31ac61b4
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sw0312.kim@samsung.com
Subject: [PATCH v2 11/12] iommu/exynos: add literal name of System MMU for
 debugging
Date: Tue, 20 Nov 2012 16:30:51 +0900
Message-id: <002501cdc6f0$f81ca550$e855eff0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3G8Pf7K7ZNOpfFRtG+z7QLbtvIyQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfd01hqsDDH70C1lc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGX0P/jKXLDVrOL0o4NsDYxXtbsYOTgkBEwkLuwW7mLk
	BDLFJC7cW8/WxcjFISSwjFHiy/mJzBAJE4mGOaeZIRKLGCXutX5hhHD+MUo8evSFBaSKTUBL
	YvXc42AJEYFeRokL/V+ZQBxmgR+MEtvmb2MFqRIWCJP4/mMRI4jNIqAqse3eNnYQm1fAVmLG
	2klMELagxI/J98CmMgNNXb/zOBOELS+xec1bZoi71SUe/dUFCYsI6ElM3zKTGaJERGLfi3dQ
	4wUkvk0+xAJRLiux6QDUN5PZJRZ3+kDYkhIHV9xgmcAoNgvJ4llIFs9CsngWkg0LGFlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYoREjdQOxpUNFocYBTgYlXh4HyasChBiTSwrrsw9xCjB
	wawkwttUDhTiTUmsrEotyo8vKs1JLT7E6AN0+ERmKdHkfGBE55XEGxobm5iZmJqYW5qam+IQ
	VhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAuNEiovUD++U1FXnSwq1mIXpSrumevkdm/X+p
	uDLJrKmYT2LBel/W9xwhD/eaGZ9JO715w/9gBaOPubuUXxy3imWcU/rg0NZpc/YtunJuV/a7
	db8e7Z6qJPSK+e6KwJvZFRd0b6kqpNo9nMxx/7zovbo2GVNrF6c9T0zdF7NPXcQwScP6xQfD
	k0osxRmJhlrMRcWJAEM5m4LHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd01hqsDDC7d5rW4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6H/wlblgq1nF
	6UcH2RoYr2p3MXJySAiYSDTMOc0MYYtJXLi3nq2LkYtDSGARo8S91i+MEM4/RolHj76wgFSx
	CWhJrJ57HCwhItDLKHGh/ysTiMMs8INRYtv8bawgVcICYRLffyxiBLFZBFQltt3bxg5i8wrY
	SsxYO4kJwhaU+DH5HthUZqCp63ceZ4Kw5SU2r3kLdBMH0E3qEo/+6oKERQT0JKZvmckMUSIi
	se/FO8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOC6f
	Se1gXNlgcYhRgINRiYf3YcKqACHWxLLiytxDjBIczEoivE3lQCHelMTKqtSi/Pii0pzU4kOM
	PkCPTmSWEk3OB6aMvJJ4Q2MTMyNLIzMLIxNzcxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4
	pRoYDY5XvlITkfu9oZ+tV+dVtnHL5H9lSyLKy7nm/v/4sPvdrHf53NdP/eTS0jms+nSiFU+i
	yvv2t4HPSgwkDsW8l4l2MWEIVjh+/d/mPUe7ZtTbxchdKEq/tGiZvg23kvBD48DFf79cvqm0
	eZa1auo2++OF9y0TtXycEu8FHYj5mRsrZaEpcNBViaU4I9FQi7moOBEAfMMCA/gCAAA=
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
index 77833f5..128c811 100644
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
 
@@ -612,16 +620,18 @@ void exynos_sysmmu_set_fault_handler(struct device *dev,
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
@@ -642,25 +652,30 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
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
@@ -672,28 +687,34 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
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
@@ -1049,6 +1070,30 @@ err_dev_put:
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
@@ -1060,9 +1105,14 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
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
@@ -1112,6 +1162,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = __sysmmu_setup(dev, data);
 	if (!ret) {
+		__sysmmu_init_mmuname(dev, data);
+
 		data->runtime_active = !pm_runtime_enabled(dev);
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
-- 
1.8.0


