Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2KVURe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:17:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59549 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2KVTpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:45:46 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-44-50ae0d91cf1e
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 10/12] iommu/exynos: add support for System MMU 3.2 and 3.3
Date: Thu, 22 Nov 2012 20:33:37 +0900
Message-id: <002b01cdc8a5$368c8430$a3a58c90$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpTZr/7iJo290SUiw9C4S548cyA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zfd2JvOsCDE6+07W4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4t8OooCGroqXbsIHxc3AXIyeHhICJxIebU9kgbDGJ
	C/fWA9lcHEICyxglts+9ygJTdKXxIgtEYjqjxKQ3D8A6hAT+MUq8m8ULYrMJaEmsnnucEaRI
	RKCXUeJC/1cmEIdZ4AejxPTNv4DaOTiEBfwk2s5UgzSwCKhKtBw7BLaBV8BWYkVbEyuELSjx
	Y/I9sDgz0ND1O48zQdjyEpvXvGUGGSMhoC7x6K8uiCkioCdx7IgsRIWIxL4X7xghpgtIfJt8
	iAWiWlZi0wFmkGMkBPrZJSYvXgb1l6TEwRU3WCYwis1CsngWksWzkCyehWTFAkaWVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxgh8SK1g3Flg8UhRgEORiUeXk3ntQFCrIllxZW5hxglOJiV
	RHjvca8LEOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YCznlcQbGhubmJmYmphbmpqb4hBW
	Eudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cCYnS/1zfyz1K8tN09dXHrfcsaKFDM3098P+jMX
	J93sTbi40r3hfbfZ6UTRrUv7qm1ndGZy7PnPcP7vW+W6+2cDt586/58j86yV2JMmveT/UTN6
	Iu5KzNn583FJ7/FU60kLRBKP8X6Sk2XKb2PcP+t8ZVdxyN7F5mq2T0OUQ/4KHXwqvE7Knf+z
	EktxRqKhFnNRcSIArlMZv8QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd2JvOsCDL42aFpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm/NthVNCQVdHS
	bdjA+Dm4i5GTQ0LAROJK40UWCFtM4sK99WxdjFwcQgLTGSUmvXnABpIQEvjHKPFuFi+IzSag
	JbF67nFGkCIRgV5GiQv9X5lAHGaBH4wS0zf/AhrFwSEs4CfRdqYapIFFQFWi5dghsA28ArYS
	K9qaWCFsQYkfk++BxZmBhq7feZwJwpaX2LzmLTPIGAkBdYlHf3VBTBEBPYljR2QhKkQk9r14
	xziBUWAWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER+MzqR2M
	KxssDjEKcDAq8fBqOq8NEGJNLCuuzD3EKMHBrCTCe497XYAQb0piZVVqUX58UWlOavEhRh+g
	PycyS4km5wMTRV5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFIN
	jEZ/9VU9fv85sHSlX9iCY7I/+4PuSKsmrq41iVsolH3MdE7Y+qy9OScCHxYHHHLY9FK4sq/2
	TPEeLYXvl7nqhdbKee7n3h0YJSvN7LCtduHyLJMSpdRombO/eFzMlVOeWKf45Zed4rQIPbK2
	/9u9/PQ/YW/OX/l1t5+7NXWFiLapigJb1pqVSizFGYmGWsxFxYkAWH/E/vMCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since System MMU 3.2 and 3.3 have more prefetch buffers than 2, the
existing function to set prefetch buffers, exynos_sysmmu_set_prefbuf()
is not able to support them.
This commit removes exynos_sysmmu_set_prefbuf() and introduces new
interface, exynos_sysmmu_set_pbuf() that can pass information of
more buffers than 2. It is safe to remove the existing function
because there is no device driver in the kernel yet that calls the
removed function.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 336 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 290 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index c2525ed..985d317 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -80,6 +80,13 @@
 #define CTRL_BLOCK	0x7
 #define CTRL_DISABLE	0x0
 
+#define CFG_LRU		0x1
+#define CFG_QOS(n)	((n & 0xF) << 7)
+#define CFG_MASK	0x0050FFFF /* Selecting bit 0-15, 20, 22 */
+#define CFG_SYSSEL	(1 << 22) /* System MMU 3.2 only */
+#define CFG_FLPDCACHE	(1 << 20) /* System MMU 3.2+ only */
+#define CFG_SHAREABLE	(1 << 12) /* System MMU 3.x only */
+
 #define REG_MMU_CTRL		0x000
 #define REG_MMU_CFG		0x004
 #define REG_MMU_STATUS		0x008
