Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab2LTHlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:41:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29477 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2LTHlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:41:01 -0500
X-AuditID: cbfee61b-b7f616d00000319b-10-50d2c10b509b
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Aleessandro Zummo <a.zummo@towertech.it>,
        a.kesavan@samsung.com, akpm@linux-foundation.org, joe@perches.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myugnjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] RTC: MAX77686: Add Maxim 77686 driver
Date: Thu, 20 Dec 2012 16:40:53 +0900
Message-id: <1355989253-27471-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zHV3ug5cCDE48F7a4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ21+dYy7YN5Oxovv0K/YGxvM1XYycHBICJhIzL39mhLDFJC7c
	W8/WxcjFISSwjFFiw/xfLDBFr/9OgEosYpTYNfMEI4SzlEniwc0GJpAqNgEdif/7brKD2CIC
	ChKbe5+xghQxC+xkkjg6bwUbSEJYwFKi7d02sH0sAqoSi483gNm8Ah4Sb86dBmrgAFqnIDFn
	kg1EiYDEt8mHWCDCshKbDjCDjJQQ2MMmcXrNbajrJCUOrrjBMoFRcAEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2MkLCS3sG4qsHiEKMAB6MSD++iaZcChFgTy4orcw8xSnAwK4nwLrx1
	MUCINyWxsiq1KD++qDQntfgQow/QJROZpUST84Ehn1cSb2hsYGxoaGloZmppaoBDWEmct9kj
	JUBIID2xJDU7NbUgtQhmHBMHp1QDo0Co0NMFxmGTzh1u3qGQc3XfxZ8dAkrZn0/qcWSLVX79
	fH6X+H6O78fWCIVtyMyTuW27X1avi13kvfb9+5I3OMycDlmWHex4VrLNout8pnpw4wmndfO7
	ApYoXI3WL2IR5Dz35JPwzV/vD8XwLLIvir8dI2dbebf4yU6OpB3FD108nn028IjVUGIpzkg0
	1GIuKk4EAB0qpmVYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jAV3ug5cCDF4cZrO4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGdtfnWMu2DeTsaL79Cv2
	BsbzNV2MnBwSAiYSr/9OYIOwxSQu3FsPZHNxCAksYpTYNfMEI4SzlEniwc0GJpAqNgEdif/7
	brKD2CICChKbe5+xghQxC+xkkjg6bwXYKGEBS4m2d9sYQWwWAVWJxccbwGxeAQ+JN+dOAzVw
	AK1TkJgzyWYCI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFB+0x6B+OqBotDjAIc
	jEo8vIumXQoQYk0sK67MPcQowcGsJMK78NbFACHelMTKqtSi/Pii0pzU4kOMPkDLJzJLiSbn
	AyMqryTe0NjEzMjSyMzYxNzYGIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQZGNuUfVlMu
	JLBV3XsXH3rMc/nrmHymBRWrKoxEfmxs8apPr2LN+fdJUPvn6m+Nz8JYlpzpMfieu//H26zy
	Kwd/HXnw/shmV/sLH4zDtk0uO1ggKZamWHEu7rxtvebdqSxS79iaZfK+1qpc/2xwtv5hy4qv
	J0oOHmefvW9bfdl2izWvr11e1LEqWImlOCPRUIu5qDgRAKpabi6HAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for support max77686 rtc.
MAX77686 rtc support smpl and wtsr mode. It has two alarm register
which can be used for alarming to wake system up. This drvier uses regmap
to access its register.

Signed-off-by: Chiwoong Byun <woong.byun@samsung.com>
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myugnjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2
 Code cleaning referring to Andrew's comments.
 - Add MAX77686's WTSR, SMPL kernel configuration options.
 - Remove __devinit, __devexit, __devexit_p , since COFIG_HOTPLUG doesn't exixted anymore.
 - Swap max77686_rtc_calculate_wday() function with fls().
 - Remove usless inline definition.

 drivers/rtc/Kconfig        |   30 +++
 drivers/rtc/Makefile       |    1 +
 drivers/rtc/rtc-max77686.c |  642 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 673 insertions(+)
 create mode 100644 drivers/rtc/rtc-max77686.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 19c03ab..94da7ec 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -233,6 +233,36 @@ config RTC_DRV_MAX8998
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max8998.
 
