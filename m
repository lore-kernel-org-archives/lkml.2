Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab2K3Ihl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:37:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47859 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2K3Ihj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:37:39 -0500
X-AuditID: cbfee61b-b7f616d00000319b-81-50b8705166c9
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: kgene.kim@samsung.com, jhbird.choi@samsung.com
Subject: [PATCH RFC] PM/Devfreq: Add Exynos5-bus devfreq driver for Exynos5250.
Date: Fri, 30 Nov 2012 14:12:53 +0530
Message-id: <1354264973-11214-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.6.6.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkTjewYEeAwfctAhaXd81hs/jce4TR
	gcnj8ya5AMYoLpuU1JzMstQifbsErowDT18wFkxvYKrY9OYpawPjucuMXYycHBICJhJNq96y
	QNhiEhfurWfrYuTiEBJYyijxYus/uKKJ63tYIBKLGCVenbjKCOG0MUmcvf+NGaSKTUBPYsG/
	r2C2iECdxIy5Z9lAbGYBI4kf52YCxTk4hAX8JeZ+KAUJswioSnzed50dxOYVcJX4cWgFE8Qy
	BYnTH9ayQ9QISHybfIgFpFVCQFZi0wFmkLUSAkfYJKZM2AZ1nKTEwRU3WCYwCi5gZFjFKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERhgp/89k97BuKrB4hCjAAejEg8vw5rtAUKsiWXFlbmH
	GCU4mJVEePcJ7ggQ4k1JrKxKLcqPLyrNSS0+xOgDdMlEZinR5Hxg8OeVxBsam5ibGptaGhmZ
	mZriEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwCjcVfhhm9oBTqvJ/OfSZmg8eq8R/2uq
	ZPz6S5wy8uv8b2efuXm1uybvdZroEdYlHLYf1Z8079uv6x42ZcWjM5X1e0TeVPKvs9q2jefM
	pnVOxobXvpeUW/0qZpPQrGTo6X7mcUfh7bydVR7P/unc+JQyKf64p3eHeciFnF8vPdVKVTjf
	qO2TMVZiKc5INNRiLipOBABvG76wXQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jAd2Agh0BBlsPmVlc3jWHzeJz7xFG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzDjx9wVgwvYGp
	YtObp6wNjOcuM3YxcnJICJhITFzfwwJhi0lcuLeerYuRi0NIYBGjxKsTVxkhnDYmibP3vzGD
	VLEJ6Eks+PcVzBYRqJOYMfcsG4jNLGAk8ePcTKA4B4ewgL/E3A+lIGEWAVWJz/uus4PYvAKu
	Ej8OrWCCWKYgcfrDWvYJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH7zPpHYyr
	GiwOMQpwMCrx8DKs2R4gxJpYVlyZe4hRgoNZSYR3n+COACHelMTKqtSi/Pii0pzU4kOMPkDb
	JzJLiSbnA2MrryTe0NjE3NTY1NLEwsTMEoewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbG
	qLV5TY88589qu/m3Oyd7tT1XXPWBhLlzI8X3Ti/9uEjqo+CPxRybPav5WGYsEN5jVMQxwYWH
	WT3gqHz6XC2HU/+fSvB7K9/nVF9+uGnL6S/nVPX3xkff0IrV1/HbwBixzVvnU+e1OVplayra
	76VsMOJ5WPlp+ZMr143X79JcOs3/25S3E7yzlFiKMxINtZiLihMBcnNDdowCAAA=
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
This code is based on Jonghwan Choi's <jhbird.choi@samsung.com> devfreq work
for Exynos5250. This requires corresponding machine specific changes which
will be posted once the driver is reviewed.

 drivers/devfreq/Kconfig        |   10 +
 drivers/devfreq/Makefile       |    1 +
 drivers/devfreq/exynos5_bus.c  |  595 ++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/exynos5_ppmu.c |  395 ++++++++++++++++++++++++++
 drivers/devfreq/exynos5_ppmu.h |   26 ++
 drivers/devfreq/exynos_ppmu.c  |   56 ++++
 drivers/devfreq/exynos_ppmu.h  |   79 ++++++
 7 files changed, 1162 insertions(+), 0 deletions(-)
 create mode 100644 drivers/devfreq/exynos5_bus.c
 create mode 100644 drivers/devfreq/exynos5_ppmu.c
 create mode 100644 drivers/devfreq/exynos5_ppmu.h
 create mode 100644 drivers/devfreq/exynos_ppmu.c
 create mode 100644 drivers/devfreq/exynos_ppmu.h

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 0f079be..1560d0d 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -78,4 +78,14 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 	  To operate with optimal voltages, ASV support is required
 	  (CONFIG_EXYNOS_ASV).
 