@@ -88,6 +95,10 @@
 #define REG_PT_BASE_ADDR	0x014
 #define REG_INT_STATUS		0x018
 #define REG_INT_CLEAR		0x01C
+#define REG_PB_INFO		0x400
+#define REG_PB_LMM		0x404
+#define REG_PB_INDICATE		0x408
+#define REG_PB_CFG		0x40C
 
 #define REG_PAGE_FAULT_ADDR	0x024
 #define REG_AW_FAULT_ADDR	0x028
@@ -99,10 +110,9 @@
 #define MMU_MAJ_VER(reg)	(reg >> 28)
 #define MMU_MIN_VER(reg)	((reg >> 21) & 0x7F)
 
-#define REG_PB0_SADDR		0x04C
-#define REG_PB0_EADDR		0x050
-#define REG_PB1_SADDR		0x054
-#define REG_PB1_EADDR		0x058
+#define MAX_NUM_PBUF		6
+
+#define NUM_MINOR_OF_SYSMMU_V3	4
 
 static void *sysmmu_placeholder; /* Inidcate if a device is System MMU */
 
@@ -197,6 +207,19 @@ struct sysmmu_version {
 	unsigned char minor;
 };
 
+#define SYSMMU_PBUFCFG_TLB_UPDATE	(1 << 16)
+#define SYSMMU_PBUFCFG_ASCENDING	(1 << 12)
+#define SYSMMU_PBUFCFG_DSECENDING	(0 << 12) /* default */
+#define SYSMMU_PBUFCFG_PREFETCH		(1 << 8)
+#define SYSMMU_PBUFCFG_WRITE		(1 << 4)
+#define SYSMMU_PBUFCFG_READ		(0 << 4) /* default */
+
+struct sysmmu_prefbuf {
+	unsigned long base;
+	unsigned long size;
+	unsigned long config;
+};
+
 struct sysmmu_drvdata {
 	struct device *sysmmu;	/* System MMU's device descriptor */
 	struct device *master;	/* Client device that needs System MMU */
@@ -205,6 +228,8 @@ struct sysmmu_drvdata {
 	int activations;
 	struct sysmmu_version ver;
 	spinlock_t lock;
+	struct sysmmu_prefbuf pbufs[MAX_NUM_PBUF];
+	int num_pbufs;
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
@@ -291,59 +316,277 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 	__sysmmu_tlb_invalidate(sfrbase);
 }
 
-static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
-						unsigned long size, int idx)
+static void __sysmmu_set_prefbuf(void __iomem *pbufbase, unsigned long base,
+					unsigned long size, int idx)
+{
+	__raw_writel(base, pbufbase + idx * 8);
+	__raw_writel(size - 1 + base,  pbufbase + 4 + idx * 8);
+}
+
+/*
+ * Offset of prefetch buffer setting registers are different
+ * between SysMMU 3.1 and 3.2. 3.3 has a single prefetch buffer setting.
+ */
+static unsigned short
+	pbuf_offset[NUM_MINOR_OF_SYSMMU_V3] = {0x04C, 0x04C, 0x070, 0x410};
+
+/**
+ * __sysmmu_sort_prefbuf - sort the given @prefbuf in descending order.
+ * @prefbuf: array of buffer information
+ * @nbufs: number of elements of @prefbuf
+ * @check_size: whether to compare buffer sizes. See below description.
+ *
+ * return value is valid if @check_size is ture. If the size of first buffer
+ * in @prefbuf is larger than or equal to the sum of the sizes of the other
+ * buffers, returns 1. If the size of the first buffer is smaller than the
+ * sum of other sizes, returns -1. Returns 0, otherwise.
+ */
+static int __sysmmu_sort_prefbuf(struct sysmmu_prefbuf prefbuf[],
+						int nbufs, bool check_size)
+{
+	int i;
+
+	for (i = 0; i < nbufs; i++) {
+		int j;
+		for (j = i + 1; j < nbufs; j++)
+			if (prefbuf[i].size < prefbuf[j].size)
+				swap(prefbuf[i], prefbuf[j]);
+	}
+
+	if (check_size) {
+		unsigned long sum = 0;
+		for (i = 1; i < nbufs; i++)
+			sum += prefbuf[i].size;
+
+		if (prefbuf[0].size < sum)
+			i = -1;
+		else if (prefbuf[0].size >= (sum * 2))
+			i = 1;
+		else
+			i = 0;
+	}
+
+	return i;
+}
+
+static void __exynos_sysmmu_set_pbuf_ver31(struct sysmmu_drvdata *drvdata,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
 {
-	__raw_writel(base, sfrbase + REG_PB0_SADDR + idx * 8);
-	__raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
+	unsigned long cfg =
+		__raw_readl(drvdata->sfrbases[idx] + REG_MMU_CFG) & CFG_MASK;
+
+	if (nbufs > 1) {
+		unsigned long base = prefbuf[1].base;
+		unsigned long end = prefbuf[1].base + prefbuf[1].size;
+
+		/* merging buffers from the second to the last */
+		while (nbufs-- > 2) {
+			base = min(base, prefbuf[nbufs - 1].base);
+			end = max(end, prefbuf[nbufs - 1].base +
+					prefbuf[nbufs - 1].size);
+		}
+
+		/* Separate PB mode */
+		cfg |= 2 << 28;
+
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[1],
+					base, end - base, 1);
+
+		drvdata->num_pbufs = 2;
+		drvdata->pbufs[0] = prefbuf[0];
+		drvdata->pbufs[1] = prefbuf[1];
+
+	} else {
+		/* Combined PB mode */
+		cfg |= 3 << 28;
+		drvdata->num_pbufs = 1;
+		drvdata->pbufs[0] = prefbuf[0];
+	}
+
+	__raw_writel(cfg, drvdata->sfrbases[idx] + REG_MMU_CFG);
+
+	__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[1],
+				prefbuf[0].base, prefbuf[0].size, 0);
 }
 
