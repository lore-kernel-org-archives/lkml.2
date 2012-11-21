Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab2KUFFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 00:05:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47401 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2KUFFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 00:05:22 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-8e-50ac6111eb15
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v3 05/12] iommu/exynos: pass version information from DT
Date: Wed, 21 Nov 2012 14:05:20 +0900
Message-id: <002c01cdc7a5$ce618040$6b2480c0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Hpc28cfxaSKQETauE9W9K9QVIxA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zI13BxDUBBi+PCVlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUseLuPqaBTruJ173SmBsaNEl2MnBwSAiYST5e+ZYOw
	xSQu3FsPZHNxCAksY5Q4v/MvO0zRyUPLmCAS0xkl/rfNYoFw/jFKXH91hxmkik1AS2L13OOM
	IAkRgV5GiQv9X8FamAV+MEosfvMGrEpYwEPi5tp7LCA2i4CqxJ8Z+1lBbF4BW4lLz75A2YIS
	PyZD1DADTV2/8zgThC0vsXnNW6A5HEA3qUs8+qsLEhYR0JNovrGNHaJERGLfi3eMEOMFJL5N
	PsQCUS4rsekAM8g5EgKT2SWmb/zNCPGapMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUCRpZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGRI7WDcWWDxSFGAQ5GJR7ejWtXBwixJpYVV+YeYpTg
	YFYS4WWQXxMgxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnAqM4riTc0NjYxMzE1Mbc0NTfF
	IawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgTHogu3neTuL7SVPeRvOKHZ5KMzvGOx7x7Te
	rn7216uxol83Xlwh+UzmzJ6kWs6q2b86fj/NmO8Weye+gW9j7bxnktyz/dL6DbU/Twxd/Kdg
	epDiE0PB3mf7zrOs87Pvc3HaIt9rvT8nKvGAXKHp/2VcPuGfgtqstNyMu4rDXOKnSxxoEPb+
	ocRSnJFoqMVcVJwIADbn6fPJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQV3BxDUBBsde81pc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmLHi7j6mgU67i
	de90pgbGjRJdjJwcEgImEicPLWOCsMUkLtxbz9bFyMUhJDCdUeJ/2ywWCOcfo8T1V3eYQarY
	BLQkVs89zgiSEBHoZZS40P+VCcRhFvjBKLH4zRuwKmEBD4mba++xgNgsAqoSf2bsZwWxeQVs
	JS49+wJlC0r8mAxRwww0df3O40wQtrzE5jVvgeZwAN2kLvHory5IWERAT6L5xjZ2iBIRiX0v
	3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwXH5TGoH
	48oGi0OMAhyMSjy8G9euDhBiTSwrrsw9xCjBwawkwssgvyZAiDclsbIqtSg/vqg0J7X4EKMP
	0KMTmaVEk/OBKSOvJN7Q2MTMyNLIzMLIxNwch7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6p
	BsaL16R+LpvUpn+ZL1Cn9sWnsGCx8pAcs2efmvPP/T/st/BO2oTGNTXLv/BFC1+MUH2u6Wv4
	Y4Hr6+dOnn/m/Ky44Hc0hM37Duu7pzycAja3fny7+v772Q3fC36Kq5n4ZGtZSzyeriQqcM1m
	JVdjgdmTjPkvbjU9LN/y34xx6jf2R/nr1zz6epZfiaU4I9FQi7moOBEA2keQj/gCAAA=
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

Change-Id: I944e7a8f1402fdc0cb3ea45414a77b7079c8c84c
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


