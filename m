Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2K0NCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:02:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45389 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2K0NCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:02:44 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b9-50b4b9f37fa9
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com
Subject: [PATCH 1/3] i2c: exynos5: add High Speed I2C controller driver
Date: Tue, 27 Nov 2012 18:30:34 +0530
Message-id: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
References: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkTvfzzi0BBl/X8Vt0/P3CaHF51xw2
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlbFr6WPmgqYDjBWTZvSxNTCumc3YxcjBISFg
	IrHhlGIXIyeQKSZx4d56ti5GLg4hgaWMEmd7e5kgEkA101ayQCQWMUrM653BCuH0MElsm7Ee
	rIpNwEzi4KLV7CAJEYFeRomFm7YygzjMIC1nLh5lBqkSFnCXODj3DguIzSKgKvGx7wUjiM0r
	4CrRePIhO8RNChJzJtmAmJwCbhIrdtiAVAgBVaz9do4RolNA4tvkQywQ1bISmw6AbZIQeM0m
	0XjpPAvE1ZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRmBonv73TGoH
	48oGi0OMAhyMSjy8Cus2BwixJpYVV+YeYpTgYFYS4V24akuAEG9KYmVValF+fFFpTmrxIUYf
	oEsmMkuJJucD4yavJN7Q2MTc1NjU0sjIzNQUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6p
	BkaumX1/Hon3bnql+1lC9YT+O/ZpB25wrlB7fONE0pZtwbG+akdq1aX+f5kyJW+pU0KwLXMl
	96u8orXp/qu9P7x5devLlhCjk1rzXZTPMe2wC97o9JO1z1nQamrYw7eT9k8r7fTfy+pv6vBb
	eprnofBfM2dnVjxk23/nv1jckR+yt56Ufjjf1/1LiaU4I9FQi7moOBEAFc+TOHoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jAd1PO7cEGOxfb2XR8fcLo8XlXXPY
	LGac38fkwOzxeZNcAGNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtB8JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGrqWP
	mQuaDjBWTJrRx9bAuGY2YxcjJ4eEgInEhmkrWSBsMYkL99azdTFycQgJLGKUmNc7gxXC6WGS
	2DZjPRNIFZuAmcTBRavZQRIiAr2MEgs3bWUGcZhBWs5cPMoMUiUs4C5xcO4dsLksAqoSH/te
	gO3jFXCVaDz5EKibA2ifgsScSTYgJqeAm8SKHTYgFUJAFWu/nWOcwMi7gJFhFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZw6D+T2sG4ssHiEKMAB6MSD6/Cus0BQqyJZcWVuYcYJTiYlUR4
	F67aEiDEm5JYWZValB9fVJqTWnyI0QfoponMUqLJ+cC4zCuJNzQ2MTc1NrU0sTAxs8QhrCTO
	2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBcZX149Xd/ZNzT186tO2lSmVGtGJ6NcOOyjn94pdW
	7F0rHPx9Tzbn62rNZyma14O/+L1O/Ofx/NJd7wkrlf7dnREze19Qn/MmFQ0Vraer06u2ljo0
	80z493Pii39sJ+4GVKu+UKnPP3LSNKTl8LG1svxnSk5qZ1w+2N6n0t12cbvYy/QbQm13nyix
	FGckGmoxFxUnAgCv94N+qgIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for High Speed I2C driver found in Exynos5 and later
SoCs from Samsung. This driver currently supports Auto mode.

Driver only supports Device Tree method.

Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/Kconfig       |    6 +
 drivers/i2c/busses/Makefile      |    1 +
 drivers/i2c/busses/i2c-exynos5.c |  758 ++++++++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-exynos5.h |   80 ++++
 4 files changed, 845 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-exynos5.c
 create mode 100644 drivers/i2c/busses/i2c-exynos5.h

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 65dd599..88e8833 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -609,6 +609,12 @@ config I2C_S3C2410
 	  Say Y here to include support for I2C controller in the
 	  Samsung SoCs.
 
