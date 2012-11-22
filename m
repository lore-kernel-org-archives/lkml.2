Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2KVTqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:46:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59549 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab2KVTpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:45:49 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-6d-50ae0d9b606c
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 12/12] iommu/exynos: add debugfs entries for System MMU
Date: Thu, 22 Nov 2012 20:33:47 +0900
Message-id: <002d01cdc8a5$3c832880$b5897980$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpTxqm6TpIbiSTsyVfL79cJmzqQ==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zfd3ZvOsCDJ5eMbO4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq49+YMe8E0+4r/+yewNzB2mnQxcnJICJhIrF64nwXC
	FpO4cG89WxcjF4eQwDJGiQlXf7DAFJ2fu4EVIrGIUWLBiqdQVf8YJd50rGAGqWIT0JJYPfc4
	I0hCRKCXUeJC/1cmEIdZ4AejxPTNv4BmcXAIC3hJnDiqD2KyCKhKTJkQDWLyCthK3F4WAzKG
	V0BQ4sfke2CLmYFGrt95nAnClpfYvOYtM0i5hIC6xKO/uiBhEQE9ifbnE9khSkQk9r14xwhi
	swgISHybfIgFolxWYtMBZpBbJASms0s07r7JDPGXpMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMUC
	RpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGCExI7WDcWWDxSFGAQ5GJR5eTee1AUKsiWXF
	lbmHGCU4mJVEeO9xrwsQ4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5HxgPOeVxBsaG5uYmZia
	mFuampviEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwJjGu1QluPbsnFLz8Kq73uJnDTh/
	7zq/k+mFj5Eqp999eb78StOnz+euV0nPmNab5r6geH1JS6Wv+o/H5zZvP17sOuP5YuOD+v+F
	tKdXG5+9z37omrybfHH7vvvenT/Wz5/MxRsRq8ckaXZt8pRL3t9E810mTnnD3v5klfRUZb0l
	X1W9ei5zHlBiKc5INNRiLipOBADZOqyZxgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAd3ZvOsCDK6sMLK4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuPfmDHvBNPuK
	//snsDcwdpp0MXJySAiYSJyfu4EVwhaTuHBvPVsXIxeHkMAiRokFK55COf8YJd50rGAGqWIT
	0JJYPfc4I0hCRKCXUeJC/1cmEIdZ4AejxPTNv1i6GDk4hAW8JE4c1QcxWQRUJaZMiAYxeQVs
	JW4viwEZwysgKPFj8j0WEJsZaOT6nceZIGx5ic1r3jKDlEsIqEs8+qsLEhYR0JNofz6RHaJE
	RGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBE
	PpPawbiyweIQowAHoxIPr6bz2gAh1sSy4srcQ4wSHMxKIrz3uNcFCPGmJFZWpRblxxeV5qQW
	H2L0AXpzIrOUaHI+MFnklcQbGpuYGVkamVkYmZib4xBWEudt9kgJEBJITyxJzU5NLUgtghnH
	xMEp1cDoxHJNvEN30xop+culWxc93bczIlfija6TvINA1Me3QoqrGDfNWy3FoS6Y/s3ux0Nx
	eeMbPcti9ubMSY3YUNrBb/8pln/xG6Fpejn2uZ0xl2/JKexseL6qW0/iS+TfrvzQeZcnqeZn
	mlZM7wq/UThd9rfnCYXbp6Zd/HagKGOt6Fq+5VZrb0cpsRRnJBpqMRcVJwIAx8cnvPUCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds debugfs directory and nodes for inspecting internal
state of System MMU.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 204 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 198 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 4981afe..93885a3 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -26,12 +26,17 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
 #include <linux/string.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 
 #include <asm/cacheflush.h>
 
+#define MODULE_NAME "exynos-sysmmu"
+
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
@@ -237,6 +242,7 @@ struct sysmmu_drvdata {
 	spinlock_t lock;
 	struct sysmmu_prefbuf pbufs[MAX_NUM_PBUF];
 	int num_pbufs;
+	struct dentry *debugfs_root;
 	struct iommu_domain *domain;
 	sysmmu_fault_handler_t fault_handler;
 	unsigned long pgtable;
@@ -1095,6 +1101,8 @@ static void __init __sysmmu_init_mmuname(struct device *sysmmu,
 	}
 }
 
+static void __create_debugfs_entry(struct sysmmu_drvdata *drvdata);
+
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int i, ret;
@@ -1165,6 +1173,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 		__set_fault_handler(data, &default_fault_handler);
 
+		__create_debugfs_entry(data);
+
 		platform_set_drvdata(pdev, data);
 
 		dev->archdata.iommu = &sysmmu_placeholder;
@@ -1269,7 +1279,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.probe		= exynos_sysmmu_probe,
 	.driver		= {
 		.owner		= THIS_MODULE,
-		.name		= "exynos-sysmmu",
+		.name		= MODULE_NAME,
 		.pm		= &__pm_ops,
 		.of_match_table = of_match_ptr(sysmmu_of_match),
 	}
