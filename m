Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2L1L3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:29:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48798 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2L1L3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:29:05 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-18-50dd827ecf53
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, naveenkrishna.ch@gmail.com,
        kgene.kim@samsung.com, grant.likely@secretlab.ca,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        taeggyun.ko@samsung.com, balbi@ti.com, thomas.abraham@linaro.org
Subject: [PATCH v3] i2c: exynos5: add High Speed I2C controller driver
Date: Fri, 28 Dec 2012 16:57:03 +0530
Message-id: <1356694023-32470-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkSreu6W6Awa8nhhYdf78wWlzeNYfN
	Ysb5fUwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZTR2xhT8X89YseHYI8YGxn0TGLsYOTkkBEwk
	WpZuYYKwxSQu3FvP1sXIxSEksJRRYtuKtWwwRSd/PGaFSCxilHh8dj4ThNPDJDG5+z8zSBWb
	gJnEwUWr2UFsEQFZidYHa5hBipgF9jJJnLt2ngUkISzgJrH1UxNYA4uAqsSGv9vBVvAKuEps
	3fsdqIYDaJ2CxJxJNiAmJ1D5osvlIBVCQBX3/y6C6hSQ+Db5EFS1rMSmA2CbJAQes0mc3f0f
	6mhJiYMrbrBMYBRewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyMwME//eya1g3Flg8Uh
	RgEORiUe3oU9dwKEWBPLiitzDzFKcDArifDq/wAK8aYkVlalFuXHF5XmpBYfYvQBumQis5Ro
	cj4wavJK4g2NTcxNjU0tjYzMTE1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYExeINXg
	6RqrPKlYgmEz93GusIqdeVkvMt5urb9x9AD/oceKRTr7pvPvknNbyHBRnPlqv4RrqWFn0FPj
	zY9+3b7wSOoWM5tx//sLRkff/ghpie28csru57mUFglTof6zJ55x7l5T1VMgvHuRCNOJyFVy
	r/8alX8zO7Pb5MmWMrWHwkcur/z67KASS3FGoqEWc1FxIgDbUOWPeQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAd26prsBBl+uilt0/P3CaHF51xw2
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR2BlT
	8H89Y8WGY48YGxj3TWDsYuTkkBAwkTj54zErhC0mceHeerYuRi4OIYFFjBKPz85ngnB6mCQm
	d/9nBqliEzCTOLhoNTuILSIgK9H6YA0zSBGzwF4miXPXzrOAJIQF3CS2fmoCa2ARUJXY8Hc7
	G4jNK+AqsXXvd6AaDqB1ChJzJtmAmJxA5Ysul4NUCAFV3P+7iHkCI+8CRoZVjKKpBckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGMFh/0xqB+PKBotDjAIcjEo8vAt77gQIsSaWFVfmHmKU4GBWEuHV
	/wEU4k1JrKxKLcqPLyrNSS0+xOgDdNNEZinR5HxgTOaVxBsam5ibGptamliYmFniEFYS5232
	SAkQEkhPLEnNTk0tSC2CGcfEwSnVwLi5wumkpKcso+97JRPTmx6bS5Ym8kTyzZbPaviR7aAd
	xON18uEar5iXu9QyX5pu0D++dmv79f8Vu9Z57pDj/sUis66wrO3vj9u7gjQF3XQUDh6pV/ww
	rSs14YQUv3tu+6E0RxHfrjKBJflJQWWGrHsc9qZO8bmtXv5z75s9cTulZnSF5dR5KLEUZyQa
	ajEXFScCAGQHfLioAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for High Speed I2C driver found in Exynos5 and later
SoCs from Samsung. This driver currently supports Auto mode.

Driver only supports Device Tree method of passing platform data.
Note: Added debugfs support for registers view, not tested.

Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v2: fixed comments from Felipe Balbi.
	And minor fixes for the return values in exynos5_i2c_doxfer()

 drivers/i2c/busses/Kconfig       |    7 +
 drivers/i2c/busses/Makefile      |    1 +
 drivers/i2c/busses/i2c-exynos5.c |  736 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 744 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-exynos5.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index bdca511..4caea76 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -618,6 +618,13 @@ config I2C_S3C2410
 	  Say Y here to include support for I2C controller in the
 	  Samsung SoCs.
 
