Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2KTHa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:30:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21028 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2KTHaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:22 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e7-50ab318d14ba
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v2 05/12] iommu/exynos: pass version information from DT
Date: Tue, 20 Nov 2012 16:30:20 +0900
Message-id: <001f01cdc6f0$e5b2bf80$b1183e80$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3G8OV1UpEPD/dGQlygnrfyCUZAgA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI91ew9UBBi+mS1pc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcXpBccFm24vhN3gbGf+JdjJwcEgImEn+3d7NA2GIS
	F+6tZwOxhQSWMUpMmJsCU7Pu1BJ2iPh0Romnp1W6GLmA7H+MEu9evQJrZhPQklg99zgjSEJE
	oJdR4kL/VyYQh1ngB6PE4jdvmEGqhAU8JKYdmc4IYrMIqEp8mPCHCcTmFbCVmHaplxHCFpT4
	Mfke2FRmoKnrdx5ngrDlJTaveQs0hwPoJHWJR391QcIiAnoSx09OhCoRkdj34h3UeAGJb5MP
	sUCUy0psOsAMco6EQD+7xK72DkaIzyQlDq64wTKBUWwWks2zkGyehWTzLCQrFjCyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIiRjpHYyrGiwOMQpwMCrx8D5MWBUgxJpYVlyZe4hRgoNZ
	SYS3qRwoxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnAaM4riTc0NjYxMzE1Mbc0NTfFIawk
	ztvskRIgJJCeWJKanZpakFoEM46Jg1OqgVHLkKvQtzvib1dhcSH7bevGwrMiO+3nbNefaPEq
	cNaXvtNJF3cw1u9fPUd2aajWuf9VSjwxVmL3mg1PPusWeRcasND29clt8wrO7Nn44snTkxuS
	frBdzL5w3GwKp21wgny6BtOquEyrfT7alsmaCgd1i0771jL+5+15kXi87bf55y96yXn+W5RY
	ijMSDbWYi4oTATDBwnTFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQd1ew9UBBn//ilhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3F6QXHBZtuL4
	Td4Gxn/iXYycHBICJhLrTi1hh7DFJC7cW88GYgsJTGeUeHpapYuRC8j+xyjx7tUrFpAEm4CW
	xOq5xxlBEiICvYwSF/q/MoE4zAI/GCUWv3nDDFIlLOAhMe3IdEYQm0VAVeLDhD9MIDavgK3E
	tEu9jBC2oMSPyffApjIDTV2/8zgThC0vsXnNW6A5HEAnqUs8+qsLEhYR0JM4fnIiVImIxL4X
	7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Ih8Jr2D
	cVWDxSFGAQ5GJR7ehwmrAoRYE8uKK3MPMUpwMCuJ8DaVA4V4UxIrq1KL8uOLSnNSiw8x+gA9
	OpFZSjQ5H5gs8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg
	ND486/uijYvexLw8Zj9jxtbirA8KEiY3Ht29EMjddslN9Lm754Xwra+32r090Sn7+cFFc+5K
	/yvrKho6ttrca7l8d+Ib5jC2/oMp+jv7/iVpMH8x4yuPe2BzcNa55LVPAnY7vA2OO3xuYn9g
	ip5nVUrJMSvR+sVla0KuHbqRq7I04QG/ufL7A0osxRmJhlrMRcWJAOjMGgb1AgAA
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
index 8cffeff..b939b6e 100644
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