+config ARM_EXYNOS5_BUS_DEVFREQ
+	bool "ARM Exynos5250 Bus DEVFREQ Driver"
+	depends on SOC_EXYNOS5250
+	select ARCH_HAS_OPP
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	help
+	  This adds the DEVFREQ driver for Exynos5250 bus interface (vdd_int).
+	  It reads PPMU counters of memory controllers and adjusts the
+	  operating frequencies and voltages with OPP support.
+
 endif # PM_DEVFREQ
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index 8c46423..6259aa4 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 
 # DEVFREQ Drivers
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos4_bus.o
+obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos_ppmu.o exynos5_ppmu.o exynos5_bus.o
diff --git a/drivers/devfreq/exynos5_bus.c b/drivers/devfreq/exynos5_bus.c
new file mode 100644
index 0000000..8ced376
--- /dev/null
+++ b/drivers/devfreq/exynos5_bus.c
@@ -0,0 +1,595 @@
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
+#include <linux/opp.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+
+#include "exynos_ppmu.h"
+#include "exynos5_ppmu.h"
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
+	unsigned long curr_volt;
+	unsigned long suspend_freq;
+	struct mutex lock;
+	struct clk *int_clk;
+	struct exynos5_ppmu_handle *ppmu;
+	struct delayed_work work;
+	int busy;
+};
+
+struct exynos5_bus_int_handle {
+	struct list_head node;
+	struct delayed_work work;
+	bool boost;
+	bool poll;
+	unsigned long min;
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
+static struct busfreq_data_int *exynos5_bus_int_data;
+static DEFINE_MUTEX(exynos5_bus_int_data_lock);
+static LIST_HEAD(exynos5_bus_int_requests);
+static DEFINE_MUTEX(exynos5_bus_int_requests_lock);
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
+	struct exynos5_bus_int_handle *handle;
+
+	mutex_lock(&exynos5_bus_int_requests_lock);
+	list_for_each_entry(handle, &exynos5_bus_int_requests, node) {
+		if (handle->boost) {
+			*_freq = ULONG_MAX;
+			flags |= DEVFREQ_FLAG_LEAST_UPPER_BOUND;
+			break;
+		}
+		if (handle->min > *_freq) {
+			*_freq = handle->min;
+			flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND;
+		}
+	}
+	mutex_unlock(&exynos5_bus_int_requests_lock);
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
+	mutex_lock(&data->lock);
+
+	old_freq = data->curr_freq;
+
+	if (old_freq == freq)
+		goto out;
+
+	dev_dbg(dev, "targetting %lukHz %luuV\n", freq, volt);
+
+	if (data->disabled)
+		goto out;
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
+	struct exynos5_bus_int_handle *handle;
+
+	mutex_lock(&exynos5_bus_int_requests_lock);
+	list_for_each_entry(handle, &exynos5_bus_int_requests, node) {
+		if (handle->poll) {
+			schedule_delayed_work(&data->work,
+					EXYNOS5_BUS_INT_POLL_TIME);
+			break;
+		}
+	}
+	mutex_unlock(&exynos5_bus_int_requests_lock);
+}
+
+static void exynos5_int_poll_stop(struct busfreq_data_int *data)
+{
+	cancel_delayed_work_sync(&data->work);
+}
+
+static void exynos5_int_update(struct busfreq_data_int *data)
+{
+	struct exynos5_bus_int_handle *handle;
+	int ret = 0;
+	bool poll = false;
+
+	mutex_lock(&exynos5_bus_int_requests_lock);
+	list_for_each_entry(handle, &exynos5_bus_int_requests, node) {
+		if (handle->poll) {
+			poll = true;
+			break;
+		}
+	}
+	mutex_unlock(&exynos5_bus_int_requests_lock);
+
+	ret = exynos5_ppmu_get_busy(data->ppmu, PPMU_SET_RIGHT);
+	if (ret >= 0 && poll)
+		data->busy = ret;
+	else
+		data->busy = 0;
+
+	if (ret >= 0 || !poll) {
+		mutex_lock(&data->devfreq->lock);
+		update_devfreq(data->devfreq);
+		mutex_unlock(&data->devfreq->lock);
+	}
+}
+
+static void exynos5_int_poll_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct busfreq_data_int *data;
+
+	dwork = to_delayed_work(work);
+	data = container_of(dwork, struct busfreq_data_int, work);
+
+	exynos5_int_update(data);
+	exynos5_int_poll_start(data);
+}
+
+static void exynos5_int_cancel_boost(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct exynos5_bus_int_handle *handle;
+
+	handle = container_of(dwork, struct exynos5_bus_int_handle, work);
+	handle->boost = false;
+}
+
+struct exynos5_bus_int_handle *exynos5_bus_int_get(unsigned long min_freq,
+		bool poll)
+{
+	struct exynos5_bus_int_handle *handle;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return NULL;
+
+	handle->min = min_freq;
+	/* If polling, boost the frequency for the first poll cycle */
+	handle->boost = poll;
+	handle->poll = poll;
+	INIT_DELAYED_WORK(&handle->work, exynos5_int_cancel_boost);
+
+	mutex_lock(&exynos5_bus_int_requests_lock);
+	list_add_tail(&handle->node, &exynos5_bus_int_requests);
+	mutex_unlock(&exynos5_bus_int_requests_lock);
+
+	mutex_lock(&exynos5_bus_int_data_lock);
+
+	if (exynos5_bus_int_data) {
+		cancel_delayed_work_sync(&exynos5_bus_int_data->work);
+		exynos5_int_update(exynos5_bus_int_data);
+		exynos5_int_poll_start(exynos5_bus_int_data);
+	}
+
+	mutex_unlock(&exynos5_bus_int_data_lock);
+
+	if (handle->boost)
+		schedule_delayed_work(&handle->work, EXYNOS5_BUS_INT_POLL_TIME);
+
+	return handle;
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
+	data->curr_volt = initial_volt;
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
+	INIT_DELAYED_WORK(&data->work, exynos5_int_poll_work);
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
+	mutex_lock(&exynos5_bus_int_data_lock);
+	exynos5_bus_int_data = data;
+	mutex_unlock(&exynos5_bus_int_data_lock);
+
+	exynos5_int_update(data);
+	exynos5_int_poll_start(data);
+
+	return 0;
+
+err_devfreq_add:
+	devfreq_remove_device(data->devfreq);
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
+	mutex_lock(&exynos5_bus_int_data_lock);
+	exynos5_bus_int_data = NULL;
+	mutex_unlock(&exynos5_bus_int_data_lock);
+
+	devfreq_remove_device(data->devfreq);
+	exynos5_int_poll_stop(data);
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
+	struct platform_device *pdev = to_platform_device(dev);
+	struct opp *max_opp;
+	struct opp *opp;
+	unsigned long maxfreq = ULONG_MAX;
+	unsigned long volt;
+	unsigned long freq;
+	int err = 0;
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	exynos5_int_poll_stop(data);
+	/*
+	 * Set the frequency to the maximum enabled frequency, but set the
+	 * voltage to the maximum possible voltage in case the bootloader
+	 * sets the frequency to maximum during resume.
+	 */
+	mutex_lock(&data->lock);
+
+	data->disabled = true;
+
+	rcu_read_lock();
+	max_opp = opp_find_freq_floor(data->dev, &maxfreq);
+	if (IS_ERR(max_opp)) {
+		rcu_read_unlock();
+		err = PTR_ERR(max_opp);
+		goto unlock;
+	}
+
+	maxfreq = ULONG_MAX;
+	if (data->devfreq->max_freq)
+		maxfreq = data->devfreq->max_freq;
+
+	opp = opp_find_freq_floor(data->dev, &maxfreq);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
+		err = PTR_ERR(opp);
+		goto unlock;
+	}
+
+	freq = opp_get_freq(opp);
+	volt = opp_get_voltage(max_opp);
+	rcu_read_unlock();
+
+	err = exynos5_int_setvolt(data, volt);
+	if (err)
+		goto unlock;
+
+	err = clk_set_rate(data->int_clk, freq * 1000);
+	if (err)
+		goto unlock;
+
+	data->suspend_freq = freq;
+
+unlock:
+	mutex_unlock(&data->lock);
+	return err;
+}
+
+static int exynos5_busfreq_int_resume_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	int err = 0;
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+
+	/*
+	 * Set the frequency to the maximum enabled frequency in case the
+	 * bootloader raised it during resume.
+	 */
+	mutex_lock(&data->lock);
+
+	err = clk_set_rate(data->int_clk, data->suspend_freq * 1000);
+	if (err)
+		goto unlock;
+
+unlock:
+	mutex_unlock(&data->lock);
+	return err;
+}
+
+static int exynos5_busfreq_int_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+	int err = 0;
+
+	/* Restore the frequency and voltage to the values pre-suspend */
+	mutex_lock(&data->lock);
+
+	data->disabled = false;
+
+	err = clk_set_rate(data->int_clk, data->curr_freq * 1000);
+	if (err)
+		goto unlock;
+
+	err = exynos5_int_setvolt(data, data->curr_volt);
+	if (err)
+		goto unlock;
+
+unlock:
+	mutex_unlock(&data->lock);
+
+	if (!err)
+		exynos5_int_poll_start(data);
+
+	return err;
+}
+#endif
+
+static const struct dev_pm_ops exynos5_busfreq_int_pm = {
+	.suspend = exynos5_busfreq_int_suspend,
+	.resume_noirq = exynos5_busfreq_int_resume_noirq,
+	.resume = exynos5_busfreq_int_resume,
+};
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
diff --git a/drivers/devfreq/exynos5_ppmu.c b/drivers/devfreq/exynos5_ppmu.c
new file mode 100644
index 0000000..9752098
--- /dev/null
+++ b/drivers/devfreq/exynos5_ppmu.c
@@ -0,0 +1,395 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5 PPMU support
+ * Support for only EXYNOS5250 is present.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/hrtimer.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include <mach/map.h>
+
+#include "exynos_ppmu.h"
+#include "exynos5_ppmu.h"
+
+#define FIXED_POINT_OFFSET 8
+#define FIXED_POINT_MASK ((1 << FIXED_POINT_OFFSET) - 1)
+
+enum exynos5_ppmu_list {
+	PPMU_DDR_C,
+	PPMU_DDR_R1,
+	PPMU_DDR_L,
+	PPMU_RIGHT,
+	PPMU_CPU,
+	PPMU_END,
+};
+
+struct exynos5_ppmu_handle {
+	struct list_head node;
+	struct exynos_ppmu ppmu[PPMU_END];
+};
+
+static DEFINE_SPINLOCK(exynos5_ppmu_lock);
+static LIST_HEAD(exynos5_ppmu_handle_list);
+static struct exynos5_ppmu_handle *exynos5_ppmu_trace_handle;
+
+static const char *exynos5_ppmu_name[PPMU_END] = {
+	[PPMU_DDR_C]	= "DDR_C",
+	[PPMU_DDR_R1]	= "DDR_R1",
+	[PPMU_DDR_L]	= "DDR_L",
+	[PPMU_RIGHT]	= "RIGHT",
+	[PPMU_CPU]	= "CPU",
+};
+
+static struct exynos_ppmu ppmu[PPMU_END] = {
+	[PPMU_DDR_C] = {
+		.hw_base = S5P_VA_PPMU_DDR_C,
+	},
+	[PPMU_DDR_R1] = {
+		.hw_base = S5P_VA_PPMU_DDR_R1,
+	},
+	[PPMU_DDR_L] = {
+		.hw_base = S5P_VA_PPMU_DDR_L,
+	},
+	[PPMU_RIGHT] = {
+		.hw_base = S5P_VA_PPMU_RIGHT,
+	},
+	[PPMU_CPU] = {
+		.hw_base = S5P_VA_PPMU_CPU,
+	},
+};
+
+static void exynos5_ppmu_reset(struct exynos_ppmu *ppmu)
+{
+	unsigned long flags;
+
+	void __iomem *ppmu_base = ppmu->hw_base;
+
+	/* Reset PPMU */
+	exynos_ppmu_reset(ppmu_base);
+
+	/* Set PPMU Event */
+	ppmu->event[PPMU_PMNCNT0] = RD_DATA_COUNT;
+	exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT0,
+			ppmu->event[PPMU_PMNCNT0]);
+	ppmu->event[PPMU_PMCCNT1] = WR_DATA_COUNT;
+	exynos_ppmu_setevent(ppmu_base, PPMU_PMCCNT1,
+			ppmu->event[PPMU_PMCCNT1]);
+	ppmu->event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
+	exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
+			ppmu->event[PPMU_PMNCNT3]);
+
+	local_irq_save(flags);
+	ppmu->reset_time = ktime_get();
+	/* Start PPMU */
+	exynos_ppmu_start(ppmu_base);
+	local_irq_restore(flags);
+}
+
+static void exynos5_ppmu_read(struct exynos_ppmu *ppmu)
+{
+	int j;
+	unsigned long flags;
+	ktime_t read_time;
+	ktime_t t;
+	u32 reg;
+
+	void __iomem *ppmu_base = ppmu->hw_base;
+
+	local_irq_save(flags);
+	read_time = ktime_get();
+	/* Stop PPMU */
+	exynos_ppmu_stop(ppmu_base);
+	local_irq_restore(flags);
+
+	/* Update local data from PPMU */
+	ppmu->ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
+	reg = __raw_readl(ppmu_base + PPMU_FLAG);
+	ppmu->ccnt_overflow = reg & PPMU_CCNT_OVERFLOW;
+
+	for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+		if (ppmu->event[j] == 0)
+			ppmu->count[j] = 0;
+		else
+			ppmu->count[j] = exynos_ppmu_read(ppmu_base, j);
+	}
+	t = ktime_sub(read_time, ppmu->reset_time);
+	ppmu->ns = ktime_to_ns(t);
+}
+
+static void exynos5_ppmu_add(struct exynos_ppmu *to, struct exynos_ppmu *from)
+{
+	int i;
+	int j;
+
+	for (i = 0; i < PPMU_END; i++) {
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++)
+			to[i].count[j] += from[i].count[j];
+
+		to[i].ccnt += from[i].ccnt;
+		if (to[i].ccnt < from[i].ccnt)
+			to[i].ccnt_overflow = true;
+
+		to[i].ns += from[i].ns;
+
+		if (from[i].ccnt_overflow)
+			to[i].ccnt_overflow = true;
+	}
+}
+
+static void exynos5_ppmu_handle_clear(struct exynos5_ppmu_handle *handle)
+{
+	memset(&handle->ppmu, 0, sizeof(struct exynos_ppmu) * PPMU_END);
+}
+
+static void exynos5_ppmu_update(void)
+{
+	int i;
+	struct exynos5_ppmu_handle *handle;
+
+	for (i = 0; i < PPMU_END; i++) {
+		exynos5_ppmu_read(&ppmu[i]);
+		exynos5_ppmu_reset(&ppmu[i]);
+	}
+
+	list_for_each_entry(handle, &exynos5_ppmu_handle_list, node)
+		exynos5_ppmu_add(handle->ppmu, ppmu);
+}
+
+static int exynos5_ppmu_get_filter(enum exynos5_ppmu_sets filter,
+	enum exynos5_ppmu_list *start, enum exynos5_ppmu_list *end)
+{
+	switch (filter) {
+	case PPMU_SET_DDR:
+		*start = PPMU_DDR_C;
+		*end = PPMU_DDR_L;
+		break;
+	case PPMU_SET_RIGHT:
+		*start = PPMU_RIGHT;
+		*end = PPMU_RIGHT;
+		break;
+	case PPMU_SET_CPU:
+		*start = PPMU_CPU;
+		*end = PPMU_CPU;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int exynos5_ppmu_get_busy(struct exynos5_ppmu_handle *handle,
+	enum exynos5_ppmu_sets filter)
+{
+	unsigned long flags;
+	int i;
+	int busy = 0;
+	int temp;
+	enum exynos5_ppmu_list start;
+	enum exynos5_ppmu_list end;
+	int ret;
+
+	ret = exynos5_ppmu_get_filter(filter, &start, &end);
+	if (ret < 0)
+		return ret;
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_update();
+
+	for (i = start; i <= end; i++) {
+		if (handle->ppmu[i].ccnt_overflow) {
+			busy = -EOVERFLOW;
+			break;
+		}
+		temp = handle->ppmu[i].count[PPMU_PMNCNT3] * 100;
+		if (handle->ppmu[i].ccnt > 0)
+			temp /= handle->ppmu[i].ccnt;
+		if (temp > busy)
+			busy = temp;
+	}
+
+	exynos5_ppmu_handle_clear(handle);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	return busy;
+}
+
+static void exynos5_ppmu_put(struct exynos5_ppmu_handle *handle)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	list_del(&handle->node);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	kfree(handle);
+}
+
+struct exynos5_ppmu_handle *exynos5_ppmu_get(void)
+{
+	struct exynos5_ppmu_handle *handle;
+	unsigned long flags;
+
+	handle = kzalloc(sizeof(struct exynos5_ppmu_handle), GFP_KERNEL);
+	if (!handle)
+		return NULL;
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_update();
+	list_add_tail(&handle->node, &exynos5_ppmu_handle_list);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	return handle;
+}
+
+static int exynos5_ppmu_trace_init(void)
+{
+	exynos5_ppmu_trace_handle = exynos5_ppmu_get();
+	return 0;
+}
+late_initcall(exynos5_ppmu_trace_init);
+
+static void exynos5_ppmu_debug_compute(struct exynos_ppmu *ppmu,
+	enum ppmu_counter i, u32 *sat, u32 *freq, u32 *bw)
+{
+	u64 ns = ppmu->ns;
+	u32 busy = ppmu->count[i];
+	u32 total = ppmu->ccnt;
+
+	u64 s;
+	u64 f;
+	u64 b;
+
+	s = (u64)busy * 100 * (1 << FIXED_POINT_OFFSET);
+	s += total / 2;
+	do_div(s, total);
+
+	f = (u64)total * 1000 * (1 << FIXED_POINT_OFFSET);
+	f += ns / 2;
+	f = div64_u64(f, ns);
+
+	b = (u64)busy * (128 / 8) * 1000 * (1 << FIXED_POINT_OFFSET);
+	b += ns / 2;
+	b = div64_u64(b, ns);
+
+	*sat = s;
+	*freq = f;
+	*bw = b;
+}
+
+static void exynos5_ppmu_debug_show_one_counter(struct seq_file *s,
+	const char *name, const char *type, struct exynos_ppmu *ppmu,
+	enum ppmu_counter i, u32 *bw_total)
+{
+	u32 sat;
+	u32 freq;
+	u32 bw;
+
+	exynos5_ppmu_debug_compute(ppmu, i, &sat, &freq, &bw);
+
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps %3u.%02u MHz %2u.%02u%%\n",
+		name, type,
+		bw >> FIXED_POINT_OFFSET,
+		(bw & FIXED_POINT_MASK) * 100 / (1 << FIXED_POINT_OFFSET),
+		freq >> FIXED_POINT_OFFSET,
+		(freq & FIXED_POINT_MASK) * 100 / (1 << FIXED_POINT_OFFSET),
+		sat >> FIXED_POINT_OFFSET,
+		(sat & FIXED_POINT_MASK) * 100 / (1 << FIXED_POINT_OFFSET));
+
+	*bw_total += bw;
+}
+
+static void exynos5_ppmu_debug_show_one(struct seq_file *s,
+	const char *name, struct exynos_ppmu *ppmu,
+	u32 *bw_total)
+{
+	exynos5_ppmu_debug_show_one_counter(s, name, "read+write",
+		ppmu, PPMU_PMNCNT3, &bw_total[PPMU_PMNCNT3]);
+	exynos5_ppmu_debug_show_one_counter(s, "", "read",
+		ppmu, PPMU_PMNCNT0, &bw_total[PPMU_PMNCNT0]);
+	exynos5_ppmu_debug_show_one_counter(s, "", "write",
+		ppmu, PPMU_PMCCNT1, &bw_total[PPMU_PMCCNT1]);
+
+}
+
+static int exynos5_ppmu_debug_show(struct seq_file *s, void *d)
+{
+	int i;
+	u32 bw_total[PPMU_PMNCNT_MAX];
+	struct exynos5_ppmu_handle *handle;
+	unsigned long flags;
+
+	memset(bw_total, 0, sizeof(bw_total));
+
+	handle = exynos5_ppmu_get();
+	msleep(100);
+
+	spin_lock_irqsave(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_update();
+
+	for (i = 0; i < PPMU_CPU; i++)
+		exynos5_ppmu_debug_show_one(s, exynos5_ppmu_name[i],
+				&handle->ppmu[i], bw_total);
+
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps\n", "total", "read+write",
+		bw_total[PPMU_PMNCNT3] >> FIXED_POINT_OFFSET,
+		(bw_total[PPMU_PMNCNT3] & FIXED_POINT_MASK) *
+				100 / (1 << FIXED_POINT_OFFSET));
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps\n", "", "read",
+		bw_total[PPMU_PMNCNT0] >> FIXED_POINT_OFFSET,
+		(bw_total[PPMU_PMNCNT0] & FIXED_POINT_MASK) *
+				100 / (1 << FIXED_POINT_OFFSET));
+	seq_printf(s, "%-10s %-10s %4u.%02u MBps\n", "", "write",
+		bw_total[PPMU_PMCCNT1] >> FIXED_POINT_OFFSET,
+		(bw_total[PPMU_PMCCNT1] & FIXED_POINT_MASK) *
+				100 / (1 << FIXED_POINT_OFFSET));
+
+	seq_printf(s, "\n");
+
+	exynos5_ppmu_debug_show_one(s, exynos5_ppmu_name[PPMU_CPU],
+			&ppmu[PPMU_CPU], bw_total);
+
+	spin_unlock_irqrestore(&exynos5_ppmu_lock, flags);
+
+	exynos5_ppmu_put(handle);
+
+	return 0;
+}
+
+static int exynos5_ppmu_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, exynos5_ppmu_debug_show, inode->i_private);
+}
+
+static const struct file_operations exynos5_ppmu_debug_fops = {
+	.open		= exynos5_ppmu_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init exynos5_ppmu_debug_init(void)
+{
+	debugfs_create_file("exynos5_bus", S_IRUGO, NULL, NULL,
+		&exynos5_ppmu_debug_fops);
+	return 0;
+}
+late_initcall(exynos5_ppmu_debug_init);
diff --git a/drivers/devfreq/exynos5_ppmu.h b/drivers/devfreq/exynos5_ppmu.h
new file mode 100644
index 0000000..24d2ec4
--- /dev/null
+++ b/drivers/devfreq/exynos5_ppmu.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS5 PPMU header
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __DEVFREQ_EXYNOS5_PPMU_H
+#define __DEVFREQ_EXYNOS5_PPMU_H __FILE__
+
+enum exynos5_ppmu_sets {
+	PPMU_SET_DDR,
+	PPMU_SET_RIGHT,
+	PPMU_SET_CPU,
+};
+
+struct exynos5_ppmu_handle *exynos5_ppmu_get(void);
+int exynos5_ppmu_get_busy(struct exynos5_ppmu_handle *handle,
+	enum exynos5_ppmu_sets filter);
+
+#endif /* __DEVFREQ_EXYNOS5_PPMU_H */
+
diff --git a/drivers/devfreq/exynos_ppmu.c b/drivers/devfreq/exynos_ppmu.c
new file mode 100644
index 0000000..85fc5ac
--- /dev/null
+++ b/drivers/devfreq/exynos_ppmu.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS - PPMU support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include "exynos_ppmu.h"
+
+void exynos_ppmu_reset(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_CYCLE_RESET | PPMU_COUNTER_RESET, ppmu_base);
+	__raw_writel(PPMU_ENABLE_CYCLE  |
+		     PPMU_ENABLE_COUNT0 |
+		     PPMU_ENABLE_COUNT1 |
+		     PPMU_ENABLE_COUNT2 |
+		     PPMU_ENABLE_COUNT3,
+		     ppmu_base + PPMU_CNTENS);
+}
+
+void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
+			unsigned int evt)
+{
+	__raw_writel(evt, ppmu_base + PPMU_BEVTSEL(ch));
+}
+
+void exynos_ppmu_start(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_ENABLE, ppmu_base);
+}
+
+void exynos_ppmu_stop(void __iomem *ppmu_base)
+{
+	__raw_writel(PPMU_DISABLE, ppmu_base);
+}
+
+unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch)
+{
+	unsigned int total;
+
+	if (ch == PPMU_PMNCNT3)
+		total = ((__raw_readl(ppmu_base + PMCNT_OFFSET(ch)) << 8) |
+			  __raw_readl(ppmu_base + PMCNT_OFFSET(ch + 1)));
+	else
+		total = __raw_readl(ppmu_base + PMCNT_OFFSET(ch));
+
+	return total;
+}
diff --git a/drivers/devfreq/exynos_ppmu.h b/drivers/devfreq/exynos_ppmu.h
new file mode 100644
index 0000000..b46d31b
--- /dev/null
+++ b/drivers/devfreq/exynos_ppmu.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * EXYNOS PPMU header
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __DEVFREQ_EXYNOS_PPMU_H
+#define __DEVFREQ_EXYNOS_PPMU_H __FILE__
+
+#include <linux/ktime.h>
+
+/* For PPMU Control */
+#define PPMU_ENABLE             BIT(0)
+#define PPMU_DISABLE            0x0
+#define PPMU_CYCLE_RESET        BIT(1)
+#define PPMU_COUNTER_RESET      BIT(2)
+
+#define PPMU_ENABLE_COUNT0      BIT(0)
+#define PPMU_ENABLE_COUNT1      BIT(1)
+#define PPMU_ENABLE_COUNT2      BIT(2)
+#define PPMU_ENABLE_COUNT3      BIT(3)
+#define PPMU_ENABLE_CYCLE       BIT(31)
+
+#define PPMU_CNTENS		0x10
+#define PPMU_FLAG		0x50
+#define PPMU_CCNT_OVERFLOW	BIT(31)
+#define PPMU_CCNT		0x100
+
+#define PPMU_PMCNT0		0x110
+#define PPMU_PMCNT_OFFSET	0x10
+#define PMCNT_OFFSET(x)		(PPMU_PMCNT0 + (PPMU_PMCNT_OFFSET * x))
+
+#define PPMU_BEVT0SEL		0x1000
+#define PPMU_BEVTSEL_OFFSET	0x100
+#define PPMU_BEVTSEL(x)		(PPMU_BEVT0SEL + (ch * PPMU_BEVTSEL_OFFSET))
+
+/* For Event Selection */
+#define RD_DATA_COUNT		0x5
+#define WR_DATA_COUNT		0x6
+#define RDWR_DATA_COUNT		0x7
+
+enum ppmu_counter {
+	PPMU_PMNCNT0,
+	PPMU_PMCCNT1,
+	PPMU_PMNCNT2,
+	PPMU_PMNCNT3,
+	PPMU_PMNCNT_MAX,
+};
+
+struct bus_opp_table {
+	unsigned int idx;
+	unsigned long clk;
+	unsigned long volt;
+};
+
+struct exynos_ppmu {
+	void __iomem *hw_base;
+	unsigned int ccnt;
+	unsigned int event[PPMU_PMNCNT_MAX];
+	unsigned int count[PPMU_PMNCNT_MAX];
+	unsigned long long ns;
+	ktime_t reset_time;
+	bool ccnt_overflow;
+	bool count_overflow[PPMU_PMNCNT_MAX];
+};
+
+void exynos_ppmu_reset(void __iomem *ppmu_base);
+void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
+			unsigned int evt);
+void exynos_ppmu_start(void __iomem *ppmu_base);
+void exynos_ppmu_stop(void __iomem *ppmu_base);
+unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch);
+#endif /* __DEVFREQ_EXYNOS_PPMU_H */
+
-- 
1.6.6.1