+config I2C_EXYNOS5
+	tristate "Exynos5 HS-I2C Driver"
+	help
+	  Say Y here to include support for High Speed I2C controller in the
+	  Exynos5 series SoCs from Samsung.
+
 config I2C_S6000
 	tristate "S6000 I2C support"
 	depends on XTENSA_VARIANT_S6000
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 2d33d62..426b4fd 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_I2C_PUV3)		+= i2c-puv3.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
 obj-$(CONFIG_I2C_PXA_PCI)	+= i2c-pxa-pci.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
+obj-$(CONFIG_I2C_EXYNOS5)	+= i2c-exynos5.o
 obj-$(CONFIG_I2C_S6000)		+= i2c-s6000.o
 obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
 obj-$(CONFIG_I2C_SH_MOBILE)	+= i2c-sh_mobile.o
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
new file mode 100644
index 0000000..5983aa9
--- /dev/null
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -0,0 +1,758 @@
+/* linux/drivers/i2c/busses/i2c-exynos5.c
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *
+ * Exynos5 series High Speed I2C controller driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/of_i2c.h>
+#include <linux/of_gpio.h>
+
+#include <asm/irq.h>
+#include "i2c-exynos5.h"
+
+#define HSI2C_POLLING 0
+#define HSI2C_FAST_SPD 0
+#define HSI2C_HIGH_SPD 1
+
+/* Max time to wait for bus to become idle after a xfer */
+#define EXYNOS5_I2C_TIMEOUT (msecs_to_jiffies(1000))
+
+struct exynos5_i2c {
+	unsigned int		suspended:1;
+
+	struct i2c_msg		*msg;
+	struct completion	msg_complete;
+	unsigned int		msg_byte_ptr;
+
+	unsigned int		irq;
+
+	void __iomem		*regs;
+	struct clk		*clk;
+	struct device		*dev;
+	struct resource		*ioarea;
+	struct i2c_adapter	adap;
+	unsigned int		bus_number;
+	unsigned int		speed_mode;
+	unsigned int		fast_speed;
+	unsigned int		high_speed;
+	int			operation_mode;
+	int			gpios[2];
+};
+
+static struct platform_device_id exynos5_driver_ids[] = {
+	{
+		.name		= "exynos5-hs-i2c",
+		.driver_data	= 0,
+	}, { },
+};
+MODULE_DEVICE_TABLE(platform, exynos5_driver_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id exynos5_i2c_match[] = {
+	{ .compatible = "samsung,exynos5-hs-i2c", .data = (void *)0 },
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
+#endif
+
+static inline void dump_i2c_register(struct exynos5_i2c *i2c)
+{
+	dev_dbg(i2c->dev, "Register dump(%d) :\n %x\n %x\n %x\n %x\n"
+		" %x\n %x\n %x\n %x\n %x\n"
+		" %x\n %x\n %x\n %x\n %x\n"
+		" %x\n %x\n %x\n %x\n %x\n"
+		" %x\n %x\n %x\n %x\n %x\n"
+		, i2c->suspended
+		, readl(i2c->regs + HSI2C_CTL)
+		, readl(i2c->regs + HSI2C_FIFO_CTL)
+		, readl(i2c->regs + HSI2C_TRAILIG_CTL)
+		, readl(i2c->regs + HSI2C_CLK_CTL)
+		, readl(i2c->regs + HSI2C_CLK_SLOT)
+		, readl(i2c->regs + HSI2C_INT_ENABLE)
+		, readl(i2c->regs + HSI2C_INT_STATUS)
+		, readl(i2c->regs + HSI2C_ERR_STATUS)
+		, readl(i2c->regs + HSI2C_FIFO_STATUS)
+		, readl(i2c->regs + HSI2C_TX_DATA)
+		, readl(i2c->regs + HSI2C_RX_DATA)
+		, readl(i2c->regs + HSI2C_CONF)
+		, readl(i2c->regs + HSI2C_AUTO_CONFING)
+		, readl(i2c->regs + HSI2C_TIMEOUT)
+		, readl(i2c->regs + HSI2C_MANUAL_CMD)
+		, readl(i2c->regs + HSI2C_TRANS_STATUS)
+		, readl(i2c->regs + HSI2C_TIMING_HS1)
+		, readl(i2c->regs + HSI2C_TIMING_HS2)
+		, readl(i2c->regs + HSI2C_TIMING_HS3)
+		, readl(i2c->regs + HSI2C_TIMING_FS1)
+		, readl(i2c->regs + HSI2C_TIMING_FS2)
+		, readl(i2c->regs + HSI2C_TIMING_FS3)
+		, readl(i2c->regs + HSI2C_TIMING_SLA)
+		, readl(i2c->regs + HSI2C_ADDR));
+}
+
+static inline void exynos5_i2c_stop(struct exynos5_i2c *i2c)
+{
+	writel(0, i2c->regs + HSI2C_INT_ENABLE);
+
+	complete(&i2c->msg_complete);
+}
+
+static inline void exynos5_disable_irq(struct exynos5_i2c *i2c)
+{
+	unsigned long tmp = readl(i2c->regs + HSI2C_INT_STATUS);
+
+	writel(tmp, i2c->regs +  HSI2C_INT_STATUS);
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
+static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
+{
+	struct exynos5_i2c *i2c = dev_id;
+	unsigned char byte;
+
+	if (i2c->msg->flags & I2C_M_RD) {
+		while ((readl(i2c->regs + HSI2C_FIFO_STATUS) &
+			0x1000000) == 0) {
+			byte = (unsigned char)readl(i2c->regs + HSI2C_RX_DATA);
+			i2c->msg->buf[i2c->msg_byte_ptr++] = byte;
+		}
+
+		if (i2c->msg_byte_ptr >= i2c->msg->len)
+			exynos5_i2c_stop(i2c);
+	} else {
+		byte = i2c->msg->buf[i2c->msg_byte_ptr++];
+		writel(byte, i2c->regs + HSI2C_TX_DATA);
+
+		if (i2c->msg_byte_ptr >= i2c->msg->len)
+			exynos5_i2c_stop(i2c);
+	}
+
+	exynos5_disable_irq(i2c);
+
+	return IRQ_HANDLED;
+}
+
+static int exynos5_i2c_init(struct exynos5_i2c *i2c);
+
+static int exynos5_i2c_reset(struct exynos5_i2c *i2c)
+{
+	unsigned long usi_ctl;
+
+	usi_ctl = readl(i2c->regs + HSI2C_CTL);
+	usi_ctl |= (1u << 31);
+	writel(usi_ctl, i2c->regs + HSI2C_CTL);
+	usi_ctl = readl(i2c->regs + HSI2C_CTL);
+	usi_ctl &= ~(1u << 31);
+	writel(usi_ctl, i2c->regs + HSI2C_CTL);
+	exynos5_i2c_init(i2c);
+
+	return 0;
+}
+
+static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
+			      struct i2c_msg *msgs, int num, int stop)
+{
+	unsigned long timeout;
+	unsigned long trans_status;
+	unsigned long usi_fifo_stat;
+	unsigned long usi_ctl;
+	unsigned long i2c_auto_conf;
+	unsigned long i2c_addr;
+	unsigned long usi_int_en;
+	unsigned long usi_fifo_ctl;
+	unsigned char byte;
+	int ret = 0;
+	int operation_mode = i2c->operation_mode;
+
+	i2c->msg = msgs;
+	i2c->msg_byte_ptr = 0;
+
+	init_completion(&i2c->msg_complete);
+
+	usi_ctl		= readl(i2c->regs + HSI2C_CTL);
+	i2c_auto_conf	= readl(i2c->regs + HSI2C_AUTO_CONFING);
+
+	exynos5_i2c_en_timeout(i2c);
+
+	/* Set default trigger level for TXFIFO and RXFIFO */
+	usi_fifo_ctl = HSI2C_TXFIFO_TRIGGER_LEVEL |
+					HSI2C_RXFIFO_TRIGGER_LEVEL;
+	/* Enable RXFIFO and TXFIFO */
+	usi_fifo_ctl = HSI2C_RXFIFO_EN | HSI2C_TXFIFO_EN;
+
+	writel(usi_fifo_ctl, i2c->regs + HSI2C_FIFO_CTL);
+
+	usi_int_en = 0;
+	if (msgs->flags & I2C_M_RD) {
+		usi_ctl &= ~HSI2C_TXCHON;
+		usi_ctl |= HSI2C_RXCHON;
+
+		i2c_auto_conf |= HSI2C_READ_WRITE;
+
+		usi_int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
+					HSI2C_INT_TRAILING_EN);
+	} else {
+		usi_ctl &= ~HSI2C_RXCHON;
+		usi_ctl |= HSI2C_TXCHON;
+
+		i2c_auto_conf &= ~HSI2C_READ_WRITE;
+
+		usi_int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
+	}
+
+	if (stop == 1)
+		i2c_auto_conf |= HSI2C_STOP_AFTER_TRANS;
+	else
+		i2c_auto_conf &= ~HSI2C_STOP_AFTER_TRANS;
+
+
+	i2c_addr = readl(i2c->regs + HSI2C_ADDR);
+
+	/* Clear Slave Address for I2C Master (Auto mode only) */
+	i2c_addr &= ~(0x3ff << 10);
+	/* Clear Slave Address for I2C Slave */
+	i2c_addr &= ~(0x3ff << 0);
+	/* Clear Master ID for I2C Master (Auto and HS mode only) */
+	if (i2c->speed_mode == HSI2C_HIGH_SPD)
+		i2c_addr &= ~(0xff << 24);
+
+	i2c_addr |= ((msgs->addr & 0x7f) << 10);
+	writel(i2c_addr, i2c->regs + HSI2C_ADDR);
+
+	writel(usi_ctl, i2c->regs + HSI2C_CTL);
+
+	/* Clear and set TRANS_LEN */
+	i2c_auto_conf &= ~(0xffff);
+	i2c_auto_conf |= i2c->msg->len;
+	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONFING);
+
+	/* Start data transfer in Master mode */
+	i2c_auto_conf = readl(i2c->regs + HSI2C_AUTO_CONFING);
+	i2c_auto_conf |= HSI2C_MASTER_RUN;
+	writel(i2c_auto_conf, i2c->regs + HSI2C_AUTO_CONFING);
+
+	/* Enable appropriate interrupts */
+	if (operation_mode != HSI2C_POLLING)
+		writel(usi_int_en, i2c->regs + HSI2C_INT_ENABLE);
+
+	ret = -EAGAIN;
+	if (msgs->flags & I2C_M_RD) {
+		if (operation_mode == HSI2C_POLLING) {
+			timeout = jiffies + EXYNOS5_I2C_TIMEOUT;
+			while (time_before(jiffies, timeout)) {
+				if ((readl(i2c->regs + HSI2C_FIFO_STATUS) &
+					0x1000000) == 0) {
+					byte = (unsigned char)readl
+						(i2c->regs + HSI2C_RX_DATA);
+					i2c->msg->buf[i2c->msg_byte_ptr++]
+						= byte;
+				}
+
+				if (i2c->msg_byte_ptr >= i2c->msg->len) {
+					ret = 0;
+					break;
+				}
+			}
+
+			if (ret == -EAGAIN) {
+				exynos5_i2c_reset(i2c);
+				dev_warn(i2c->dev, "rx timeout\n");
+				return ret;
+			}
+		} else {
+			timeout = wait_for_completion_interruptible_timeout
+				(&i2c->msg_complete, EXYNOS5_I2C_TIMEOUT);
+
+			if (timeout == 0) {
+				exynos5_i2c_reset(i2c);
+				dev_warn(i2c->dev, "rx timeout\n");
+				return ret;
+			}
+
+			ret = 0;
+		}
+	} else {
+		if (operation_mode == HSI2C_POLLING) {
+			timeout = jiffies + EXYNOS5_I2C_TIMEOUT;
+			while (time_before(jiffies, timeout) &&
+				(i2c->msg_byte_ptr < i2c->msg->len)) {
+				if ((readl(i2c->regs + HSI2C_FIFO_STATUS)
+					& 0x7f) < 64) {
+					byte = i2c->msg->buf
+						[i2c->msg_byte_ptr++];
+					writel(byte,
+						i2c->regs + HSI2C_TX_DATA);
+				}
+			}
+		} else {
+			timeout = wait_for_completion_interruptible_timeout
+				(&i2c->msg_complete, EXYNOS5_I2C_TIMEOUT);
+
+			if (timeout == 0) {
+				exynos5_i2c_reset(i2c);
+				dev_warn(i2c->dev, "tx timeout\n");
+				return ret;
+			}
+
+			timeout = jiffies + timeout;
+		}
+		while (time_before(jiffies, timeout)) {
+			usi_fifo_stat = readl(i2c->regs + HSI2C_FIFO_STATUS);
+			trans_status = readl(i2c->regs + HSI2C_TRANS_STATUS);
+			if ((usi_fifo_stat == HSI2C_FIFO_EMPTY) &&
+				((trans_status == 0) ||
+				((stop == 0) &&
+				(trans_status == 0x20000)))) {
+				ret = 0;
+				break;
+			}
+		}
+		if (ret == -EAGAIN) {
+			exynos5_i2c_reset(i2c);
+			dev_warn(i2c->dev, "tx timeout\n");
+			return ret;
+		}
+	}
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
+	int stop = 0;
+	struct i2c_msg *msgs_ptr = msgs;
+
+	if (i2c->suspended) {
+		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
+		return -EIO;
+	}
+
+	clk_prepare_enable(i2c->clk);
+
+	for (retry = 0; retry < adap->retries; retry++) {
+		for (i = 0; i < num; i++) {
+			if (i == num - 1)
+				stop = 1;
+			ret = exynos5_i2c_xfer_msg(i2c, msgs_ptr, 1, stop);
+			msgs_ptr++;
+
+			if (ret == -EAGAIN) {
+				msgs_ptr = msgs;
+				stop = 0;
+				break;
+			}
+		}
+		if (i == num) {
+			clk_disable_unprepare(i2c->clk);
+			return num;
+		}
+
+		dev_dbg(i2c->dev, "retrying transfer (%d)\n", retry);
+
+		udelay(100);
+	}
+
+	clk_disable_unprepare(i2c->clk);
+
+	return -EREMOTEIO;
+}
+
+static u32 exynos5_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C;
+}
+
+static const struct i2c_algorithm exynos5_i2c_algorithm = {
+	.master_xfer		= exynos5_i2c_xfer,
+	.functionality		= exynos5_i2c_func,
+};
+
+static int exynos5_i2c_set_timing(struct exynos5_i2c *i2c)
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
+	if (i2c->speed_mode == HSI2C_HIGH_SPD)
+		op_clk = i2c->high_speed;
+	else
+		op_clk = i2c->fast_speed;
+
+	/* FPCLK / FI2C =
+	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
+	 * uTemp0 = (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
+	 * uTemp1 = (TSCLK_L + TSCLK_H + 2)
+	 * uTemp2 = TSCLK_L + TSCLK_H
+	*/
+	t_ftl_cycle = (readl(i2c->regs + HSI2C_CONF) >> 16) & 0x7;
+	utemp0 = (clkin / op_clk) - 8 - 2 * t_ftl_cycle;
+
+	/* CLK_DIV max is 256 */
+	for (i = 0; i < 256; i++) {
+		utemp1 = utemp0 / (i + 1);
+		/* SCLK_L/H max is 256 / 2 */
+		if (utemp1 < 128) {
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
+	if (i2c->speed_mode == HSI2C_HIGH_SPD) {
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
+#ifdef CONFIG_OF
+static int exynos5_i2c_parse_dt_gpio(struct exynos5_i2c *i2c)
+{
+	int idx, gpio, ret;
+
+	for (idx = 0; idx < 2; idx++) {
+		gpio = of_get_gpio(i2c->dev->of_node, idx);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(i2c->dev, "invalid gpio[%d]: %d\n", idx, gpio);
+			goto free_gpio;
+		}
+		i2c->gpios[idx] = gpio;
+
+		ret = gpio_request(gpio, "hsi2c-bus");
+		if (ret) {
+			dev_err(i2c->dev, "gpio [%d] request failed\n", gpio);
+			goto free_gpio;
+		}
+	}
+	return 0;
+
+free_gpio:
+	while (--idx >= 0)
+		gpio_free(i2c->gpios[idx]);
+	return -EINVAL;
+}
+
+static void exynos5_i2c_dt_gpio_free(struct exynos5_i2c *i2c)
+{
+	unsigned int idx;
+
+	for (idx = 0; idx < 2; idx++)
+		gpio_free(i2c->gpios[idx]);
+}
+#else
+static int exynos5_i2c_parse_dt_gpio(struct exynos5_i2c *i2c)
+{
+	return 0;
+}
+
+static void exynos5_i2c_dt_gpio_free(struct exynos5_i2c *i2c)
+{
+}
+#endif
+
+static int exynos5_i2c_init(struct exynos5_i2c *i2c)
+{
+	unsigned long usi_ctl = HSI2C_FUNC_MODE_I2C | HSI2C_MASTER;
+	unsigned long usi_trailing_ctl = HSI2C_TRAILING_COUNT;
+	unsigned long i2c_conf = readl(i2c->regs + HSI2C_CONF);
+
+	if (exynos5_i2c_parse_dt_gpio(i2c))
+		return -EINVAL;
+
+	writel(usi_ctl, i2c->regs + HSI2C_CTL);
+
+	writel(usi_trailing_ctl, i2c->regs + HSI2C_TRAILIG_CTL);
+
+	exynos5_i2c_set_timing(i2c);
+
+	if (i2c->speed_mode == HSI2C_HIGH_SPD) {
+		i2c_conf |= HSI2C_HS_MODE;
+		writel(i2c_conf, i2c->regs + HSI2C_CONF);
+	}
+
+	return 0;
+}
+
+static int exynos5_i2c_probe(struct platform_device *pdev)
+{
+	struct exynos5_i2c *i2c;
+	struct resource *res;
+	int ret;
+
+	i2c = devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL);
+	if (!i2c) {
+		dev_err(&pdev->dev, "no memory for state\n");
+		return -ENOMEM;
+	}
+
+	if (pdev->dev.of_node) {
+		/* i2c bus number is dynamically assigned */
+		i2c->bus_number = -1;
+
+		if (of_property_read_u32(pdev->dev.of_node,
+				"samsung,hsi2c-speed-mode", &i2c->speed_mode))
+			i2c->speed_mode = 1;
+		if (!of_property_read_u32(pdev->dev.of_node,
+				"samsung,hsi2c-hs-clk", &i2c->high_speed))
+			i2c->high_speed = 2500000;
+		if (!of_property_read_u32(pdev->dev.of_node,
+				"samsung,hsi2c-fs-clk", &i2c->fast_speed))
+			i2c->fast_speed = 400000;
+	} else {
+		dev_err(&pdev->dev, "no device node\n");
+		return -ENOENT;
+	}
+
+	strlcpy(i2c->adap.name, "exynos5250-i2c", sizeof(i2c->adap.name));
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
+	clk_prepare_enable(i2c->clk);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "cannot find HS-I2C IO resource\n");
+		ret = -ENOENT;
+		goto err_clk;
+	}
+
+	i2c->ioarea = request_mem_region(res->start, resource_size(res),
+					 pdev->name);
+
+	if (i2c->ioarea == NULL) {
+		dev_err(&pdev->dev, "cannot request HS-I2C IO\n");
+		ret = -ENXIO;
+		goto err_clk;
+	}
+
+	i2c->regs = ioremap(res->start, resource_size(res));
+
+	if (i2c->regs == NULL) {
+		dev_err(&pdev->dev, "cannot map HS-I2C IO\n");
+		ret = -ENXIO;
+		goto err_ioarea;
+	}
+
+	dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
+		i2c->regs, i2c->ioarea, res);
+
+	i2c->adap.algo_data = i2c;
+	i2c->adap.dev.parent = &pdev->dev;
+
+	ret = exynos5_i2c_init(i2c);
+	if (ret != 0)
+		goto err_iomap;
+
+	i2c->irq = ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
+		dev_err(&pdev->dev, "cannot find HS-I2C IRQ\n");
+		goto err_iomap;
+	}
+
+	ret = request_irq(i2c->irq, exynos5_i2c_irq, IRQF_DISABLED,
+			  dev_name(&pdev->dev), i2c);
+
+	if (ret != 0) {
+		dev_err(&pdev->dev, "cannot request HS-I2C IRQ %d\n", i2c->irq);
+		goto err_iomap;
+	}
+
+	i2c->adap.nr = i2c->bus_number;
+	i2c->adap.dev.of_node = pdev->dev.of_node;
+
+	ret = i2c_add_numbered_adapter(&i2c->adap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add bus to i2c core\n");
+		goto err_irq;
+	}
+
+	of_i2c_register_devices(&i2c->adap);
+	platform_set_drvdata(pdev, i2c);
+
+	dev_info(&pdev->dev, "%s: Exynos5 HS-I2C adapter\n",
+		dev_name(&i2c->adap.dev));
+	clk_disable_unprepare(i2c->clk);
+	return 0;
+
+ err_irq:
+	free_irq(i2c->irq, i2c);
+
+ err_iomap:
+	iounmap(i2c->regs);
+
+ err_ioarea:
+	release_resource(i2c->ioarea);
+	kfree(i2c->ioarea);
+
+ err_clk:
+	clk_disable_unprepare(i2c->clk);
+	clk_put(i2c->clk);
+
+ err_noclk:
+	return ret;
+}
+
+static int exynos5_i2c_remove(struct platform_device *pdev)
+{
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&i2c->adap);
+	free_irq(i2c->irq, i2c);
+
+	clk_disable_unprepare(i2c->clk);
+	clk_put(i2c->clk);
+
+	iounmap(i2c->regs);
+
+	release_resource(i2c->ioarea);
+	exynos5_i2c_dt_gpio_free(i2c);
+	kfree(i2c->ioarea);
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
+	i2c_lock_adapter(&i2c->adap);
+	i2c->suspended = 1;
+	i2c_unlock_adapter(&i2c->adap);
+
+	return 0;
+}
+
+static int exynos5_i2c_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct exynos5_i2c *i2c = platform_get_drvdata(pdev);
+
+	i2c_lock_adapter(&i2c->adap);
+	clk_prepare_enable(i2c->clk);
+	exynos5_i2c_init(i2c);
+	clk_disable_unprepare(i2c->clk);
+	i2c->suspended = 0;
+	i2c_unlock_adapter(&i2c->adap);
+
+	return 0;
+}
+
+static const struct dev_pm_ops exynos5_i2c_dev_pm_ops = {
+	.suspend_noirq	= exynos5_i2c_suspend_noirq,
+	.resume_noirq	= exynos5_i2c_resume,
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
+	.id_table	= exynos5_driver_ids,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "exynos5-i2c",
+		.pm	= EXYNOS5_DEV_PM_OPS,
+		.of_match_table = of_match_ptr(exynos5_i2c_match),
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
+MODULE_AUTHOR("Taekgyun Ko, <taeggyun.ko@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/i2c/busses/i2c-exynos5.h b/drivers/i2c/busses/i2c-exynos5.h
new file mode 100644
index 0000000..063051e
--- /dev/null
+++ b/drivers/i2c/busses/i2c-exynos5.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *
+ * Exynos5 series HS-I2C Controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __ASM_ARCH_REGS_HS_IIC_H
+#define __ASM_ARCH_REGS_HS_IIC_H __FILE__
+
+/*
+ *	Register Map
+ */
+#define HSI2C_CTL				0x00
+#define HSI2C_FIFO_CTL				0x04
+#define HSI2C_TRAILIG_CTL			0x08
+#define HSI2C_CLK_CTL				0x0C
+#define HSI2C_CLK_SLOT				0x10
+#define HSI2C_INT_ENABLE			0x20
+#define HSI2C_INT_STATUS			0x24
+#define HSI2C_ERR_STATUS			0x2C
+#define HSI2C_FIFO_STATUS			0x30
+#define HSI2C_TX_DATA				0x34
+#define HSI2C_RX_DATA				0x38
+#define HSI2C_CONF				0x40
+#define HSI2C_AUTO_CONFING			0x44
+#define HSI2C_TIMEOUT				0x48
+#define HSI2C_MANUAL_CMD			0x4C
+#define HSI2C_TRANS_STATUS			0x50
+#define HSI2C_TIMING_HS1			0x54
+#define HSI2C_TIMING_HS2			0x58
+#define HSI2C_TIMING_HS3			0x5C
+#define HSI2C_TIMING_FS1			0x60
+#define HSI2C_TIMING_FS2			0x64
+#define HSI2C_TIMING_FS3			0x68
+#define HSI2C_TIMING_SLA			0x6C
+#define HSI2C_ADDR				0x70
+
+/* I2C_CTL Register */
+#define HSI2C_FUNC_MODE_I2C			(1u << 0)
+#define HSI2C_MASTER				(1u << 3)
+#define HSI2C_RXCHON				(1u << 6)
+#define HSI2C_TXCHON				(1u << 7)
+
+/* I2C_FIFO_CTL Register */
+#define HSI2C_RXFIFO_EN				(1u << 0)
+#define HSI2C_TXFIFO_EN				(1u << 1)
+#define HSI2C_TXFIFO_TRIGGER_LEVEL		(0x20 << 16)
+#define HSI2C_RXFIFO_TRIGGER_LEVEL		(0x20 << 4)
+
+/* I2C_TRAILING_CTL Register */
+#define HSI2C_TRAILING_COUNT			(0xf)
+
+/* I2C_INT_EN Register */
+#define HSI2C_INT_TX_ALMOSTEMPTY_EN		(1u << 0) /* For TX FIFO */
+#define HSI2C_INT_RX_ALMOSTFULL_EN		(1u << 1) /* For RX FIFO */
+#define HSI2C_INT_TRAILING_EN			(1u << 6)
+
+/* I2C_CONF Register */
+#define HSI2C_AUTO_MODE				(1u << 31)
+#define HSI2C_10BIT_ADDR_MODE			(1u << 30)
+#define HSI2C_HS_MODE				(1u << 29)
+
+/* I2C_AUTO_CONF Register */
+#define HSI2C_READ_WRITE			(1u << 16)
+#define HSI2C_STOP_AFTER_TRANS			(1u << 17)
+#define HSI2C_MASTER_RUN			(1u << 31)
+
+/* I2C_TIMEOUT Register */
+#define HSI2C_TIMEOUT_EN			(1u << 31)
+
+#define HSI2C_FIFO_EMPTY			(0x1000100)
+
+#define HSI2C_FS_BPS				400000
+#define HSI2C_HS_BPS				2500000
+
+#endif /* __ASM_ARCH_REGS_HS_IIC_H */
-- 
1.7.9.5