+config RTC_DRV_MAX77686
+	tristate "Maxim MAX77686"
+	depends on MFD_MAX77686
+	help
+	  If you say yes here you will get support for the
+	  RTC of Maxim MAX77686 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-max77686.
+
+config MAX77686_RTC_WTSR
+	bool "MAX77686_RTC_WTSR"
+	depends on RTC_DRV_MAX77686
+	help
+	  MAX77686 rtc can supports WTSR(Watchdog Timeout and Software Reset).
+	  WTSR event would keep the PMIC on regardless of PWRHOLD signal.
+	  When PWRHOLD signal is falling, it turns on WTSR timer rather executes
+	  reset imidiately. After timer expiring, it determine to reset the PMIC
+	  depends on PWRHOLD state.
+
+config MAX77686_RTC_SMPL
+	bool "MAX77686_RTC_SMPL"
+	depends on RTC_DRV_MAX77686
+	help
+	  MAX77686 rtc can supports SMPL(Sudden Momentary Power Loss).
+	  SMPL function can be used to intiate a power up sequence after momentarily
+	  loosing contact to the battery pack. If battery goes under UVLO(Under
+	  Lock Out) it starts SMPL timer. After timer exipiring, it checks battery
+	  whether its state recovers from UVLO or not to make power supplies keep on.
+
 config RTC_DRV_RS5C372
 	tristate "Ricoh R2025S/D, RS5C372A/B, RV5C386, RV5C387A"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 56297f0..3cc94c9 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_RTC_DRV_MAX8907)	+= rtc-max8907.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
 obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
+obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
 obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
 obj-$(CONFIG_RTC_DRV_MSM6242)	+= rtc-msm6242.o
 obj-$(CONFIG_RTC_DRV_MPC5121)	+= rtc-mpc5121.o
diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
new file mode 100644
index 0000000..51f5365
--- /dev/null
+++ b/drivers/rtc/rtc-max77686.c
@@ -0,0 +1,642 @@
+/*
+ * RTC driver for Maxim MAX77686
+ *
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ *
+ *  based on rtc-max8997.c
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/rtc.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/irqdomain.h>
+#include <linux/regmap.h>
+
+/* RTC Control Register */
+#define BCD_EN_SHIFT			0
+#define BCD_EN_MASK				(1 << BCD_EN_SHIFT)
+#define MODEL24_SHIFT			1
+#define MODEL24_MASK			(1 << MODEL24_SHIFT)
+/* RTC Update Register1 */
+#define RTC_UDR_SHIFT			0
+#define RTC_UDR_MASK			(1 << RTC_UDR_SHIFT)
+#define RTC_RBUDR_SHIFT			4
+#define RTC_RBUDR_MASK			(1 << RTC_RBUDR_SHIFT)
+/* WTSR and SMPL Register */
+#define WTSRT_SHIFT				0
+#define SMPLT_SHIFT				2
+#define WTSR_EN_SHIFT			6
+#define SMPL_EN_SHIFT			7
+#define WTSRT_MASK				(3 << WTSRT_SHIFT)
+#define SMPLT_MASK				(3 << SMPLT_SHIFT)
+#define WTSR_EN_MASK			(1 << WTSR_EN_SHIFT)
+#define SMPL_EN_MASK			(1 << SMPL_EN_SHIFT)
+/* RTC Hour register */
+#define HOUR_PM_SHIFT			6
+#define HOUR_PM_MASK			(1 << HOUR_PM_SHIFT)
+/* RTC Alarm Enable */
+#define ALARM_ENABLE_SHIFT		7
+#define ALARM_ENABLE_MASK		(1 << ALARM_ENABLE_SHIFT)
+
+#define MAX77686_RTC_UPDATE_DELAY	16
+
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_MONTH,
+	RTC_YEAR,
+	RTC_DATE,
+	RTC_NR_TIME
+};
+
+struct max77686_rtc_info {
+	struct device		*dev;
+	struct max77686_dev	*max77686;
+	struct i2c_client	*rtc;
+	struct rtc_device	*rtc_dev;
+	struct mutex		lock;
+
+	struct regmap		*regmap;
+
+	int virq;
+	int rtc_24hr_mode;
+};
+
+enum MAX77686_RTC_OP {
+	MAX77686_RTC_WRITE,
+	MAX77686_RTC_READ,
+};
+
+static void max77686_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
+				   int rtc_24hr_mode)
+{
+	tm->tm_sec = data[RTC_SEC] & 0x7f;
+	tm->tm_min = data[RTC_MIN] & 0x7f;
+	if (rtc_24hr_mode)
+		tm->tm_hour = data[RTC_HOUR] & 0x1f;
+	else {
+		tm->tm_hour = data[RTC_HOUR] & 0x0f;
+		if (data[RTC_HOUR] & HOUR_PM_MASK)
+			tm->tm_hour += 12;
+	}
+
+	tm->tm_wday = fls(data[RTC_WEEKDAY] & 0x7f) - 1;
+	tm->tm_mday = data[RTC_DATE] & 0x1f;
+	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
+	tm->tm_year = (data[RTC_YEAR] & 0x7f) + 100;
+	tm->tm_yday = 0;
+	tm->tm_isdst = 0;
+}
+
+static int max77686_rtc_tm_to_data(struct rtc_time *tm, u8 *data)
+{
+	data[RTC_SEC] = tm->tm_sec;
+	data[RTC_MIN] = tm->tm_min;
+	data[RTC_HOUR] = tm->tm_hour;
+	data[RTC_WEEKDAY] = 1 << tm->tm_wday;
+	data[RTC_DATE] = tm->tm_mday;
+	data[RTC_MONTH] = tm->tm_mon + 1;
+	data[RTC_YEAR] = tm->tm_year > 100 ? (tm->tm_year - 100) : 0 ;
+
+	if (tm->tm_year < 100) {
+		pr_warn("%s: MAX77686 RTC cannot handle the year %d."
+			"Assume it's 2000.\n", __func__,
+			1900 + tm->tm_year);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int max77686_rtc_update(struct max77686_rtc_info *info,
+	enum MAX77686_RTC_OP op)
+{
+	int ret;
+	unsigned int data;
+
+	switch (op) {
+	case MAX77686_RTC_WRITE:
+		data = 1 << RTC_UDR_SHIFT;
+		break;
+	case MAX77686_RTC_READ:
+		data = 1 << RTC_RBUDR_SHIFT;
+		break;
+	}
+
+	ret = regmap_update_bits(info->max77686->rtc_regmap,
+				 MAX77686_RTC_UPDATE0, data, data);
+	if (ret < 0)
+		dev_err(info->dev, "%s: fail to write update reg(ret=%d, data=0x%x)\n",
+				__func__, ret, data);
+	else {
+		/* Minimum 16ms delay required before RTC update. */
+		msleep(MAX77686_RTC_UPDATE_DELAY);
+	}
+
+	return ret;
+}
+
+static int max77686_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max77686_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_read(info->max77686->rtc_regmap,
+				MAX77686_RTC_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read time reg(%d)\n",
+			__func__, ret);
+		goto out;
+	}
+
+	max77686_rtc_data_to_tm(data, tm, info->rtc_24hr_mode);
+
+	ret = rtc_valid_tm(tm);
+
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max77686_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max77686_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	ret = max77686_rtc_tm_to_data(tm, data);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&info->lock);
+
+	ret = regmap_bulk_write(info->max77686->rtc_regmap,
+				 MAX77686_RTC_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
+				ret);
+		goto out;
+	}
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_WRITE);
+
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max77686_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max77686_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	unsigned int val;
+	int i, ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_read(info->max77686->rtc_regmap,
+				 MAX77686_ALARM1_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
+				__func__, __LINE__, ret);
+		goto out;
+	}
+
+	max77686_rtc_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
+
+	alrm->enabled = 0;
+	for (i = 0; i < RTC_NR_TIME; i++) {
+		if (data[i] & ALARM_ENABLE_MASK) {
+			alrm->enabled = 1;
+			break;
+		}
+	}
+
+	alrm->pending = 0;
+	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS1, &val);
+	if (ret < 0) {
+		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
+				__func__, __LINE__, ret);
+		goto out;
+	}
+
+	if (val & (1 << 4)) /* RTCA1 */
+		alrm->pending = 1;
+
+out:
+	mutex_unlock(&info->lock);
+	return 0;
+}
+
+static int max77686_rtc_stop_alarm(struct max77686_rtc_info *info)
+{
+	u8 data[RTC_NR_TIME];
+	int ret, i;
+	struct rtc_time tm;
+
+	if (!mutex_is_locked(&info->lock))
+		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_read(info->max77686->rtc_regmap,
+				 MAX77686_ALARM1_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	max77686_rtc_data_to_tm(data, &tm, info->rtc_24hr_mode);
+
+	for (i = 0; i < RTC_NR_TIME; i++)
+		data[i] &= ~ALARM_ENABLE_MASK;
+
+	ret = regmap_bulk_write(info->max77686->rtc_regmap,
+				 MAX77686_ALARM1_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_WRITE);
+out:
+	return ret;
+}
+
+static int max77686_rtc_start_alarm(struct max77686_rtc_info *info)
+{
+	u8 data[RTC_NR_TIME];
+	int ret;
+	struct rtc_time tm;
+
+	if (!mutex_is_locked(&info->lock))
+		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_READ);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_read(info->max77686->rtc_regmap,
+				 MAX77686_ALARM1_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	max77686_rtc_data_to_tm(data, &tm, info->rtc_24hr_mode);
+
+	data[RTC_SEC] |= (1 << ALARM_ENABLE_SHIFT);
+	data[RTC_MIN] |= (1 << ALARM_ENABLE_SHIFT);
+	data[RTC_HOUR] |= (1 << ALARM_ENABLE_SHIFT);
+	data[RTC_WEEKDAY] &= ~ALARM_ENABLE_MASK;
+	if (data[RTC_MONTH] & 0xf)
+		data[RTC_MONTH] |= (1 << ALARM_ENABLE_SHIFT);
+	if (data[RTC_YEAR] & 0x7f)
+		data[RTC_YEAR] |= (1 << ALARM_ENABLE_SHIFT);
+	if (data[RTC_DATE] & 0x1f)
+		data[RTC_DATE] |= (1 << ALARM_ENABLE_SHIFT);
+
+	ret = regmap_bulk_write(info->max77686->rtc_regmap,
+				 MAX77686_ALARM1_SEC, data, RTC_NR_TIME);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_WRITE);
+out:
+	return ret;
+}
+
+static int max77686_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max77686_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	ret = max77686_rtc_tm_to_data(&alrm->time, data);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max77686_rtc_stop_alarm(info);
+	if (ret < 0)
+		goto out;
+
+	ret = regmap_bulk_write(info->max77686->rtc_regmap,
+				 MAX77686_ALARM1_SEC, data, RTC_NR_TIME);
+
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_WRITE);
+	if (ret < 0)
+		goto out;
+
+	if (alrm->enabled)
+		ret = max77686_rtc_start_alarm(info);
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max77686_rtc_alarm_irq_enable(struct device *dev,
+					unsigned int enabled)
+{
+	struct max77686_rtc_info *info = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&info->lock);
+	if (enabled)
+		ret = max77686_rtc_start_alarm(info);
+	else
+		ret = max77686_rtc_stop_alarm(info);
+	mutex_unlock(&info->lock);
+
+	return ret;
+}
+
+static irqreturn_t max77686_rtc_alarm_irq(int irq, void *data)
+{
+	struct max77686_rtc_info *info = data;
+
+	dev_info(info->dev, "%s:irq(%d)\n", __func__, irq);
+
+	rtc_update_irq(info->rtc_dev, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops max77686_rtc_ops = {
+	.read_time = max77686_rtc_read_time,
+	.set_time = max77686_rtc_set_time,
+	.read_alarm = max77686_rtc_read_alarm,
+	.set_alarm = max77686_rtc_set_alarm,
+	.alarm_irq_enable = max77686_rtc_alarm_irq_enable,
+};
+
+#ifdef MAX77686_RTC_WTSR
+static void max77686_rtc_enable_wtsr(struct max77686_rtc_info *info,
+					bool enable)
+{
+	int ret;
+	unsigned int val, mask;
+
+	if (enable)
+		val = (1 << WTSR_EN_SHIFT) | (3 << WTSRT_SHIFT);
+	else
+		val = 0;
+
+	mask = WTSR_EN_MASK | WTSRT_MASK;
+
+	dev_info(info->dev, "%s: %s WTSR\n", __func__,
+			enable ? "enable" : "disable");
+
+	ret = regmap_update_bits(info->max77686->rtc_regmap,
+				 MAX77686_WTSR_SMPL_CNTL, mask, val);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
+				__func__, ret);
+		return;
+	}
+
+	max77686_rtc_update(info, MAX77686_RTC_WRITE);
+}
+#else
+static void max77686_rtc_enable_wtsr(struct max77686_rtc_info *info,
+					bool enable) {}
+#endif /* MAX77686_RTC_WTSR */
+#ifdef MAX77686_RTC_SMPL
+static void max77686_rtc_enable_smpl(struct max77686_rtc_info *info,
+					bool enable)
+{
+	int ret;
+	unsigned int val, mask;
+
+	if (enable)
+		val = (1 << SMPL_EN_SHIFT) | (0 << SMPLT_SHIFT);
+	else
+		val = 0;
+
+	mask = SMPL_EN_MASK | SMPLT_MASK;
+
+	dev_info(info->dev, "%s: %s SMPL\n", __func__,
+			enable ? "enable" : "disable");
+
+	ret = regmap_update_bits(info->max77686->rtc_regmap,
+				 MAX77686_WTSR_SMPL_CNTL, mask, val);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
+				__func__, ret);
+		return;
+	}
+
+	max77686_rtc_update(info, MAX77686_RTC_WRITE);
+
+	val = 0;
+	regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
+	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
+}
+#else
+static void max77686_rtc_enable_smpl(struct max77686_rtc_info *info,
+					bool enable) {}
+#endif /* MAX77686_RTC_SMPL */
+
+static int max77686_rtc_init_reg(struct max77686_rtc_info *info)
+{
+	u8 data[2];
+	int ret;
+
+	/* Set RTC control register : Binary mode, 24hour mdoe */
+	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+
+	info->rtc_24hr_mode = 1;
+
+	ret = regmap_bulk_write(info->max77686->rtc_regmap,
+				MAX77686_RTC_CONTROLM, data, 2);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
+				__func__, ret);
+		return ret;
+	}
+
+	ret = max77686_rtc_update(info, MAX77686_RTC_WRITE);
+	return ret;
+}
+
+static struct regmap_config max77686_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int max77686_rtc_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *max77686 = dev_get_drvdata(pdev->dev.parent);
+	struct max77686_rtc_info *info;
+	int ret, virq;
+
+	pr_info("%s\n", __func__);
+
+	info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	mutex_init(&info->lock);
+	info->dev = &pdev->dev;
+	info->max77686 = max77686;
+	info->rtc = max77686->rtc;
+	info->max77686->rtc_regmap = regmap_init_i2c(info->max77686->rtc,
+					 &max77686_rtc_regmap_config);
+	if (IS_ERR(info->max77686->rtc_regmap)) {
+		ret = PTR_ERR(info->max77686->rtc_regmap);
+		dev_err(info->max77686->dev, "Failed to allocate register map: %d\n",
+				ret);
+		kfree(info);
+		return ret;
+	}
+	platform_set_drvdata(pdev, info);
+
+	ret = max77686_rtc_init_reg(info);
+
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
+		goto err_rtc;
+	}
+
+	max77686_rtc_enable_wtsr(info, true);
+	max77686_rtc_enable_smpl(info, true);
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	info->rtc_dev = rtc_device_register("max77686-rtc", &pdev->dev,
+			&max77686_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(info->rtc_dev)) {
+		pr_info("%s: fail\n", __func__);
+
+		ret = PTR_ERR(info->rtc_dev);
+		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+		if (ret == 0)
+			ret = -EINVAL;
+		goto err_rtc;
+	}
+	virq = irq_create_mapping(max77686->irq_domain, MAX77686_RTCIRQ_RTCA1);
+	if (!virq)
+		goto err_rtc;
+	info->virq = virq;
+
+	ret = request_threaded_irq(virq, NULL, max77686_rtc_alarm_irq, 0,
+			"rtc-alarm0", info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
+			info->virq, ret);
+		goto err_rtc;
+	}
+
+	goto out;
+err_rtc:
+	kfree(info);
+	return ret;
+out:
+	return ret;
+}
+
+static int max77686_rtc_remove(struct platform_device *pdev)
+{
+	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
+
+	if (info) {
+		free_irq(info->virq, info);
+		rtc_device_unregister(info->rtc_dev);
+		kfree(info);
+	}
+
+	return 0;
+}
+
+static void max77686_rtc_shutdown(struct platform_device *pdev)
+{
+	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
+	int i;
+	u8 val = 0;
+
+	for (i = 0; i < 3; i++) {
+		max77686_rtc_enable_wtsr(info, false);
+		regmap_read(info->max77686->rtc_regmap,
+				MAX77686_WTSR_SMPL_CNTL, &val);
+		pr_info("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
+		if (val & WTSR_EN_MASK)
+			pr_emerg("%s: fail to disable WTSR\n", __func__);
+		else {
+			pr_info("%s: success to disable WTSR\n", __func__);
+			break;
+		}
+	}
+
+	max77686_rtc_enable_smpl(info, false);
+}
+
+static const struct platform_device_id rtc_id[] = {
+	{ "max77686-rtc", 0 },
+	{},
+};
+
+static struct platform_driver max77686_rtc_driver = {
+	.driver		= {
+		.name	= "max77686-rtc",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= max77686_rtc_probe,
+	.remove		= max77686_rtc_remove,
+	.shutdown	= max77686_rtc_shutdown,
+	.id_table	= rtc_id,
+};
+
+static int __init max77686_rtc_init(void)
+{
+	return platform_driver_register(&max77686_rtc_driver);
+}
+module_init(max77686_rtc_init);
+
+static void __exit max77686_rtc_exit(void)
+{
+	platform_driver_unregister(&max77686_rtc_driver);
+}
+module_exit(max77686_rtc_exit);
+
+MODULE_DESCRIPTION("Maxim MAX77686 RTC driver");
+MODULE_AUTHOR("<woong.byun@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

