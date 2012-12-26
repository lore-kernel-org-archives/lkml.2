Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2LZBzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:55:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37982 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2LZByW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:54:22 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b1-50da58cd2dd7
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
Subject: [PATCH v6 10/12] iommu/exynos: pass version information from DT
Date: Wed, 26 Dec 2012 10:54:21 +0900
Message-id: <003d01cde30b$ec6f3970$c54dac50$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3jC+w0gI3tcmKiQNmMYr+YxFluXw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI92zEbcCDBYeNbS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo4P+cRc8FckYoVpzIaGJcKdDFyckgImEic/7GLDcIW
	k7hwbz2QzcUhJLCMUWLa7N9sMEUvetcwg9hCAtMZJRYfF4Uo+scocbB9IxNIgk1AS2L13OOM
	ILaIwF1GiZfneUCKmAX+Mkp8OnOIHSQhLOAh8WHDRrCpLAKqEp9XzAGbyitgKzH/9Sc2CFtQ
	4sfkeywgNrOAgcT7WX2sELa8xOY1b4HqOYAuUpd49FcXxBQR0JM42cgGUSEise/FO0aI6QIS
	3yYfYoGolpXYdIAZ4pV+dom7z9whbEmJgytusExgFJuFZO8sJHtnIdk7C8mGBYwsqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzFC4kVqB+PKBotDjAIcjEo8vBu/3wwQYk0sK67MPcQowcGs
	JMLr/BEoxJuSWFmVWpQfX1Sak1p8iNEH6PCJzFKiyfnAWM4riTc0NjYxMzE1Mbc0NTfFIawk
	ztvskRIgJJCeWJKanZpakFoEM46Jg1OqgXGOpsnBtyx7SybWp3DvuFTk+KecWTqNc/bmz+Hh
	n1SzdK7duln+e/G6nFsBSY59nlPXzJ+db6MTnWW3/rzVXkNx5ZKutleON6496vSeofHlVv7V
	TarTj6qHTneenmQ1uSJo1stzG93P6Rhs5Lrd26prWcVcLeCw46z91Ev27dZJT2dlOvfaL1Vi
	Kc5INNRiLipOBADtR3JexAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQd2zEbcCDA5+0LS4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOD/nEXPBXJGK
	FacyGhiXCnQxcnJICJhIvOhdwwxhi0lcuLeeDcQWEpjOKLH4uGgXIxeQ/Y9R4mD7RiaQBJuA
	lsTquccZQWwRgbuMEi/P84AUMQv8ZZT4dOYQO0hCWMBD4sOGjWCTWARUJT6vmAO2gVfAVmL+
	609sELagxI/J91hAbGYBA4n3s/pYIWx5ic1r3gLVcwBdpC7x6K8uiCkioCdxspENokJEYt+L
	d4wTGAVmIRk0C8mgWUgGzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDw+k9rB
	uLLB4hCjAAejEg/vxu83A4RYE8uKK3MPMUpwMCuJ8Dp/BArxpiRWVqUW5ccXleakFh9i9AH6
	cyKzlGhyPjBV5JXEGxqbmBlZGplZGJmYm+MQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TBKdXA
	OHmO4RGxBxc/vqyr1VNrMvXfpOHiz99dMM9180yPDbYNWbM3xl3/LvpTZkPNHn6lqMMf83ZE
	1eYJnLnWaMVw+kB9/eXc2dv1l4v8Pv41I+OA/aSP7ptF7qmts53jKCHWmPYpePbedzMcrbue
	3TVRDH/9Q+BtuGy66X1tDov/EwLUFXW5PvxhUmIpzkg01GIuKk4EALDaD0v0AgAA
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


