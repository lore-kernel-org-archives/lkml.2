Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab2KVTpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:45:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32643 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab2KVTo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:44:57 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a0-50ae0d75ccc4
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 05/12] iommu/exynos: pass version information from DT
Date: Thu, 22 Nov 2012 20:33:08 +0900
Message-id: <002601cdc8a5$25a287a0$70e796e0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpSWFWDWKBeisSVWyROUxJyZikg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI91S3nUBBnfWCFtc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWcn/iKseCybMX7BRuZGxj/iXcxcnBICJhIXJ+i38XI
	CWSKSVy4t56ti5GLQ0hgGaPEhgevmSESJhIbrq1kh0gsYpQ4/HoXC4Tzj1HidutcJpAqNgEt
	idVzjzOCJEQEehklLvR/ZQJxmAV+MEpM3/yLBaRKWMBD4sKZbWBzWQRUJY7+3c4OYvMK2Eqs
	nf+LDcIWlPgx+R5YPTPQ1PU7jzNB2PISm9e8ZYa4W13i0V9dEFNEQE+ibSYvRIWIxL4X7xgh
	pgtIfJt8iAWiWlZi0wFmkGskBCazS/w7eYEF4jNJiYMrbrBMYBSbhWTxLCSLZyFZPAvJigWM
	LKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxQqJGegfjqgaLQ4wCHIxKPLwZBmsDhFgTy4or
	cw8xSnAwK4nw3uNeFyDEm5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cCIziuJNzQ2NjEzMTUx
	tzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0T5n5Y7lC9SfCaq+tn968q/48lmt
	CqJLN00unP0t7NzjlW67+5PX/VB5zTOzt2RCoteFK6H3pcU6dKO3HO+7PPH0jVPB2zMFCu88
	eu2Sbv9bs9P9a421cqWpGRe377/TDh1Jds0Tlhqkn11cyLFWZG/Iv8oz/0JP7WHlaNdM/jVN
	TbtokYTHASWW4oxEQy3mouJEAGuBC8vHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd1S3nUBBkdb+Swu75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzzk98xVhwWbbi
	/YKNzA2M/8S7GDk5JARMJDZcW8kOYYtJXLi3nq2LkYtDSGARo8Th17tYIJx/jBK3W+cygVSx
	CWhJrJ57nBEkISLQyyhxof8rE4jDLPCDUWL65l8sIFXCAh4SF85sYwaxWQRUJY7+3Q62g1fA
	VmLt/F9sELagxI/J98DqmYGmrt95nAnClpfYvOYtUC8H0E3qEo/+6oKYIgJ6Em0zeSEqRCT2
	vXjHOIFRYBaSQbOQDJqFZNAsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH5TPp
	HYyrGiwOMQpwMCrx8GYYrA0QYk0sK67MPcQowcGsJMJ7j3tdgBBvSmJlVWpRfnxRaU5q8SFG
	H6A/JzJLiSbnAxNGXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTByc
	Ug2Mfd97VzqeWGe1VVU8xn1qpPeKZTuPZspV7rQ4efzaMtZWzSLJW7eXbK0sePL+DnvQnVV7
	Rfx+P7iesv2Dzd+VShtm3vxco+bFe17R+xbzw171RauzQxds479/+Y1v98kNarE7rxdOSE8T
	qCo8Uvt6kcfn9J6PlY8WR8iUfL5+5eMUAeakB9qZVUosxRmJhlrMRcWJADG1UD33AgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System MMUs in some implementation of Exynos core does not include
correct version information in the System MMU. If the version
information is not correct, exynos-iommu driver cannot take advantages
of feature of higher versions of System MMu like prefetching page
table entries prior to TLB miss.

This commit allows passing version information from DT to the driver.
If DT does not pass version information, the driver will read the
information from System MMU.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 53972c8..4061b17 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -96,6 +96,9 @@
 
 #define REG_MMU_VERSION		0x034
 
+#define MMU_MAJ_VER(reg)	(reg >> 28)
+#define MMU_MIN_VER(reg)	((reg >> 21) & 0x7F)
+
 #define REG_PB0_SADDR		0x04C
 #define REG_PB0_EADDR		0x050
 #define REG_PB1_SADDR		0x054
@@ -165,6 +168,12 @@ struct exynos_iommu_domain {
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
 };
 
+struct sysmmu_version {
+	unsigned char major; /* major = 0 means that driver must use MMU_VERSION
+				register instead of this structure */
+	unsigned char minor;
+};
+
 struct sysmmu_drvdata {
 	struct list_head node; /* entry of exynos_iommu_domain.clients */
 	struct device *sysmmu;	/* System MMU's device descriptor */
@@ -172,6 +181,7 @@ struct sysmmu_drvdata {
 	int nsfrs;
 	struct clk *clk;
 	int activations;
+	struct sysmmu_version ver;
 	rwlock_t lock;
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
@@ -198,6 +208,25 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
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
@@ -262,7 +291,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
 		goto finish;
 
 	for (i = 0; i < data->nsfrs; i++) {
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
+		if (__sysmmu_version(data, i, NULL) == 3) {
 			if (!sysmmu_block(data->sfrbases[i]))
 				continue;
 
@@ -460,7 +489,7 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	for (i = 0; i < data->nsfrs; i++) {
 		__sysmmu_set_ptbase(data->sfrbases[i], pgtable);
 
-		if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
+		if (__sysmmu_version(data, i, NULL)  == 3) {
 			/* System MMU version is 3.x */
 			__raw_writel((1 << 12) | (2 << 28),
 					data->sfrbases[i] + REG_MMU_CFG);
@@ -618,8 +647,15 @@ static int __init __sysmmu_setup(struct device *sysmmu,
 	const char *compat;
 	struct platform_device *pmaster = NULL;
 	u32 master_inst_no = -1;
+	u32 ver[2];
 	int ret;
 
+	if (!of_property_read_u32_array(sysmmu->of_node, "version", ver, 2)) {
+		drvdata->ver.major = (unsigned char)ver[0];
+		drvdata->ver.minor = (unsigned char)ver[1];
+		dev_dbg(sysmmu, "Found version %d.%d\n", ver[0], ver[1]);
+	}
+
 	master_node = of_parse_phandle(sysmmu->of_node, "mmu-master", 0);
 	if (!master_node && !of_property_read_string(
 			sysmmu->of_node, "mmu-master-compat", &compat)) {
-- 
1.8.0


