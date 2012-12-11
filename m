Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2LKLLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:11:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43308 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2LKLLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:11:39 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-41-50c714eaaca0
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Dae Inki'" <inki.dae@samsung.com>, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahun Sharma'" <rahul.sharma@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'SWKim'" <sw0312.kim@samsung.com>
Subject: [PATCH v5 13/14] iommu/exynos: add literal name of System MMU for
 debugging
Date: Tue, 11 Dec 2012 20:11:37 +0900
Message-id: <003d01cdd790$4a245550$de6cfff0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjIVYF7iOezkpSv67L3+bhjm6LAAA78EA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI91XIscDDE6cV7W4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4sOMPU8FKzYp586azNjDuVuxi5OCQEDCR2H+ApYuR
	E8gUk7hwbz1bFyMXh5DAMkaJ6QvmsEEkTCT2PPjMBJFYxCjxbMMGsA4hgX+MEksanEBsNgEt
	idVzjzOC2CICdxklXp7nAWlgFjjCJLHz/jmwBmGBMIm77WvAilgEVCW6P15jAbmCV8BW4s8l
	F5Awr4CgxI/J98DKmYFmrt95nAnClpfYvOYtM8TR6hKP/upCrDKSWLj1JlSJiMS+F++gpgtI
	fJt8iAWiXFZi0wFmkGskBCazS/Q9WccO8ZekxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYIREjtYNxZYPFIUYBDkYlHl4NrWMBQqyJZcWVuYcY
	JTiYlUR4I4WOBwjxpiRWVqUW5ccXleakFh9i9AG6fCKzlGhyPjCa80riDY2NTcxMTE3MLU3N
	TXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgPFv+4l521M5N7QfT523dxPj7erRNoq6w
	Q0/Ssp8H3hy6t1o43Vhw/7GUC2FeJsLXL+WuvDar5IXkTePPLJLus6LUbW0rt7S8EFmvNkuA
	5Xeyjpm40Xd5x9Lz708oFkZN4dsnfemrmrf8Gn4us7Yf+2ou2n9Okdyp9aD618UXLLs3+j2M
	V1nxTomlOCPRUIu5qDgRALsQwSPFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAd1XIscDDD6cl7O4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuLDjD1PBSs2K
	efOmszYw7lbsYuTkkBAwkdjz4DMThC0mceHeerYuRi4OIYFFjBLPNmxgAUkICfxjlFjS4ARi
	swloSayee5wRxBYRuMso8fI8D0gDs8ARJomd98+BNQgLhEncbV8DVsQioCrR/fEaUJyDg1fA
	VuLPJReQMK+AoMSPyffAypmBZq7feZwJwpaX2LzmLTNIuYSAusSjv7oQq4wkFm69CVUiIrHv
	xTvGCYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgin0nt
	YFzZYHGIUYCDUYmHV0PrWIAQa2JZcWXuIUYJDmYlEd5IoeMBQrwpiZVVqUX58UWlOanFhxh9
	gP6cyCwlmpwPTBZ5JfGGxiZmRpZGZhZGJubmOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBK
	NTBqbir8KGDy75GkndVH8bXn8ry+rnvIxn/f47FRkaRo7Ptp8xXcV3Udev1f10ZaatuRnum6
	DD1iiX+XvxVbbvO/neHkiju3bPpPTtyyPejWmgMMwbtiTJxCr+cKyq/eMZtJcY/aqbMbtgmF
	+KjW9h25fy7t6jTHfXdsbO7Mzm3femjFhHCxDaZ6SizFGYmGWsxFxYkAMuqyLvUCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds System MMU name to the driver data of each System
MMU. It is used by fault information.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 72 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 70921e9..9753e0e 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/string.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 
@@ -180,6 +181,7 @@ struct exynos_iommu_domain {
 	short *lv2entcnt; /* free lv2 entry counter for each section */
 	spinlock_t lock; /* lock for this structure */
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
+	const char *fault_info; /* debugging information for fault */
 };
 
 /* exynos_iommu_owner
@@ -224,6 +226,7 @@ struct sysmmu_drvdata {
 	struct iommu_domain *domain;
 	unsigned long pgtable;
 	bool runtime_active;
+	const char **mmuname;
 	void __iomem *sfrbases[0];
 };
 
@@ -601,25 +604,29 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 {
 	/* SYSMMU is in blocked when interrupt occurred. */
 	struct sysmmu_drvdata *data = dev_id;
-	struct resource *irqres;
-	struct platform_device *pdev;
+	struct exynos_iommu_owner *owner = NULL;
 	enum exynos_sysmmu_inttype itype = SYSMMU_FAULT_UNKNOWN;
 	unsigned long addr = -1;
-
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
 
-	if (i < pdev->num_resources) {
+	if (i < data->nsfrs) {
 		itype = (enum exynos_sysmmu_inttype)
 			__ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
 		if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
@@ -629,11 +636,17 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 				data->sfrbases[i] + fault_reg_offset[itype]);
 	}
 
-	if (data->domain)
+	if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
+		itype = SYSMMU_FAULT_UNKNOWN;
+
+	if (data->domain) {
+		struct exynos_iommu_domain *priv = data->domain->priv;
+		priv->fault_info = data->mmuname[i];
 		ret = report_iommu_fault(data->domain,
 					data->master, addr, itype);
-	else
+	} else {
 		__show_fault_information(__va(data->pgtable), itype, addr);
+	}
 
 	if (ret == -ENOSYS)
 		pr_err("NO SYSTEM MMU FAULT HANDLER REGISTERED FOR %s\n",
@@ -651,7 +664,8 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
 
 	sysmmu_unblock(data->sfrbases[i]);
 
-	spin_unlock(&data->lock);
+	if (owner)
+		spin_unlock(&owner->lock);
 
 	return IRQ_HANDLED;
 }
@@ -1028,6 +1042,30 @@ err_dev_put:
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
@@ -1039,9 +1077,14 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
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
@@ -1084,6 +1127,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = __sysmmu_setup(dev, data);
 	if (!ret) {
+		__sysmmu_init_mmuname(dev, data);
+
 		data->sysmmu = dev;
 		spin_lock_init(&data->lock);
 
@@ -1211,7 +1256,8 @@ static int exynos_iommu_fault_handler(struct iommu_domain *domain,
 {
 	struct exynos_iommu_domain *priv = domain->priv;
 
-	dev_err(dev, "System MMU Generated FAULT!\n\n");
+	dev_err(dev, "System MMU '%s' Generated FAULT!\n\n",
+				priv->fault_info ?  priv->fault_info : "");
 	__show_fault_information(priv->pgtable, iova, flags);
 
 	return -ENOSYS;
-- 
1.8.0