+config I2C_EXYNOS5
+	tristate "Exynos5 high-speed I2C driver"
+	depends on ARCH_EXYNOS5
+	help
+	  Say Y here to include support for High-speed I2C controller in the
+	  Exynos5 based Samsung SoCs.
+
 config I2C_S6000
 	tristate "S6000 I2C support"
 	depends on XTENSA_VARIANT_S6000
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 6181f3f..4b1548c 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_I2C_PUV3)		+= i2c-puv3.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
 obj-$(CONFIG_I2C_PXA_PCI)	+= i2c-pxa-pci.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
+obj-$(CONFIG_I2C_EXYNOS5)	+= i2c-exynos5.o
 obj-$(CONFIG_I2C_S6000)		+= i2c-s6000.o
 obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
 obj-$(CONFIG_I2C_SH_MOBILE)	+= i2c-sh_mobile.o
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
new file mode 100644
index 0000000..a5eb959
--- /dev/null
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -0,0 +1,736 @@
+/**
+ * i2c-exynos5.c - Samsung Exynos5 I2C Controller Driver
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
+#include <linux/of_i2c.h>
+
+/* Register Map */
+#define HSI2C_CTL		0x00
+#define HSI2C_FIFO_CTL		0x04
+#define HSI2C_TRAILIG_CTL	0x08
+#define HSI2C_CLK_CTL		0x0C
+#define HSI2C_CLK_SLOT		0x10
+#define HSI2C_INT_ENABLE	0x20
+#define HSI2C_INT_STATUS	0x24
+#define HSI2C_ERR_STATUS	0x2C
+#define HSI2C_FIFO_STATUS	0x30
+#define HSI2C_TX_DATA		0x34
+#define HSI2C_RX_DATA		0x38
+#define HSI2C_CONF		0x40
+#define HSI2C_AUTO_CONF		0x44
+#define HSI2C_TIMEOUT		0x48
+#define HSI2C_MANUAL_CMD	0x4C
+#define HSI2C_TRANS_STATUS	0x50
+#define HSI2C_TIMING_HS1	0x54
+#define HSI2C_TIMING_HS2	0x58
+#define HSI2C_TIMING_HS3	0x5C
+#define HSI2C_TIMING_FS1	0x60
+#define HSI2C_TIMING_FS2	0x64
+#define HSI2C_TIMING_FS3	0x68
+#define HSI2C_TIMING_SLA	0x6C
+#define HSI2C_ADDR		0x70
+
+/* I2C_CTL Register bits */
+#define HSI2C_FUNC_MODE_I2C			(1u << 0)
+#define HSI2C_MASTER				(1u << 3)
+#define HSI2C_RXCHON				(1u << 6)
+#define HSI2C_TXCHON				(1u << 7)
+#define HSI2C_SW_RST				(1u << 31)
+
+/* I2C_FIFO_CTL Register bits */
+#define HSI2C_RXFIFO_EN				(1u << 0)
+#define HSI2C_TXFIFO_EN				(1u << 1)
+#define HSI2C_TXFIFO_TRIGGER_LEVEL		(0x20 << 16)
+#define HSI2C_RXFIFO_TRIGGER_LEVEL		(0x20 << 4)
+
+/* I2C_TRAILING_CTL Register bits */
+#define HSI2C_TRAILING_COUNT			(0xf)
+
+/* I2C_INT_EN Register bits */
+#define HSI2C_INT_TX_ALMOSTEMPTY_EN		(1u << 0)
+#define HSI2C_INT_RX_ALMOSTFULL_EN		(1u << 1)
+#define HSI2C_INT_TRAILING_EN			(1u << 6)
+#define HSI2C_INT_I2C_EN			(1u << 9)
+
+/* I2C_FIFO_STAT Register bits */
+#define HSI2C_RX_FIFO_EMPTY			(1u << 24)
+#define HSI2C_RX_FIFO_FULL			(1u << 23)
+#define HSI2C_RX_FIFO_LEVEL_MASK		(0x7 << 16)
+#define HSI2C_TX_FIFO_EMPTY			(1u << 8)
+#define HSI2C_TX_FIFO_FULL			(1u << 7)
+#define HSI2C_TX_FIFO_LEVEL_MASK		(0x7 << 7)
+#define HSI2C_FIFO_EMPTY			(0x1000100)
+
+/* I2C_CONF Register bits */
+#define HSI2C_AUTO_MODE				(1u << 31)
+#define HSI2C_10BIT_ADDR_MODE			(1u << 30)
+#define HSI2C_HS_MODE				(1u << 29)
+
+/* I2C_AUTO_CONF Register bits */
+#define HSI2C_READ_WRITE			(1u << 16)
+#define HSI2C_STOP_AFTER_TRANS			(1u << 17)
+#define HSI2C_MASTER_RUN			(1u << 31)
+
+/* I2C_TIMEOUT Register bits */
+#define HSI2C_TIMEOUT_EN			(1u << 31)
+
+/* I2C_TRANS_STATUS register bits */
+#define HSI2C_MASTER_BUSY			(1u << 17)
+#define HSI2C_SLAVE_BUSY			(1u << 16)
+#define HSI2C_NO_DEV				(1u << 3)
+#define HSI2C_NO_DEV_ACK			(1u << 2)
+#define HSI2C_TRANS_ABORT			(1u << 1)
+#define HSI2C_TRANS_DONE			(1u << 0)
+
+/**
+ * Although exynos5 supports max HS-IIC speed of 3.4Mhz,
+ * but currently we are facing booting issues beyond 1Mhz
+ * So limiting HS-IIC bus speed to 1Mhz
+*/
+#define HSI2C_HS_TX_CLOCK	1000000
+#define HSI2C_FS_TX_CLOCK	400000
+
+#define HSI2C_FAST_SPD		0
+#define HSI2C_HIGH_SPD		1
+
+#define EXYNOS5_I2C_TIMEOUT (msecs_to_jiffies(1000))
+
+/* timeout for pm runtime autosuspend */
+#define EXYNOS5_I2C_PM_TIMEOUT		1000	/* ms */
+
+struct exynos5_i2c {
+	struct i2c_adapter	adap;
+	unsigned int		suspended:1;
+
+	struct i2c_msg		*msg;
+	unsigned int		msg_idx;
+	struct completion	msg_complete;
+	unsigned int		msg_ptr;
+
+	unsigned int		irq;
+
+	void __iomem		*regs;
+	struct clk		*clk;
+	struct device		*dev;
+	int			gpios[2];
+
+	int			bus_num;
+	int			speed_mode;
+	struct dentry		*debugfs_root;
+};
+
+static const struct of_device_id exynos5_i2c_match[] = {
+	{ .compatible = "samsung,exynos5-hsi2c" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
+
+static void exynos5_i2c_stop(struct exynos5_i2c *i2c, int err)
+{
+	dev_vdbg(i2c->dev, "STOP\n");
+
+	i2c->msg_idx++;
+	if (err)
+		i2c->msg_idx = err;
+
+	/* Disable interrrupts */
+	writel(0, i2c->regs + HSI2C_INT_ENABLE);
+	complete(&i2c->msg_complete);
+}
+
+static void exynos5_i2c_en_timeout(struct exynos5_i2c *i2c)
+{
+	unsigned long i2c_timeout = readl(i2c->regs + HSI2C_TIMEOUT);
+
+	/* Clear to enable Timeout */
+	i2c_timeout &= ~HSI2C_TIMEOUT_EN;
+	writel(i2c_timeout, i2c->regs + HSI2C_TIMEOUT);
+}
+
+static void exynos5_i2c_master_run(struct exynos5_i2c *i2c)
+{
+	/* Start data transfer in Master mode */
+	u32 i2c_auto_conf = readl(i2c->regs + HSI2C_AUTO_CONF);
+	i2c_auto_conf |= HSI2C_MASTER_RUN;
+	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONF);
+}
+
+/**
+ * exynos5_i2c_set_bus: get the i2c bus for a master transaction
+*/
+static int exynos5_i2c_set_master(struct exynos5_i2c *i2c)
+{
+	unsigned long t_status;
+	int timeout = 400;
+
+	while (timeout-- > 0) {
+		t_status = readl(i2c->regs + HSI2C_TRANS_STATUS);
+
+		if (!(t_status & HSI2C_MASTER_BUSY))
+			return 0;
+
+		msleep(20);
+	}
+
+	return -ETIMEDOUT;
+}
+
+/**
+ * exynos5_i2c_irq: top level IRQ servicing routine
+*/
+static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
+{
+	struct exynos5_i2c *i2c = dev_id;
+	unsigned long t_stat;
+	unsigned char byte;
+
+	t_stat = readl(i2c->regs + HSI2C_TRANS_STATUS);
+
+	if (t_stat & HSI2C_TRANS_ABORT) {
+		/* deal with arbitration loss */
+		dev_err(i2c->dev, "deal with arbitration loss\n");
+		goto out;
+	}
+	if (i2c->msg->flags & I2C_M_RD) {
+		if (t_stat & HSI2C_TRANS_DONE) {
+			dev_dbg(i2c->dev, "Device found.");
+			while ((readl(i2c->regs + HSI2C_FIFO_STATUS) &
+					HSI2C_RX_FIFO_EMPTY) == 0) {
+				byte = readl(i2c->regs + HSI2C_RX_DATA);
+				dev_dbg(i2c->dev, "read rx_data = %x", byte);
+				i2c->msg->buf[i2c->msg_ptr++] = byte;
+			}
+
+			if (i2c->msg_ptr >= i2c->msg->len)
+				exynos5_i2c_stop(i2c, 0);
+
+		} else if (t_stat & HSI2C_NO_DEV) {
+			dev_dbg(i2c->dev, "No device found.");
+			exynos5_i2c_stop(i2c, -ENXIO);
+		} else if (t_stat & HSI2C_NO_DEV_ACK &&
+				!(i2c->msg->flags & I2C_M_IGNORE_NAK)) {
+			dev_dbg(i2c->dev, "No device Ack.");
+			exynos5_i2c_stop(i2c, -ENXIO);
+		}
+	} else {
+		byte = i2c->msg->buf[i2c->msg_ptr++];
+		dev_dbg(i2c->dev, "write tx_data = %x ", byte);
+		writel(byte, i2c->regs + HSI2C_TX_DATA);
+
+		if (i2c->msg_ptr >= i2c->msg->len)
+			exynos5_i2c_stop(i2c, 0);
+	}
+
+ out:
+	/* Set those bits to clear them */
+	writel(readl(i2c->regs + HSI2C_INT_STATUS),
+				i2c->regs + HSI2C_INT_STATUS);
+
+	return IRQ_HANDLED;
+}
+
+static void exynos5_i2c_message_start(struct exynos5_i2c *i2c,
+				      struct i2c_msg *msgs)
+{
+	unsigned long usi_ctl = HSI2C_FUNC_MODE_I2C | HSI2C_MASTER;
+	unsigned long i2c_auto_conf;
+	unsigned long i2c_addr = ((msgs->addr & 0x7f) << 10);
+	unsigned long usi_int_en = 0;
+
+	exynos5_i2c_en_timeout(i2c);
+
+	if (msgs->flags & I2C_M_RD) {
+		usi_ctl &= ~HSI2C_TXCHON;
+		usi_ctl |= HSI2C_RXCHON;
+
+		i2c_auto_conf |= HSI2C_READ_WRITE;
+
+		usi_int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
+			HSI2C_INT_TRAILING_EN);
+	} else {
+		usi_ctl &= ~HSI2C_RXCHON;
+		usi_ctl |= HSI2C_TXCHON;
+
+		i2c_auto_conf &= ~HSI2C_READ_WRITE;
+
+		usi_int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
+	}
+
+	writel(i2c_addr, i2c->regs + HSI2C_ADDR);
+	writel(usi_ctl, i2c->regs + HSI2C_CTL);
+
+	i2c_auto_conf |= i2c->msg->len;
+	i2c_auto_conf |= HSI2C_STOP_AFTER_TRANS;
+	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONF);
+
+	exynos5_i2c_master_run(i2c);
+
+	/* Enable appropriate interrupts */
+	writel(usi_int_en, i2c->regs + HSI2C_INT_ENABLE);
+}
+
+static int exynos5_i2c_doxfer(struct exynos5_i2c *i2c, struct i2c_msg *msgs)
+{
+	unsigned long timeout;
+	int ret;
+
+	if (i2c->suspended) {
+		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
+		return -EIO;
+	}
+
+	if (exynos5_i2c_set_master(i2c)) {
+		dev_err(i2c->dev, "cannot get bus, Master busy.\n");
+		return -EAGAIN;
+	}
+
+	i2c->msg = msgs;
+	i2c->msg_ptr = 0;
+	i2c->msg_idx = 0;
+
+	INIT_COMPLETION(i2c->msg_complete);
+
+	exynos5_i2c_message_start(i2c, msgs);
+
+	timeout = wait_for_completion_timeout(&i2c->msg_complete,
+		EXYNOS5_I2C_TIMEOUT);
+
+	ret = i2c->msg_idx;
+
+	if (timeout == 0)
+		dev_dbg(i2c->dev, "timeout\n");
+	else if ((ret != msgs->len) && (ret < 0))
+		dev_dbg(i2c->dev, "incomplete xfer (%d)\n", i2c->msg_idx);
+
+	return ret;
+}
+
+static int exynos5_i2c_xfer(struct i2c_adapter *adap,
+			struct i2c_msg *msgs, int num)
+{
+	struct exynos5_i2c *i2c = (struct exynos5_i2c *)adap->algo_data;
+	int retry, i;
+	int ret;
+
+	ret = pm_runtime_get_sync(i2c->dev);
+	if (IS_ERR_VALUE(ret))
+		goto out;
+
+	clk_prepare_enable(i2c->clk);
+
+	for (retry = 0; retry < adap->retries; retry++) {
+		for (i = 0; i < num; i++) {
+			ret = exynos5_i2c_doxfer(i2c, msgs);
+			msgs++;
+
+			if (ret == -EAGAIN)
+				break;
+		}
+		if (i == num) {
+			clk_disable_unprepare(i2c->clk);
+
+			if (i2c->msg_idx == -ENXIO)
+				ret = i2c->msg_idx;
+			else
+				ret = num;
+			goto out;
+		}
+
+		dev_dbg(i2c->dev, "retrying transfer (%d)\n", retry);
+
+		udelay(100);
+	}
+
+	ret = -EREMOTEIO;
+	clk_disable_unprepare(i2c->clk);
+ out:
+	pm_runtime_mark_last_busy(i2c->dev);
+	pm_runtime_put_autosuspend(i2c->dev);
+	return ret;
+}
+
+static u32 exynos5_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static const struct i2c_algorithm exynos5_i2c_algorithm = {
+	.master_xfer		= exynos5_i2c_xfer,
+	.functionality		= exynos5_i2c_func,
+};
+
+static int exynos5_i2c_set_timing(struct exynos5_i2c *i2c, int speed_mode)
+{
+	unsigned long i2c_timing_s1;
+	unsigned long i2c_timing_s2;
+	unsigned long i2c_timing_s3;
+	unsigned long i2c_timing_sla;
+	unsigned int op_clk;
+	unsigned int clkin = clk_get_rate(i2c->clk);
+	unsigned int n_clkdiv;
+	unsigned int t_start_su, t_start_hd;
+	unsigned int t_stop_su;
+	unsigned int t_data_su, t_data_hd;
+	unsigned int t_scl_l, t_scl_h;
+	unsigned int t_sr_release;
+	unsigned int t_ftl_cycle;
+	unsigned int i = 0, utemp0 = 0, utemp1 = 0, utemp2 = 0;
+
+	if (speed_mode == HSI2C_HIGH_SPD)
+		op_clk = HSI2C_HS_TX_CLOCK;
+	else
+		op_clk = HSI2C_FS_TX_CLOCK;
+
+	/* FPCLK / FI2C =
+	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
+	 * uTemp0 = (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
+	 * uTemp1 = (TSCLK_L + TSCLK_H + 2)
+	 * uTemp2 = TSCLK_L + TSCLK_H
+	 */
+	t_ftl_cycle = (readl(i2c->regs + HSI2C_CONF) >> 16) & 0x7;
+	utemp0 = (clkin / op_clk) - 8 - 2 * t_ftl_cycle;
+
+	/* CLK_DIV max is 256 */
+	for (i = 0; i < 256; i++) {
+		utemp1 = utemp0 / (i + 1);
+		/* SCLK_L/H max is 255
+		 * so sclk_l + sclk_h has max value of 510
+		 */
+		if (utemp1 < 511) {
+			utemp2 = utemp1 - 2;
+			break;
+		}
+	}
+
+	n_clkdiv = i;
+	t_scl_l = utemp2 / 2;
+	t_scl_h = utemp2 / 2;
+	t_start_su = t_scl_l;
+	t_start_hd = t_scl_l;
+	t_stop_su = t_scl_l;
+	t_data_su = t_scl_l / 2;
+	t_data_hd = t_scl_l / 2;
+	t_sr_release = utemp2;
+
+	i2c_timing_s1 = t_start_su << 24 | t_start_hd << 16 | t_stop_su << 8;
+	i2c_timing_s2 = t_data_su << 24 | t_scl_l << 8 | t_scl_h << 0;
+	i2c_timing_s3 = n_clkdiv << 16 | t_sr_release << 0;
+	i2c_timing_sla = t_data_hd << 0;
+
+	dev_dbg(i2c->dev, "tSTART_SU: %X, tSTART_HD: %X, tSTOP_SU: %X\n",
+		t_start_su, t_start_hd, t_stop_su);
+	dev_dbg(i2c->dev, "tDATA_SU: %X, tSCL_L: %X, tSCL_H: %X\n",
+		t_data_su, t_scl_l, t_scl_h);
+	dev_dbg(i2c->dev, "nClkDiv: %X, tSR_RELEASE: %X\n",
+		n_clkdiv, t_sr_release);
+	dev_dbg(i2c->dev, "tDATA_HD: %X\n", t_data_hd);
+
+	if (speed_mode == HSI2C_HIGH_SPD) {
+		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_HS1);
+		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_HS2);
+		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_HS3);
+	} else {
+		writel(i2c_timing_s1, i2c->regs + HSI2C_TIMING_FS1);
+		writel(i2c_timing_s2, i2c->regs + HSI2C_TIMING_FS2);
+		writel(i2c_timing_s3, i2c->regs + HSI2C_TIMING_FS3);
+	}
+	writel(i2c_timing_sla, i2c->regs + HSI2C_TIMING_SLA);
+
+	return 0;
+}
+
+/**
+ * Parse a list of GPIOs from a node property and request each one
+ *
+ * @param i2c		i2c driver data
+ * @return 0 on success, -EINVAL on error, in which case no GPIOs requested
+*/
+static int exynos5_i2c_parse_dt_gpio(struct exynos5_i2c *i2c)
+{
+	int idx, gpio, ret;
+
+	for (idx = 0; idx < 2; idx++) {
+		gpio = of_get_gpio(i2c->dev->of_node, idx);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(i2c->dev, "invalid gpio[%d]: %d\n", idx, gpio);
+			return -EINVAL;
+		}
+		i2c->gpios[idx] = gpio;
+
+		ret = devm_gpio_request(i2c->dev, gpio, "i2c-bus");
+		if (ret) {
+			dev_err(i2c->dev, "gpio [%d] request failed\n", gpio);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static void exynos5_i2c_init(struct exynos5_i2c *i2c)
+{
+	unsigned long usi_trailing_ctl = HSI2C_TRAILING_COUNT;
+	unsigned long i2c_conf = HSI2C_AUTO_MODE;
+	unsigned long usi_fifo_ctl;
+
+	writel(usi_trailing_ctl, i2c->regs + HSI2C_TRAILIG_CTL);
+
+	/* Set default trigger level for TXFIFO and RXFIFO */
+	usi_fifo_ctl = HSI2C_TXFIFO_TRIGGER_LEVEL | HSI2C_RXFIFO_TRIGGER_LEVEL;
+
+	/* Enable RXFIFO and TXFIFO */
+	usi_fifo_ctl = HSI2C_RXFIFO_EN | HSI2C_TXFIFO_EN;
+	writel(usi_fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
+
+	if (i2c->speed_mode == HSI2C_HIGH_SPD) {
+		exynos5_i2c_set_timing(i2c, HSI2C_HIGH_SPD);
+		/* Configure I2C controller in High speed mode */
+		i2c_conf |= HSI2C_HS_MODE;
+		writel(i2c_conf, i2c->regs + HSI2C_CONF);
+	} else {
+		/* Configure I2C controller in Fast speed mode */
+		exynos5_i2c_set_timing(i2c, HSI2C_FAST_SPD);
+	}
+}
+
+#define HSI2C_REG(regname) {.name = #regname, .offset = regname}
+static struct debugfs_reg32 exynos5_hsi2c_regs[] = {
+	HSI2C_REG(HSI2C_CTL), HSI2C_REG(HSI2C_FIFO_CTL),
+	HSI2C_REG(HSI2C_TRAILIG_CTL), HSI2C_REG(HSI2C_CLK_CTL),
+	HSI2C_REG(HSI2C_CLK_SLOT), HSI2C_REG(HSI2C_INT_ENABLE),
+	HSI2C_REG(HSI2C_INT_STATUS), HSI2C_REG(HSI2C_ERR_STATUS),
+	HSI2C_REG(HSI2C_FIFO_STATUS), HSI2C_REG(HSI2C_TX_DATA),
+	HSI2C_REG(HSI2C_RX_DATA), HSI2C_REG(HSI2C_CONF),
+	HSI2C_REG(HSI2C_AUTO_CONF), HSI2C_REG(HSI2C_TIMEOUT),
+	HSI2C_REG(HSI2C_MANUAL_CMD), HSI2C_REG(HSI2C_TRANS_STATUS),
+	HSI2C_REG(HSI2C_TIMING_HS1), HSI2C_REG(HSI2C_TIMING_HS2),
+	HSI2C_REG(HSI2C_TIMING_HS3), HSI2C_REG(HSI2C_TIMING_FS1),
+	HSI2C_REG(HSI2C_TIMING_FS2), HSI2C_REG(HSI2C_TIMING_FS3),
+	HSI2C_REG(HSI2C_TIMING_SLA), HSI2C_REG(HSI2C_ADDR),
+};
+
+static struct debugfs_regset32 exynos5_hsi2c_regset = {
+	.regs = exynos5_hsi2c_regs,
+	.nregs = ARRAY_SIZE(exynos5_hsi2c_regs),
+};
+
+static struct dentry *exynos5_hsi2c_reg_debugfs;
+
+static int exynos5_i2c_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct exynos5_i2c *i2c;
+	int ret;
+
+	if (!np) {
+		dev_err(&pdev->dev, "no device node\n");
+		return -ENOENT;
+	}
+
+	i2c = devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL);
+	if (!i2c) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	i2c->bus_num = -1;
+	/* Mode of operation High/Fast Speed mode */
+	of_property_read_u32(np, "samsung,hs-mode", &i2c->speed_mode);
+
+	strlcpy(i2c->adap.name, "exynos5-hsi2c", sizeof(i2c->adap.name));
+	i2c->adap.owner   = THIS_MODULE;
+	i2c->adap.algo    = &exynos5_i2c_algorithm;
+	i2c->adap.retries = 2;
+	i2c->adap.class   = I2C_CLASS_HWMON | I2C_CLASS_SPD;
+
+	i2c->dev = &pdev->dev;
+	i2c->clk = clk_get(&pdev->dev, "hsi2c");
+	if (IS_ERR(i2c->clk)) {
+		dev_err(&pdev->dev, "cannot get clock\n");
+		ret = -ENOENT;
+		goto err_noclk;
+	}
+
+	dev_dbg(&pdev->dev, "clock source %p\n", i2c->clk);
+
+	clk_prepare_enable(i2c->clk);
+
+	i2c->regs = of_iomap(np, 0);
+	if (!i2c->regs) {
+		dev_err(&pdev->dev, "cannot map HS-I2C IO\n");
+		ret = -ENXIO;
+		goto err_clk;
+	}
+
+	/* inititalise the gpio */
+	if (exynos5_i2c_parse_dt_gpio(i2c))
+		return -EINVAL;
+
+	i2c->irq = irq_of_parse_and_map(np, 0);
+	if (i2c->irq) {
+		ret = devm_request_irq(&pdev->dev, i2c->irq, exynos5_i2c_irq,
+				0, dev_name(&pdev->dev), i2c);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "cannot request HS-I2C IRQ %d\n",
+								i2c->irq);
+			goto err_iomap;
+		}
+	}
+
+	/*
+	 * TODO: Use private lock to avoid race conditions as
+	 * mentioned in pm_runtime.txt
+	 */
+	pm_runtime_enable(i2c->dev);
+	pm_runtime_set_autosuspend_delay(i2c->dev, EXYNOS5_I2C_PM_TIMEOUT);
+	pm_runtime_use_autosuspend(i2c->dev);
+
+	ret = pm_runtime_get_sync(i2c->dev);
+	if (IS_ERR_VALUE(ret))
+		goto err_iomap;
+
+	exynos5_i2c_init(i2c);
+
+	i2c->adap.algo_data = i2c;
+	i2c->adap.dev.parent = &pdev->dev;
+	i2c->adap.nr = i2c->bus_num;
+	i2c->adap.dev.of_node = pdev->dev.of_node;
+
+	ret = i2c_add_numbered_adapter(&i2c->adap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
+		goto err_pm;
+	}
+
+	init_completion(&i2c->msg_complete);
+	of_i2c_register_devices(&i2c->adap);
+	platform_set_drvdata(pdev, i2c);
+
+	dev_info(&pdev->dev, "%s: Exynos5 HS-I2C adapter\n",
+		dev_name(&i2c->adap.dev));
+
+	exynos5_hsi2c_reg_debugfs = debugfs_create_regset32("exynos5-hsi2c",
+						  S_IFREG | S_IRUGO,
+						  NULL, &exynos5_hsi2c_regset);
+	clk_disable_unprepare(i2c->clk);
+	pm_runtime_mark_last_busy(i2c->dev);
+	pm_runtime_put_autosuspend(i2c->dev);
+	return 0;
+
+ err_pm:
+	pm_runtime_put(i2c->dev);
+	pm_runtime_disable(&pdev->dev);
+ err_iomap:
+	iounmap(i2c->regs);
+ err_clk:
+	clk_disable_unprepare(i2c->clk);
+ err_noclk:
+	return ret;
+}
+
+static int exynos5_i2c_remove(struct platform_device *pdev)
+{
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+
+	clk_disable_unprepare(i2c->clk);
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	i2c_del_adapter(&i2c->adap);
+
+	iounmap(i2c->regs);
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int exynos5_i2c_suspend_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+
+	i2c->suspended = 1;
+
+	return 0;
+}
+
+static int exynos5_i2c_resume_noirq(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+
+	clk_prepare_enable(i2c->clk);
+	exynos5_i2c_init(i2c);
+	clk_disable_unprepare(i2c->clk);
+	i2c->suspended = 0;
+
+	return 0;
+}
+
+static const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
+	.suspend_noirq	= exynos5_i2c_suspend_noirq,
+	.resume_noirq	= exynos5_i2c_resume_noirq,
+};
+
+#define EXYNOS5_DEV_PM_OPS (&exynos5_i2c_dev_pm_ops)
+#else
+#define EXYNOS5_DEV_PM_OPS NULL
+#endif
+
+static struct platform_driver exynos5_i2c_driver = {
+	.probe		= exynos5_i2c_probe,
+	.remove		= exynos5_i2c_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "exynos5-hsi2c",
+		.pm	= EXYNOS5_DEV_PM_OPS,
+		.of_match_table = exynos5_i2c_match,
+	},
+};
+
+static int __init i2c_adap_exynos5_init(void)
+{
+	return platform_driver_register(&exynos5_i2c_driver);
+}
+subsys_initcall(i2c_adap_exynos5_init);
+
+static void __exit i2c_adap_exynos5_exit(void)
+{
+	platform_driver_unregister(&exynos5_i2c_driver);
+}
+module_exit(i2c_adap_exynos5_exit);
+
+MODULE_DESCRIPTION("Exynos5 HS-I2C Bus driver");
+MODULE_AUTHOR("Naveen Krishna Chatradhi, <ch.naveen@samsung.com>");
+MODULE_AUTHOR("Taekgyun Ko, <taeggyun.ko@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