-void exynos_sysmmu_set_prefbuf(struct device *dev,
-				unsigned long base0, unsigned long size0,
-				unsigned long base1, unsigned long size1)
+static void __exynos_sysmmu_set_pbuf_ver32(struct sysmmu_drvdata *drvdata,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
+{
+	int i;
+	unsigned long cfg =
+		__raw_readl(drvdata->sfrbases[idx] + REG_MMU_CFG) & CFG_MASK;
+
+	cfg |= 7 << 16; /* enabling PB0 ~ PB2 */
+
+	/* This is common to all cases below */
+	drvdata->pbufs[0] = prefbuf[0];
+
+	switch (nbufs) {
+	case 1:
+		/* Combined PB mode (0 ~ 2) */
+		cfg |= 1 << 19;
+		drvdata->num_pbufs = 1;
+		break;
+	case 2:
+		/* Combined PB mode (0 ~ 1) */
+		cfg |= 1 << 21;
+		drvdata->num_pbufs = 2;
+		drvdata->pbufs[1] = prefbuf[1];
+		break;
+	case 3:
+		drvdata->num_pbufs = 3;
+		drvdata->pbufs[1] = prefbuf[1];
+		drvdata->pbufs[2] = prefbuf[2];
+
+		__sysmmu_sort_prefbuf(drvdata->pbufs, 3, false);
+		swap(drvdata->pbufs[0], drvdata->pbufs[2]);
+
+		break;
+	default:
+		drvdata->pbufs[2].base = prefbuf[2].base;
+		/* drvdata->size is used for end address temporarily */
+		drvdata->pbufs[2].size = prefbuf[2].base + prefbuf[2].size;
+
+		/* Merging all buffers from the third to the last */
+		while (nbufs-- > 3) {
+			drvdata->pbufs[2].base = min(drvdata->pbufs[2].base,
+						prefbuf[nbufs - 1].base);
+			drvdata->pbufs[2].size = max(drvdata->pbufs[2].size,
+						prefbuf[nbufs - 1].base +
+						prefbuf[nbufs - 1].size);
+		}
+
+		drvdata->num_pbufs = 3;
+		drvdata->pbufs[1] = prefbuf[1];
+		drvdata->pbufs[2].size = drvdata->pbufs[2].size -
+					drvdata->pbufs[2].base;
+	}
+
+	for (i = 0; i < drvdata->num_pbufs; i++)
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[2],
+			drvdata->pbufs[i].base, drvdata->pbufs[i].size, i);
+
+	__raw_writel(cfg, drvdata->sfrbases[idx] + REG_MMU_CFG);
+}
+
+static void __exynos_sysmmu_set_pbuf_ver33(struct sysmmu_drvdata *drvdata,
+			int idx, int nbufs, struct sysmmu_prefbuf prefbuf[])
+{
+	static char pbcfg[6][6] = {
+		{7, 7, 7, 7, 7, 7}, {7, 7, 7, 7, 7, 7}, {2, 2, 3, 7, 7, 7},
+		{1, 2, 3, 4, 7, 7}, {7, 7, 7, 7, 7, 7}, {2, 3, 3, 4, 5, 6}
+		};
+	int pbselect;
+	int cmp, i;
+	long num_pb = __raw_readl(drvdata->sfrbases[idx] + REG_PB_INFO) &
+							((1 << 8) - 1);
+
+	if (nbufs > num_pb)
+		nbufs = num_pb; /* ignoring the rest of buffers */
+
+	for (i = 0; i < nbufs; i++)
+		drvdata->pbufs[i] = prefbuf[i];
+	drvdata->num_pbufs = nbufs;
+
+	cmp = __sysmmu_sort_prefbuf(drvdata->pbufs, nbufs, true);
+
+	pbselect = num_pb - nbufs;
+	if (num_pb == 6) {
+		if ((nbufs == 3) && (cmp == 1))
+			pbselect = 4;
+		else if (nbufs < 3)
+			pbselect = 5;
+	} else if ((num_pb == 3) && (nbufs < 3)) {
+			pbselect = 1;
+	}
+
+	__raw_writel(pbselect, drvdata->sfrbases[idx] + REG_PB_LMM);
+
+	/* Configure prefech buffers */
+	for (i = 0; i < nbufs; i++) {
+		__raw_writel(i, drvdata->sfrbases[idx] + REG_PB_INDICATE);
+		__raw_writel(drvdata->pbufs[i].config | 1,
+				drvdata->sfrbases[idx] + REG_PB_CFG);
+		__sysmmu_set_prefbuf(drvdata->sfrbases[idx] + pbuf_offset[3],
+			drvdata->pbufs[i].base, drvdata->pbufs[i].size, 0);
+	}
+
+	/* Disable prefetch buffers that is not set */
+	for (cmp = pbcfg[num_pb - 1][nbufs - 1] - nbufs; cmp > 0; cmp--) {
+		__raw_writel(cmp + nbufs - 1,
+				drvdata->sfrbases[idx] + REG_PB_INDICATE);
+		__raw_writel(0, drvdata->sfrbases[idx] + REG_PB_CFG);
+	}
+}
+
+static void (*func_set_pbuf[NUM_MINOR_OF_SYSMMU_V3])
+	(struct sysmmu_drvdata *, int, int, struct sysmmu_prefbuf []) = {
+		__exynos_sysmmu_set_pbuf_ver31,
+		__exynos_sysmmu_set_pbuf_ver31,
+		__exynos_sysmmu_set_pbuf_ver32,
+		__exynos_sysmmu_set_pbuf_ver33,
+};
+
+void exynos_sysmmu_set_pbuf(struct device *dev, int nbufs,
+				struct sysmmu_prefbuf prefbuf[])
 {
 	struct device *sysmmu;
+	int nsfrs;
+
+	if (WARN_ON(nbufs < 1))
+		return;
 
 	for_each_sysmmu(dev, sysmmu) {
-		int i;
 		unsigned long flags;
-		struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
+		struct sysmmu_drvdata *drvdata;
 
-		BUG_ON((base0 + size0) <= base0);
-		BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
+		drvdata = dev_get_drvdata(sysmmu);
 
-		spin_lock_irqsave(&data->lock, flags);
-		if (!is_sysmmu_active(data)) {
-			spin_unlock_irqrestore(&data->lock, flags);
+		spin_lock_irqsave(&drvdata->lock, flags);
+		if (!is_sysmmu_active(drvdata)) {
+			spin_unlock_irqrestore(&drvdata->lock, flags);
 			continue;
 		}
 
-		for (i = 0; i < data->nsfrs; i++) {
-			if (__sysmmu_version(data, i, NULL) == 3) {
-				if (!sysmmu_block(data->sfrbases[i]))
-					continue;
-
-				if (size1 == 0) {
-					if (size0 <= SZ_128K) {
-						base1 = base0;
-						size1 = size0;
-					} else {
-						size1 = size0 -
-						ALIGN(size0 / 2, SZ_64K);
-						size0 = size0 - size1;
-						base1 = base0 + size0;
-					}
-				}
+		for (nsfrs = 0; nsfrs < drvdata->nsfrs; nsfrs++) {
+			unsigned int maj, min;
+
+			maj = __sysmmu_version(drvdata, nsfrs, &min);
 
-				__sysmmu_set_prefbuf(
-					data->sfrbases[i], base0, size0, 0);
-				__sysmmu_set_prefbuf(
-					data->sfrbases[i], base1, size1, 1);
+			BUG_ON(min > 3);
 
-				sysmmu_unblock(data->sfrbases[i]);
+			if (sysmmu_block(drvdata->sfrbases[nsfrs])) {
+				func_set_pbuf[min](drvdata, nsfrs,
+							nbufs, prefbuf);
+				sysmmu_unblock(drvdata->sfrbases[nsfrs]);
+			}
+		} /* while (nsfrs < drvdata->nsfrs) */
+		spin_unlock_irqrestore(&drvdata->lock, flags);
+	}
+}
+
+static void __sysmmu_init_prefbuf(struct sysmmu_drvdata *drvdata, int idx,
+							int maj, int min)
+{
+	if (maj == 3) {
+		struct sysmmu_prefbuf pbuf[1] = { {0, ~0} };
+
+		func_set_pbuf[min](drvdata, idx, 1, pbuf);
+	}
+}
+
+static void __sysmmu_restore_state(struct sysmmu_drvdata *drvdata)
+{
+	int i, min;
+
+	for (i = 0; i < drvdata->nsfrs; i++) {
+		if (__sysmmu_version(drvdata, i, &min) == 3) {
+			if (sysmmu_block(drvdata->sfrbases[i])) {
+				func_set_pbuf[min](drvdata, i,
+					drvdata->num_pbufs, drvdata->pbufs);
+				sysmmu_unblock(drvdata->sfrbases[i]);
 			}
 		}
-		spin_unlock_irqrestore(&data->lock, flags);
 	}
 }
 
@@ -500,7 +743,7 @@ static void __sysmmu_enable_nocount(struct sysmmu_drvdata *drvdata)
 
 	for (i = 0; i < drvdata->nsfrs; i++) {
 		int maj, min;
-		unsigned long cfg = 1;
+		unsigned long cfg = CFG_LRU | CFG_QOS(15);
 
 		__sysmmu_set_ptbase(drvdata->sfrbases[i], drvdata->pgtable);
 
@@ -508,15 +751,15 @@ static void __sysmmu_enable_nocount(struct sysmmu_drvdata *drvdata)
 		   call to __sysmmu_init_prefbuf() */
 		maj = __sysmmu_version(drvdata, i, &min);
 		if (maj == 3) {
-			/* System MMU version is 3.x */
-			__raw_writel((1 << 12) | (2 << 28),
-					drvdata->sfrbases[i] + REG_MMU_CFG);
-			__sysmmu_set_prefbuf(drvdata->sfrbases[i], 0, -1, 0);
-			__sysmmu_set_prefbuf(drvdata->sfrbases[i], 0, -1, 1);
+			cfg |= CFG_SHAREABLE;
+			if (min == 2)
+				cfg |= CFG_FLPDCACHE | CFG_SYSSEL;
 		}
 
 		__raw_writel(cfg, drvdata->sfrbases[i] + REG_MMU_CFG);
 
+		__sysmmu_init_prefbuf(drvdata, i, maj, min);
+
 		__raw_writel(CTRL_ENABLE, drvdata->sfrbases[i] + REG_MMU_CTRL);
 	}
 }
@@ -900,6 +1143,7 @@ static int sysmmu_resume(struct device *dev)
 	if (is_sysmmu_active(drvdata) &&
 		(!pm_runtime_enabled(dev) || drvdata->runtime_active)) {
 		__sysmmu_enable_nocount(drvdata);
+		__sysmmu_restore_state(drvdata);
 	}
 	spin_unlock_irqrestore(&drvdata->lock, flags);
 	return 0;
-- 
1.8.0


