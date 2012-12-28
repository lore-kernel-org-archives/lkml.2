Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab2L1JBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:01:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32827 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2L1JBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:01:18 -0500
X-AuditID: cbfee61b-b7f616d00000319b-79-50dd5fc7c893
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: kgene.kim@samsung.com, jhbird.choi@samsung.com,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH] PM/Devfreq: Add Exynos5-bus devfreq driver for Exynos5250.
Date: Fri, 28 Dec 2012 04:22:50 -0500
Message-id: <1356686570-12242-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <CAJ0PZbTTDdAXJ378R7CDO2=spx7WF_RpztG5ch7iFZWx-v3N2Q@mail.gmail.com>
References: <CAJ0PZbTTDdAXJ378R7CDO2=spx7WF_RpztG5ch7iFZWx-v3N2Q@mail.gmail.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkRvd4/N0Ag1tdQhaXd81hs/jce4TR
	gcnj8ya5AMYoLpuU1JzMstQifbsEroz+jQfZC14VVHyav56tgXFLbBcjJ4eEgInE+8OL2CFs
	MYkL99azdTFycQgJLGWUuL9lFUsXIwdY0cfj2RDx6YwSH5Y8BWsQEuhlkmi97QJiswnoSSz4
	95UZxBYRqJOYMfcsG4jNLBAn0XqwA8wWFvCWeL7lNFgNi4CqxILDF1hBbF4BV4lzK3axQhwh
	J/FhzyOw+ZwCwRJzDvWzQuwKkLg4DeQekF4BiW+TD0HdJiux6QAzyG0SArfZJO4/OsQCMUdS
	4uCKGywTGIUXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgMxdP/nknvYFzVYHGIUYCD
	UYmHd1HPnQAh1sSy4srcQ4wSHMxKIrz6P4BCvCmJlVWpRfnxRaU5qcWHGH2ALpnILCWanA+M
	k7ySeENjE3NTY1NLIyMzU1McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGHvKdm0oubfp
	z0HhYr32Od+8RLukmFktPk8Ot0v8FrUw2SizwPdZWareYaU5AjH/Wzt+xif84ZSPcW5WLTr1
	VHX9KZW91/JXM91rMdj/4W4UV9bxdX/lyqcvn37qYwWD3auia99uivl8O2M+L6qjteippsG6
	3yWWvpNuTeoM7DaV/Pez+d6GyUosxRmJhlrMRcWJALdmFIJyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xoO7x+LsBBk9nMVtc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz+jceZC94VVDx
	af56tgbGLbFdjBwcEgImEh+PZ3cxcgKZYhIX7q1n62Lk4hASmM4o8WHJU3aQhJBAL5NE620X
	EJtNQE9iwb+vzCC2iECdxIy5Z9lAbGaBOInWgx1gtrCAt8TzLafBalgEVCUWHL7ACmLzCrhK
	nFuxixVimZzEhz2PwOZzCgRLzDnUzwqxK0Di4rRVLBMYeRcwMqxiFE0tSC4oTkrPNdIrTswt
	Ls1L10vOz93ECA70Z9I7GFc1WBxiFOBgVOLhXdRzJ0CINbGsuDL3EKMEB7OSCK/+D6AQb0pi
	ZVVqUX58UWlOavEhRh+gqyYyS4km5wOjMK8k3tDYxNzU2NTSxMLEzBKHsJI4b7NHSoCQQHpi
	SWp2ampBahHMOCYOTqkGxvrch668u7u+rKza/z127X2F1iMfZonHpJr8ftTffPrGEfOiAxUJ
	Hbe7Tr/jzz1p1fV0jd6F/z2xEjc6Qrva20q/qnwqi+e3WlV3sqy7V1/o/4RJ2rbCReyGE29l
	TV/W4BcaW5oc9do/Lnvxawduv0+SMsaT3vza1GpUGv9r9dJPXrnh2qfWKLEUZyQaajEXFScC
	AGkBqUGhAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5-bus device devfreq driver monitors PPMU counters and
adjusts operating frequencies and voltages with OPP. ASV should
be used to provide appropriate voltages as per the speed group
of the SoC rather than using a constant 1.025V.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
Changes since RFC v1:
* Moved the Exynos5 PPMU driver to machine specific directory
* Migrated to the PM QOS framework

This patch depends on PPMU support which has now been posted as part of
the arch-side support patch.
Tested after merging for-rafael branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git
with for-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git

 drivers/devfreq/Kconfig       |  10 +
 drivers/devfreq/Makefile      |   1 +
 drivers/devfreq/exynos5_bus.c | 469 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 480 insertions(+)
 create mode 100644 drivers/devfreq/exynos5_bus.c

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 0f079be..5b5a978 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -78,4 +78,14 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 	  To operate with optimal voltages, ASV support is required
 	  (CONFIG_EXYNOS_ASV).
 
