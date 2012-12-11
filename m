Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2LKLLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:11:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43273 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2LKLL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:11:26 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-13-50c714dd8268
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
Subject: [PATCH v5 12/14] iommu/exynos: pass version information from DT
Date: Tue, 11 Dec 2012 20:11:25 +0900
Message-id: <003c01cdd790$42657420$c7305c60$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3XjIMZD1U0VtVYTduNBrj2cTSKFQAA7nTw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ927IscDDC4uV7O4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo4P+cRc8FckYoVpzIaGJcKdDFyckgImEh83fGdHcIW
	k7hwbz1bFyMXh5DAMkaJF03vWWGK2l7cYYVILGKU+P5qFxOE8w/IufWQEaSKTUBLYvXc42C2
	iMBdRomX53lAipgFjjBJ7Lx/jqWLkYNDWMBDYvJhCxCTRUBVYvqMApByXgFbiSdLp7NA2IIS
	PybfA7OZgUau33mcCcKWl9i85i0zSKuEgLrEo7+6EJuMJHb2tzFClIhI7HvxDsxmERCQ+Db5
	EAtEuazEpgPMIMdICPSzS6x4upsR4i9JiYMrbrBMYBSbhWTzLCSbZyHZPAvJigWMLKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxQiJGagfjygaLQ4wCHIxKPLwaWscChFgTy4orcw8xSnAw
	K4nwRgodDxDiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHkfGA055XEGxobm5iZmJqYW5qam+IQ
	VhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXAyFPF/FC1zOuGU1NbyqwwBbsLWsJ3Nr948P9g
	V3BGxcS87C0PZthN27/cbY5dU+RzVZ7YSSayOjtvtN2I3cdtcPZnd+A01SsSUyzmd0yUbJ++
	JKpz5qkdYh8fGXy4+PpQSinbjyX8f7zePJtVx2i3+7T0DIsg9eRu4Xg5rZ/mVxYrOy76dnRV
	nhJLcUaioRZzUXEiAPdsWyXFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAd27IscDDFY+kbO4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOD/nEXPBXJGK
	FacyGhiXCnQxcnJICJhItL24wwphi0lcuLeerYuRi0NIYBGjxPdXu5ggnH9Azq2HjCBVbAJa
	EqvnHgezRQTuMkq8PM8DUsQscIRJYuf9cyxdjBwcwgIeEpMPW4CYLAKqEtNnFICU8wrYSjxZ
	Op0FwhaU+DH5HpjNDDRy/c7jTBC2vMTmNW+ZQVolBNQlHv3VhdhkJLGzv40RokREYt+Ld4wT
	GAVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDw+k9rBuLLB
	4hCjAAejEg+vhtaxACHWxLLiytxDjBIczEoivJFCxwOEeFMSK6tSi/Lji0pzUosPMfoA/TmR
	WUo0OR+YKvJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYGyZ
	z3MlctfHD5JeSm3v16veqEsQNN09Lzo6SHHim5hqe5b/pnMObf67YsKxHWEFi54nqJ1+YyXO
	WHX6MS9HBOODryo5HxIvHzX71OtbYmCae2nb5fMsYg0Tns1SNRd5ufNP7XO1e89XiOT2naxf
	ee6bbNPWhlP31eI5VF7au2Zdb1vCu3uf80UlluKMREMt5qLiRAALoOcw9AIAAA==
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
 drivers/iommu/exynos-iommu.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index a558c51..70921e9 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -205,6 +205,12 @@ struct sysmmu_prefbuf {
 	unsigned long config;
 };
 
+struct sysmmu_version {
+	unsigned char major; /* major = 0 means that driver must use MMU_VERSION
+				register instead of this structure */
+	unsigned char minor;
+};
+
 struct sysmmu_drvdata {
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *master;	/* Client device that needs System MMU */
@@ -214,6 +220,7 @@ struct sysmmu_drvdata {
 	spinlock_t lock;
 	struct sysmmu_prefbuf pbufs[MAX_NUM_PBUF];
 	int num_pbufs;
+	struct sysmmu_version ver;
 	struct iommu_domain *domain;
 	unsigned long pgtable;
 	bool runtime_active;
@@ -246,6 +253,20 @@ static unsigned int __sysmmu_version(struct sysmmu_drvdata *drvdata,
 
 	major = readl(drvdata->sfrbases[idx] + REG_MMU_VERSION);
 
+	if ((MMU_MAJ_VER(major) == 0) || (MMU_MAJ_VER(major) > 3)) {
+		/* register MMU_VERSION is used for special purpose */
+		if (drvdata->ver.major == 0) {
+			/* min ver. is not important for System MMU 1 and 2 */
+			major = 1;
+		} else {
+			if (minor)
+				*minor = drvdata->ver.minor;
+			major = drvdata->ver.major;
+		}
+
+		return major;
+	}
+
 	if (minor)
 		*minor = MMU_MIN_VER(major);
 
@@ -933,8 +954,15 @@ static int __init __sysmmu_setup(struct device *sysmmu,
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
 	drvdata->pbufs[0].base = 0;
 	drvdata->pbufs[0].size = ~0;
 	drvdata->num_pbufs = 1;
-- 
1.8.0