@@ -1646,6 +1656,8 @@ static struct iommu_ops exynos_iommu_ops = {
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
+static struct dentry *sysmmu_debugfs_root; /* /sys/kernel/debug/sysmmu */
+
 static int __init exynos_iommu_init(void)
 {
 	int ret;
@@ -1657,17 +1669,197 @@ static int __init exynos_iommu_init(void)
 		return -ENOMEM;
 	}
 
-	ret = platform_driver_register(&exynos_sysmmu_driver);
+	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	if (ret) {
+		kmem_cache_destroy(lv2table_kmem_cache);
+		pr_err("%s: Failed to register IOMMU ops\n", __func__);
+		return -EFAULT;
+	}
 
-	if (ret == 0)
-		ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
+	sysmmu_debugfs_root = debugfs_create_dir("sysmmu", NULL);
+	if (!sysmmu_debugfs_root)
+		pr_err("%s: Failed to create debugfs entry, 'sysmmu'\n",
+							__func__);
+	if (IS_ERR(sysmmu_debugfs_root))
+		sysmmu_debugfs_root = NULL;
 
+	ret = platform_driver_register(&exynos_sysmmu_driver);
 	if (ret) {
-		pr_err("%s: Failed to register exynos-iommu driver.\n",
-								__func__);
 		kmem_cache_destroy(lv2table_kmem_cache);
+		pr_err("%s: Failed to register System MMU driver\n", __func__);
 	}
 
 	return ret;
 }
 subsys_initcall(exynos_iommu_init);
+
+static int debug_string_show(struct seq_file *s, void *unused)
+{
+	char *str = s->private;
+
+	seq_printf(s, "%s\n", str);
+
+	return 0;
+}
+
+static int debug_sysmmu_list_show(struct seq_file *s, void *unused)
+{
+	struct sysmmu_drvdata *drvdata = s->private;
+	struct platform_device *pdev = to_platform_device(drvdata->sysmmu);
+	int idx, maj, min, ret;
+
+	seq_printf(s, "SysMMU Name | Ver | SFR Base\n");
+
+	if (pm_runtime_enabled(drvdata->sysmmu)) {
+		ret = pm_runtime_get_sync(drvdata->sysmmu);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (idx = 0; idx < drvdata->nsfrs; idx++) {
+		struct resource *res;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, idx);
+		if (!res)
+			break;
+
+		maj = __sysmmu_version(drvdata, idx, &min);
+
+		if (drvdata->mmuname) {
+			if (maj == 0)
+				seq_printf(s, "%11.s | N/A | 0x%08x\n",
+					drvdata->mmuname[idx], res->start);
+			else
+				seq_printf(s, "%11.s | %d.%d | 0x%08x\n",
+				drvdata->mmuname[idx], maj, min, res->start);
+		} else {
+			if (maj == 0)
+				seq_printf(s, "N/A | 0x%08x\n", res->start);
+			else
+				seq_printf(s, "%d.%d | 0x%08x\n",
+							maj, min, res->start);
+		}
+	}
+
+	if (pm_runtime_enabled(drvdata->sysmmu))
+		pm_runtime_put(drvdata->sysmmu);
+
+	return 0;
+}
+
+static int debug_next_sibling_show(struct seq_file *s, void *unused)
+{
+	struct device *dev = s->private;
+
+	if (dev->parent &&
+		!strncmp(dev_name(dev->parent),
+			MODULE_NAME, strlen(MODULE_NAME)))
+		seq_printf(s, "%s\n", dev_name(dev->parent));
+	return 0;
+}
+
+static int __show_master(struct device *dev, void *data)
+{
+	struct seq_file *s = data;
+
+	if (strncmp(dev_name(dev), MODULE_NAME, strlen(MODULE_NAME)))
+		seq_printf(s, "%s\n", dev_name(dev));
+	return 0;
+}
+
+static int debug_master_show(struct seq_file *s, void *unused)
+{
+	struct device *dev = s->private;
+
+	device_for_each_child(dev, s, __show_master);
+	return 0;
+}
+
+static int debug_string_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_string_show, inode->i_private);
+}
+
+static int debug_sysmmu_list_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_sysmmu_list_show, inode->i_private);
+}
+
+static int debug_next_sibling_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_next_sibling_show, inode->i_private);
+}
+
+static int debug_master_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debug_master_show, inode->i_private);
+}
+
+static const struct file_operations debug_string_fops = {
+	.open = debug_string_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_sysmmu_list_fops = {
+	.open = debug_sysmmu_list_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_next_sibling_fops = {
+	.open = debug_next_sibling_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations debug_master_fops = {
+	.open = debug_master_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void __init __create_debugfs_entry(struct sysmmu_drvdata *drvdata)
+{
+	if (!sysmmu_debugfs_root)
+		return;
+
+	drvdata->debugfs_root = debugfs_create_dir(dev_name(drvdata->sysmmu),
+							sysmmu_debugfs_root);
+	if (!drvdata->debugfs_root)
+		dev_err(drvdata->sysmmu, "Failed to create debugfs dentry\n");
+	if (IS_ERR(drvdata->debugfs_root))
+		drvdata->debugfs_root = NULL;
+
+	if (!drvdata->debugfs_root)
+		return;
+
+	if (!debugfs_create_u32("enable", 0664, drvdata->debugfs_root,
+						&drvdata->activations))
+		dev_err(drvdata->sysmmu,
+				"Failed to create debugfs file 'enable'\n");
+
+	if (!debugfs_create_x32("pagetable", 0664, drvdata->debugfs_root,
+						(u32 *)&drvdata->pgtable))
+		dev_err(drvdata->sysmmu,
+				"Failed to create debugfs file 'pagetable'\n");
+
+	if (!debugfs_create_file("sysmmu_list", 0444, drvdata->debugfs_root,
+					drvdata, &debug_sysmmu_list_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'sysmmu_list'\n");
+
+	if (!debugfs_create_file("next_sibling", 0x444, drvdata->debugfs_root,
+				drvdata->sysmmu, &debug_next_sibling_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'next_siblings'\n");
+
+	if (!debugfs_create_file("master", 0x444, drvdata->debugfs_root,
+				drvdata->sysmmu, &debug_master_fops))
+		dev_err(drvdata->sysmmu,
+			"Failed to create debugfs file 'next_siblings'\n");
+}
-- 
1.8.0


