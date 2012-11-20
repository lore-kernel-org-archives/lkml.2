Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2KTHbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:31:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43172 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2KTHa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:59 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-5c-50ab31b19f0f
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v2 12/12] iommu/exynos: add debugfs entries for System MMU
Date: Tue, 20 Nov 2012 16:30:56 +0900
Message-id: <002601cdc6f0$fb0baef0$f1230cd0$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3G8PryqF10a7VMSH21T2W+RZO4yw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zfd2NhqsDDJ5+FbO4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpoX65SsNi+4l/nObYGxikmXYycHBICJhI98/cyQdhi
	EhfurWfrYuTiEBJYxigxdU83M0zR/G0f2CESixgl3r/5ygzh/GOU+Pa8DaydTUBLYvXc44wg
	CRGBXkaJC/1fmUAcZoEfjBLTN/9iAakSFvCSuPdgLTuIzSKgKnGw6zwjiM0rYCsxecZbFghb
	UOLH5HtgNjPQ1PU7jzNB2PISm9e8BVrNAXSTusSjv7ogYREBPYlvR75ClYhI7HvxjhFivIDE
	t8mHWCDKZSU2HQA7WkKgn11i2r4WqJ8lJQ6uuMEygVFsFpLNs5BsnoVk8ywkKxYwsqxiFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECIkbqR2MKxssDjEKcDAq8fA+TFgVIMSaWFZcmXuIUYKD
	WUmEt6kcKMSbklhZlVqUH19UmpNafIjRB+jyicxSosn5wJjOK4k3NDY2MTMxNTG3NDU3xSGs
	JM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoFx9rGLf/9zum/zvChtqdsrqMBlfdNU3cvuc++F
	e3Wt0oHTvq28vm3F9PVX3mmkipTsWns70ZLlcXCcisBUy8YPh2ekCPNsWNujKssr2C7g+2N5
	TvvM0Oh7M7+baeZsdr/9+F+Iebdx4qLpgl3XltyKvzS7hGmpRcCJdNtdbZsyMyUWOOReD8lW
	YinOSDTUYi4qTgQALK/tc8gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd2NhqsDDF6dFLK4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMaF+uUrDYvuJf
	5zm2BsYpJl2MnBwSAiYS87d9YIewxSQu3FvP1sXIxSEksIhR4v2br8wQzj9GiW/P25hAqtgE
	tCRWzz3OCJIQEehllLjQ/5UJxGEW+MEoMX3zLxaQKmEBL4l7D9aCzWURUJU42HWeEcTmFbCV
	mDzjLQuELSjxY/I9MJsZaOr6nceZIGx5ic1r3gKt5gC6SV3i0V9dkLCIgJ7EtyNfoUpEJPa9
	eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEflM6kd
	jCsbLA4xCnAwKvHwPkxYFSDEmlhWXJl7iFGCg1lJhLepHCjEm5JYWZValB9fVJqTWnyI0Qfo
	0YnMUqLJ+cCEkVcSb2hsYmZkaWRmYWRibo5DWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QD
	Y4Bnw5E8vv38Ly84eIcoXPA6KHFOOKnytcb1VFefz8zb+eQ5FPYfXrFBcebiZV+MYsOyU9Uy
	K2dabnF6J/dNcp2ltMzhpIMtTUeXnIt/esLQXZF5RoPUPznW2tcLdp1n4b1qEn0n4vpK/6rU
	lRJ1jz4Hvf496euTPJZpRmdO8zm8a9DdFaKxRYmlOCPRUIu5qDgRAOmh2ID3AgAA
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
index 128c811..8ff7e97 100644
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
@@ -1094,6 +1100,8 @@ static void __init __sysmmu_init_mmuname(struct device *sysmmu,
 	}
 }
 
+static void __create_debugfs_entry(struct sysmmu_drvdata *drvdata);
+
 static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int i, ret;
@@ -1170,6 +1178,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 		__set_fault_handler(data, &default_fault_handler);
 
+		__create_debugfs_entry(data);
+
 		dev->archdata.iommu = &sysmmu_placeholder;
 		dev_dbg(dev, "Initialized successfully!\n");
 	}
@@ -1272,7 +1282,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
 	.probe		= exynos_sysmmu_probe,
 	.driver		= {
 		.owner		= THIS_MODULE,
-		.name		= "exynos-sysmmu",
+		.name		= MODULE_NAME,
 		.pm		= &__pm_ops,
 		.of_match_table = of_match_ptr(sysmmu_of_match),
 	}
@@ -1649,6 +1659,8 @@ static struct iommu_ops exynos_iommu_ops = {
 	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
 };
 
+static struct dentry *sysmmu_debugfs_root; /* /sys/kernel/debug/sysmmu */
+
 static int __init exynos_iommu_init(void)
 {
 	int ret;
@@ -1660,17 +1672,197 @@ static int __init exynos_iommu_init(void)
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