+config ARM_EXYNOS5_BUS_DEVFREQ
+	bool "ARM Exynos5250 Bus DEVFREQ Driver"
+	depends on SOC_EXYNOS5250 && EXYNOS5250_PPMU
+	select ARCH_HAS_OPP
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	help
+	  This adds the DEVFREQ driver for Exynos5250 bus interface (vdd_int).
+	  It reads PPMU counters of memory controllers and adjusts the
+	  operating frequencies and voltages with OPP support.
+
 endif # PM_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 8c46423..1771276 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 
 # DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos4_bus.o
+obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos5_bus.o
diff --git a/drivers/devfreq/exynos5_bus.c b/drivers/devfreq/exynos5_bus.c
new file mode 100644
index 0000000..ad442a4
--- /dev/null
+++ b/drivers/devfreq/exynos5_bus.c
@@ -0,0 +1,469 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5 INT clock frequency scaling support using DEVFREQ framework
+ * Based on work done by Jonghwan Choi <jhbird.choi@samsung.com>
+ * Support for only EXYNOS5250 is present.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/suspend.h>
+#include <linux/opp.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/pm_qos.h>
+#include <linux/regulator/consumer.h>
+
+#include <mach/exynos_ppmu.h>
+#include <mach/exynos5_ppmu.h>
+#include "governor.h"
+
+#define MAX_SAFEVOLT			1100000 /* 1.10V */
+/* Assume that the bus is saturated if the utilization is 25% */
+#define INT_BUS_SATURATION_RATIO	25
+#define EXYNOS5_BUS_INT_POLL_TIME	msecs_to_jiffies(100)
+
+enum int_level_idx {
+	LV_0,
+	LV_1,
+	LV_2,
+	LV_3,
+	LV_4,
+	_LV_END
+};
+
+struct busfreq_data_int {
+	struct device *dev;
+	struct devfreq *devfreq;
+	bool disabled;
+	struct regulator *vdd_int;
+	unsigned long curr_freq;
+	struct notifier_block pm_notifier;
+	struct mutex lock;
+	struct pm_qos_request int_req;
+	struct clk *int_clk;
+	struct exynos5_ppmu_handle *ppmu;
+	struct delayed_work work;
+	int busy;
+};
+
+struct int_bus_opp_table {
+	unsigned int idx;
+	unsigned long clk;
+	unsigned long volt;
+};
+
+static struct int_bus_opp_table exynos5_int_opp_table[] = {
+	{LV_0, 266000, 1025000},
+	{LV_1, 200000, 1025000},
+	{LV_2, 160000, 1025000},
+	{LV_3, 133000, 1025000},
+	{LV_4, 100000, 1025000},
+	{0, 0, 0},
+};
+
+static int exynos5_int_setvolt(struct busfreq_data_int *data,
+		unsigned long volt)
+{
+	return regulator_set_voltage(data->vdd_int, volt, MAX_SAFEVOLT);
+}
+
+static int exynos5_busfreq_int_target(struct device *dev, unsigned long *_freq,
+			      u32 flags)
+{
+	int err = 0;
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+	struct opp *opp;
+	unsigned long old_freq, freq;
+	unsigned long volt;
+
+	rcu_read_lock();
+	opp = devfreq_recommended_opp(dev, _freq, flags);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
+		dev_err(dev, "%s: Invalid OPP.\n", __func__);
+		return PTR_ERR(opp);
+	}
+
+	freq = opp_get_freq(opp);
+	volt = opp_get_voltage(opp);
+	rcu_read_unlock();
+
+	old_freq = data->curr_freq;
+
+	if (old_freq == freq)
+		return 0;
+
+	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, volt);
+
+	mutex_lock(&data->lock);
+
+	if (data->disabled)
+		goto out;
+
+	if (freq > exynos5_int_opp_table[_LV_END - 1].clk)
+		pm_qos_update_request(&data->int_req,
+				data->busy * old_freq * 16 / 100000);
+	else
+		pm_qos_update_request(&data->int_req, -1);
+
+	if (old_freq < freq)
+		err = exynos5_int_setvolt(data, volt);
+	if (err)
+		goto out;
+
+	err = clk_set_rate(data->int_clk, freq * 1000);
+
+	if (err)
+		goto out;
+
+	if (old_freq > freq)
+		err = exynos5_int_setvolt(data, volt);
+	if (err)
+		goto out;
+
+	data->curr_freq = freq;
+out:
+	mutex_unlock(&data->lock);
+	return err;
+}
+
+static int exynos5_int_get_dev_status(struct device *dev,
+				      struct devfreq_dev_status *stat)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	stat->current_frequency = data->curr_freq;
+	stat->busy_time = data->busy;
+	stat->total_time = 100;
+
+	return 0;
+}
+
+static void exynos5_int_poll_start(struct busfreq_data_int *data)
+{
+	schedule_delayed_work(&data->work, EXYNOS5_BUS_INT_POLL_TIME);
+}
+
+static void exynos5_int_poll_stop(struct busfreq_data_int *data)
+{
+	cancel_delayed_work_sync(&data->work);
+}
+
+static void exynos5_int_poll(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct busfreq_data_int *data;
+	int ret;
+
+	dwork = to_delayed_work(work);
+	data = container_of(dwork, struct busfreq_data_int, work);
+
+	ret = exynos5_ppmu_get_busy(data->ppmu, PPMU_SET_RIGHT);
+
+	if (ret >= 0) {
+		data->busy = ret;
+		mutex_lock(&data->devfreq->lock);
+		update_devfreq(data->devfreq);
+		mutex_unlock(&data->devfreq->lock);
+	}
+
+	schedule_delayed_work(&data->work, EXYNOS5_BUS_INT_POLL_TIME);
+}
+
+static void exynos5_int_exit(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	devfreq_unregister_opp_notifier(dev, data->devfreq);
+}
+
+static struct devfreq_dev_profile exynos5_devfreq_int_profile = {
+	.initial_freq		= 160000,
+	.polling_ms		= 0,
+	.target			= exynos5_busfreq_int_target,
+	.get_dev_status		= exynos5_int_get_dev_status,
+	.exit			= exynos5_int_exit,
+};
+
+static int exynos5250_init_int_tables(struct busfreq_data_int *data)
+{
+	int i, err = 0;
+
+	for (i = LV_0; i < _LV_END; i++) {
+		err = opp_add(data->dev, exynos5_int_opp_table[i].clk,
+				exynos5_int_opp_table[i].volt);
+		if (err) {
+			dev_err(data->dev, "Cannot add opp entries.\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+static struct devfreq_simple_ondemand_data exynos5_int_ondemand_data = {
+	.downdifferential = 2,
+	.upthreshold = INT_BUS_SATURATION_RATIO,
+};
+
+static int exynos5_busfreq_int_pm_notifier_event(struct notifier_block *this,
+		unsigned long event, void *ptr)
+{
+	struct busfreq_data_int *data = container_of(this,
+					struct busfreq_data_int, pm_notifier);
+	struct opp *opp;
+	unsigned long maxfreq = ULONG_MAX;
+	unsigned long freq;
+	unsigned long volt;
+	int err = 0;
+
+	switch (event) {
+	case PM_SUSPEND_PREPARE:
+		/* Set Fastest and Deactivate DVFS */
+		mutex_lock(&data->lock);
+
+		data->disabled = true;
+
+		rcu_read_lock();
+		opp = opp_find_freq_floor(data->dev, &maxfreq);
+		if (IS_ERR(opp)) {
+			rcu_read_unlock();
+			err = PTR_ERR(opp);
+			goto unlock;
+		}
+		freq = opp_get_freq(opp);
+		volt = opp_get_voltage(opp);
+		rcu_read_unlock();
+
+		err = exynos5_int_setvolt(data, volt);
+		if (err)
+			goto unlock;
+
+		err = clk_set_rate(data->int_clk, freq * 1000);
+
+		if (err)
+			goto unlock;
+
+		data->curr_freq = freq;
+unlock:
+		mutex_unlock(&data->lock);
+		if (err)
+			return NOTIFY_BAD;
+		return NOTIFY_OK;
+	case PM_POST_RESTORE:
+	case PM_POST_SUSPEND:
+		/* Reactivate */
+		mutex_lock(&data->lock);
+		data->disabled = false;
+		mutex_unlock(&data->lock);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static __devinit int exynos5_busfreq_int_probe(struct platform_device *pdev)
+{
+	struct busfreq_data_int *data;
+	struct opp *opp;
+	struct device *dev = &pdev->dev;
+	unsigned long initial_freq;
+	unsigned long initial_volt;
+	int err = 0;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(struct busfreq_data_int),
+				GFP_KERNEL);
+	if (data == NULL) {
+		dev_err(dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	data->pm_notifier.notifier_call = exynos5_busfreq_int_pm_notifier_event;
+	data->dev = dev;
+	mutex_init(&data->lock);
+
+	err = exynos5250_init_int_tables(data);
+	if (err)
+		goto err_regulator;
+
+	data->vdd_int = regulator_get(dev, "vdd_int");
+	if (IS_ERR(data->vdd_int)) {
+		dev_err(dev, "Cannot get the regulator \"vdd_int\"\n");
+		err = PTR_ERR(data->vdd_int);
+		goto err_regulator;
+	}
+
+	data->int_clk = clk_get(dev, "int_clk");
+	if (IS_ERR(data->int_clk)) {
+		dev_err(dev, "Cannot get clock \"int_clk\"\n");
+		err = PTR_ERR(data->int_clk);
+		goto err_clock;
+	}
+
+	rcu_read_lock();
+	opp = opp_find_freq_floor(dev,
+			&exynos5_devfreq_int_profile.initial_freq);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
+		dev_err(dev, "Invalid initial frequency %lu kHz.\n",
+		       exynos5_devfreq_int_profile.initial_freq);
+		err = PTR_ERR(opp);
+		goto err_opp_add;
+	}
+	initial_freq = opp_get_freq(opp);
+	initial_volt = opp_get_voltage(opp);
+	rcu_read_unlock();
+	data->curr_freq = initial_freq;
+
+	err = clk_set_rate(data->int_clk, initial_freq * 1000);
+	if (err) {
+		dev_err(dev, "Failed to set initial frequency\n");
+		goto err_opp_add;
+	}
+
+	err = exynos5_int_setvolt(data, initial_volt);
+	if (err)
+		goto err_opp_add;
+
+	platform_set_drvdata(pdev, data);
+
+	data->ppmu = exynos5_ppmu_get();
+	if (!data->ppmu)
+		goto err_ppmu_get;
+
+	INIT_DELAYED_WORK(&data->work, exynos5_int_poll);
+	exynos5_int_poll_start(data);
+
+	data->devfreq = devfreq_add_device(dev, &exynos5_devfreq_int_profile,
+					   "simple_ondemand",
+					   &exynos5_int_ondemand_data);
+
+	if (IS_ERR(data->devfreq)) {
+		err = PTR_ERR(data->devfreq);
+		goto err_devfreq_add;
+	}
+
+	devfreq_register_opp_notifier(dev, data->devfreq);
+
+	err = register_pm_notifier(&data->pm_notifier);
+	if (err) {
+		dev_err(dev, "Failed to setup pm notifier\n");
+		goto err_devfreq_add;
+	}
+
+	/* TODO: Add a new QOS class for int/mif bus */
+	pm_qos_add_request(&data->int_req, PM_QOS_NETWORK_THROUGHPUT, -1);
+
+	return 0;
+
+err_devfreq_add:
+	devfreq_remove_device(data->devfreq);
+	exynos5_int_poll_stop(data);
+err_ppmu_get:
+	platform_set_drvdata(pdev, NULL);
+err_opp_add:
+	clk_put(data->int_clk);
+err_clock:
+	regulator_put(data->vdd_int);
+err_regulator:
+	return err;
+}
+
+static __devexit int exynos5_busfreq_int_remove(struct platform_device *pdev)
+{
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	pm_qos_remove_request(&data->int_req);
+	unregister_pm_notifier(&data->pm_notifier);
+	devfreq_remove_device(data->devfreq);
+	regulator_put(data->vdd_int);
+	clk_put(data->int_clk);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int exynos5_busfreq_int_suspend(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	exynos5_int_poll_stop(data);
+	return 0;
+}
+
+static int exynos5_busfreq_int_resume(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	exynos5_int_poll_start(data);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(exynos5_busfreq_int_pm, exynos5_busfreq_int_suspend,
+		exynos5_busfreq_int_resume);
+
+/* platform device pointer for exynos5 devfreq device. */
+static struct platform_device *exynos5_devfreq_pdev;
+
+static struct platform_driver exynos5_busfreq_int_driver = {
+	.probe		= exynos5_busfreq_int_probe,
+	.remove		= __devexit_p(exynos5_busfreq_int_remove),
+	.driver		= {
+		.name		= "exynos5-bus-int",
+		.owner		= THIS_MODULE,
+		.pm		= &exynos5_busfreq_int_pm,
+	},
+};
+
+static int __init exynos5_busfreq_int_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&exynos5_busfreq_int_driver);
+	if (ret < 0)
+		goto out;
+
+	exynos5_devfreq_pdev =
+		platform_device_register_simple("exynos5-bus-int", -1, NULL, 0);
+	if (IS_ERR_OR_NULL(exynos5_devfreq_pdev)) {
+		ret = PTR_ERR(exynos5_devfreq_pdev);
+		goto out1;
+	}
+
+	return 0;
+out1:
+	platform_driver_unregister(&exynos5_busfreq_int_driver);
+out:
+	return ret;
+}
+late_initcall(exynos5_busfreq_int_init);
+
+static void __exit exynos5_busfreq_int_exit(void)
+{
+	platform_device_unregister(exynos5_devfreq_pdev);
+	platform_driver_unregister(&exynos5_busfreq_int_driver);
+}
+module_exit(exynos5_busfreq_int_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("EXYNOS5 busfreq driver with devfreq framework");
-- 
1.8.1-rc3

