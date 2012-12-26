Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2LZByd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:54:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37990 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2LZBy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:54:28 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c7-50da58d2a44c
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>
Subject: [PATCH v6 11/12] iommu/exynos: add literal name of System MMU for
 debugging
Date: Wed, 26 Dec 2012 10:54:26 +0900
Message-id: <003e01cde30b$ef82bb00$ce883100$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC+9VPiB0na4IQwKl/fER3uj6lw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI91LEbcCDP5ssrS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4sOMPU8FKzYp586azNjDuVuxi5OCQEDCR6DrA3sXI
	CWSKSVy4t56ti5GLQ0hgGaPEp87JzBAJE4kXZ9exgNhCAosYJVo+KUPY/xglmj6KgNhsAloS
	q+ceZwSxRQTuMkq8PM8DMohZ4C/QoDOHwDYIC4RJ/F56nx1kMYuAqsSS+VYgYV4BW4npL7cz
	QtiCEj8m3wPbxSxgIPF+Vh8rhC0vsXnNW2aIm9UlHv3VhVilJ7FrSidUuYjEvhfvwMawCAhI
	fJt8iAWiXFZi0wFmkGskBPrZJZ5uPssG8ZakxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYIfEitYNxZYPFIUYBDkYlHt6N328GCLEmlhVX5h5i
	lOBgVhLhdf4IFOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YCznlcQbGhubmJmYmphbmpqb
	4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cDY9cGbe97Vi0cZesJ8Q88pn8q9lth8JMrE
	v///132VAulKTlviPTvb66NMT6WbCp3e2Nm5vLTsitm5avbE7W92zS6Yopkwpd9ZO0YgTfbA
	jJ4bbzarLvX41XR1xfWYcw/v6AZM/3WxMOhuS6Hwqq3ND6cYTTo5xeiagV/qT1H/wGeHq49v
	ufNGiaU4I9FQi7moOBEA4tpEwMQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd1LEbcCDGYcNrK4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuLDjD1PBSs2K
	efOmszYw7lbsYuTkkBAwkXhxdh0LhC0mceHeejYQW0hgEaNEyydlCPsfo0TTRxEQm01AS2L1
	3OOMILaIwF1GiZfneboYuTiYBf4ySnw6c4gdJCEsECbxe+l9IJuDg0VAVWLJfCuQMK+ArcT0
	l9sZIWxBiR+T74HtZRYwkHg/q48VwpaX2LzmLTNIq4SAusSjv7oQq/Qkdk3phCoXkdj34h3j
	BEaBWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyPz6R2MK5s
	sDjEKMDBqMTDu/H7zQAh1sSy4srcQ4wSHMxKIrzOH4FCvCmJlVWpRfnxRaU5qcWHGH2A/pzI
	LCWanA9MFXkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1KzU1MLUotgxjFxcEo1MDqf
	2rtmRd3fL+7Xo72mXUiJtLu1If+9U17dijqpD7lNaYmfbBJjb5SsDU69eyFUKnHegYVqG3Ou
	Tb0z94FTtOTlE03HvTaH9c+Km8vOKcLb1vrCe++C+Bybuzf+br+wNDs840z6pROLmXdGaN1q
	6zkckrvBM+n1a70js3ZMuGIgd+3Hv5fLJEuUWIozEg21mIuKEwHBzM269AIAAA==
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


