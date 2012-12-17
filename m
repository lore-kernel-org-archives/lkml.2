Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab2LQIW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 03:22:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18942 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2LQIW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 03:22:27 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-7c-50ced63d9c8c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: PATCH] backlight: add lms501kf03 LCD driver
Date: Mon, 17 Dec 2012 17:22:21 +0900
Message-id: <000001cddc2f$a2b2e8a0$e818b9e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3cL6I27sdvnDOiQ2SfiarqUEmVIw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zA13ba+cCDOYuNLW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZD+asZiqYlFAx9cVOlgbG7b5djJwcEgImEp/erGWBsMUkLtxb
	z9bFyMUhJLCMUWLR0WWMMEV/14EUgSQWMUpcvHOJGcKZzSTxaNYdsCo2ATWJL18Os4PYIgIR
	Es0zZgEVcXAwC/hIbJ6lCWIKAw06sa4SpIJFQFVi4bY1LCBhXgFbieev5UDCvAKCEj8m3wO7
	h1lAS2L9zuNMELa8xOY1b8EGSgioSzz6qwuxR09i4Yy5jBAlIhL7XrxjhJguIPFt8iEWiHJZ
	iU0HmCEeaWeXmLREBMKWlDi44gbLBEaxWUgWz0KyeBaSxbOQbFjAyLKKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIyRGpHYwrmywOMQowMGoxMNrlHouQIg1say4MvcQowQHs5IIL787UIg3
	JbGyKrUoP76oNCe1+BCjD9DhE5mlRJPzgfGbVxJvaGxsYmZiamJuaWpuikNYSZy32SMlQEgg
	PbEkNTs1tSC1CGYcEwenVAPjesfTSvt21K7TcX78zEFxzrkrrCELdQ6VfjpSu9YuYF7+T0Z+
	xxlseab7JnXOu7muzdl7U4n/AtWyWL8sP6aa23bGb+LDpn/+21e5sfV5qn3KibiMia+MVHub
	XD/41rKFv1euCbnKvXl6lLmY/e9lrnezLv2Jkb0Y9I3d9/yG6bv+CyVe/1SpxFKckWioxVxU
	nAgAGucMjb4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV3ba+cCDL4d0rO4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGQ/mrGYqmJRQMfXFTpYG
	xu2+XYycHBICJhJ/161lgbDFJC7cW8/WxcjFISSwiFHi4p1LzBDObCaJR7PuMIJUsQmoSXz5
	cpgdxBYRiJBonjELqIiDg1nAR2LzLE0QUxho6Il1lSAVLAKqEgu3rWEBCfMK2Eo8fy0HEuYV
	EJT4Mfke2FpmAS2J9TuPM0HY8hKb17wFGyghoC7x6K8uxB49iYUz5jJClIhI7HvxjnECo8As
	JJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjsFnUjsYVzZYHGIU
	4GBU4uE1Sj0XIMSaWFZcmXuIUYKDWUmEl98dKMSbklhZlVqUH19UmpNafIjRB+jPicxSosn5
	wPSQVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAOjtMgPowDu
	BR6/b9U+rBNIXXrvydL3DupWv48GXG05qBO+tNpTmdVC0Kf7A+etzM/7RF5VZCptVumJeHBQ
	tiNkatbeWDaBn0cmLos8uqj0TtSVh0pMWvqPtdP2G3Gtl2nR/Gn1bBtD4/y4uE2/6qxr/v68
	ybxR/O7NYlZ/CSbzuX0y7AosvxWUWIozEg21mIuKEwF8YaUM7gIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the lms501kf03 LCD panel driver. The lms501kf03 LCD panel (800
x 480) driver uses 3-wired SPI inteface.

Signed-off-by: Ilho Lee <Ilho215.lee@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/Kconfig      |    8 +
 drivers/video/backlight/Makefile     |    1 +
 drivers/video/backlight/lms501kf03.c |  448 ++++++++++++++++++++++++++++++++++
 3 files changed, 457 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/lms501kf03.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 765a945..081d6cf 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -126,6 +126,14 @@ config LCD_AMS369FG06
 	  If you have an AMS369FG06 AMOLED Panel, say Y to enable its
 	  LCD control driver.
 
+config LCD_LMS501KF03
+	tristate "LMS501KF03 LCD Driver"
+	depends on SPI
+	default n
+	help
+	  If you have an LMS501KF03 LCD Panel, say Y to enable its
+	  LCD control driver.
+
 endif # LCD_CLASS_DEVICE
 
 #
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index e7ce729..d02a728 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_LCD_TOSA)		   += tosa_lcd.o
 obj-$(CONFIG_LCD_S6E63M0)	+= s6e63m0.o
 obj-$(CONFIG_LCD_LD9040)	+= ld9040.o
 obj-$(CONFIG_LCD_AMS369FG06)	+= ams369fg06.o
+obj-$(CONFIG_LCD_LMS501KF03)	+= lms501kf03.o
 
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
 obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)    += atmel-pwm-bl.o
diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
new file mode 100644
index 0000000..c30ea53
--- /dev/null
+++ b/drivers/video/backlight/lms501kf03.c
@@ -0,0 +1,448 @@
+/*
+ * lms501kf03 TFT LCD panel driver.
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han  <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/gpio.h>
+#include <linux/lcd.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
+
+#define ENDDEF			0xff00
+#define COMMAND_ONLY		0x00
+#define DATA_ONLY		0x01
+
+struct lms501kf03 {
+	struct device			*dev;
+	struct spi_device		*spi;
+	unsigned int			power;
+	struct lcd_device		*ld;
+	struct lcd_platform_data	*lcd_pd;
+};
+
+static const unsigned short seq_password[] = {
+	0xb9, 0xff, 0x83, 0x69,
+	ENDDEF
+};
+
+static const unsigned short seq_power[] = {
+	0xb1, 0x01, 0x00, 0x34, 0x06, 0x00, 0x14, 0x14, 0x20, 0x28,
+	0x12, 0x12, 0x17, 0x0a, 0x01, 0xe6, 0xe6, 0xe6, 0xe6, 0xe6,
+	ENDDEF
+};
+
+static const unsigned short seq_display[] = {
+	0xb2, 0x00, 0x2b, 0x03, 0x03, 0x70, 0x00, 0xff, 0x00, 0x00,
+	0x00, 0x00, 0x03, 0x03, 0x00, 0x01,
+	ENDDEF
+};
+
+static const unsigned short seq_rgb_if[] = {
+	0xb3, 0x09,
+	ENDDEF
+};
+
+static const unsigned short seq_display_inv[] = {
+	0xb4, 0x01, 0x08, 0x77, 0x0e, 0x06,
+	ENDDEF
+};
+
+static const unsigned short seq_vcom[] = {
+	0xb6, 0x4c, 0x2e,
+	ENDDEF
+};
+
+static const unsigned short seq_gate[] = {
+	0xd5, 0x00, 0x05, 0x03, 0x29, 0x01, 0x07, 0x17, 0x68, 0x13,
+	0x37, 0x20, 0x31, 0x8a, 0x46, 0x9b, 0x57, 0x13, 0x02, 0x75,
+	0xb9, 0x64, 0xa8, 0x07, 0x0f, 0x04, 0x07,
+	ENDDEF
+};
+
+static const unsigned short seq_panel[] = {
+	0xcc, 0x02,
+	ENDDEF
+};
+
+static const unsigned short seq_col_mod[] = {
+	0x3a, 0x77,
+	ENDDEF
+};
+
+static const unsigned short seq_w_gamma[] = {
+	0xe0, 0x00, 0x04, 0x09, 0x0f, 0x1f, 0x3f, 0x1f, 0x2f, 0x0a,
+	0x0f, 0x10, 0x16, 0x18, 0x16, 0x17, 0x0d, 0x15, 0x00, 0x04,
+	0x09, 0x0f, 0x38, 0x3f, 0x20, 0x39, 0x0a, 0x0f, 0x10, 0x16,
+	0x18, 0x16, 0x17, 0x0d, 0x15,
+	ENDDEF
+};
+
+static const unsigned short seq_rgb_gamma[] = {
+	0xc1, 0x01, 0x03, 0x07, 0x0f, 0x1a, 0x22, 0x2c, 0x33, 0x3c,
+	0x46, 0x4f, 0x58, 0x60, 0x69, 0x71, 0x79, 0x82, 0x89, 0x92,
+	0x9a, 0xa1, 0xa9, 0xb1, 0xb9, 0xc1, 0xc9, 0xcf, 0xd6, 0xde,
+	0xe5, 0xec, 0xf3, 0xf9, 0xff, 0xdd, 0x39, 0x07, 0x1c, 0xcb,
+	0xab, 0x5f, 0x49, 0x80, 0x03, 0x07, 0x0f, 0x19, 0x20, 0x2a,
+	0x31, 0x39, 0x42, 0x4b, 0x53, 0x5b, 0x63, 0x6b, 0x73, 0x7b,
+	0x83, 0x8a, 0x92, 0x9b, 0xa2, 0xaa, 0xb2, 0xba, 0xc2, 0xca,
+	0xd0, 0xd8, 0xe1, 0xe8, 0xf0, 0xf8, 0xff, 0xf7, 0xd8, 0xbe,
+	0xa7, 0x39, 0x40, 0x85, 0x8c, 0xc0, 0x04, 0x07, 0x0c, 0x17,
+	0x1c, 0x23, 0x2b, 0x34, 0x3b, 0x43, 0x4c, 0x54, 0x5b, 0x63,
+	0x6a, 0x73, 0x7a, 0x82, 0x8a, 0x91, 0x98, 0xa1, 0xa8, 0xb0,
+	0xb7, 0xc1, 0xc9, 0xcf, 0xd9, 0xe3, 0xea, 0xf4, 0xff, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	ENDDEF
+};
+
+static const unsigned short seq_up_dn[] = {
+	0x36, 0x10,
+	ENDDEF
+};
+
+static const unsigned short seq_sleep_in[] = {
+	0x10,
+	ENDDEF
+};
+
+static const unsigned short seq_sleep_out[] = {
+	0x11,
+	ENDDEF
+};
+
+static const unsigned short seq_display_on[] = {
+	0x29,
+	ENDDEF
+};
+
+static const unsigned short seq_display_off[] = {
+	0x10,
+	ENDDEF
+};
+
+static int lms501kf03_spi_write_byte(struct lms501kf03 *lcd, int addr, int data)
+{
+	u16 buf[1];
+	struct spi_message msg;
+
+	struct spi_transfer xfer = {
+		.len		= 2,
+		.tx_buf		= buf,
+	};
+
+	buf[0] = (addr << 8) | data;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	return spi_sync(lcd->spi, &msg);
+}
+
+static int lms501kf03_spi_write(struct lms501kf03 *lcd, unsigned char address,
+				unsigned char command)
+{
+	int ret;
+
+	ret = lms501kf03_spi_write_byte(lcd, address, command);
+
+	return ret;
+}
+
+static int lms501kf03_panel_send_sequence(struct lms501kf03 *lcd,
+					const unsigned short *wbuf)
+{
+	int ret = 0, i = 0;
+
+	while (wbuf[i] != ENDDEF) {
+		if (i == 0)
+			ret = lms501kf03_spi_write(lcd, COMMAND_ONLY, wbuf[i]);
+		else
+			ret = lms501kf03_spi_write(lcd, DATA_ONLY, wbuf[i]);
+		if (ret)
+			break;
+		i += 1;
+	}
+
+	return ret;
+}
+
+static int lms501kf03_ldi_init(struct lms501kf03 *lcd)
+{
+	int ret, i;
+	static const unsigned short *init_seq[] = {
+		seq_password,
+		seq_power,
+		seq_display,
+		seq_rgb_if,
+		seq_display_inv,
+		seq_vcom,
+		seq_gate,
+		seq_panel,
+		seq_col_mod,
+		seq_w_gamma,
+		seq_rgb_gamma,
+		seq_sleep_out,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
+		ret = lms501kf03_panel_send_sequence(lcd, init_seq[i]);
+		if (ret)
+			break;
+	}
+	/* according to the datasheet, 120ms delay time is required. */
+	msleep(120);
+
+	return ret;
+}
+
+static int lms501kf03_ldi_enable(struct lms501kf03 *lcd)
+{
+	return lms501kf03_panel_send_sequence(lcd, seq_display_on);
+}
+
+static int lms501kf03_ldi_disable(struct lms501kf03 *lcd)
+{
+	return lms501kf03_panel_send_sequence(lcd, seq_display_off);
+}
+
+static int lms501kf03_power_is_on(int power)
+{
+	return (power) <= FB_BLANK_NORMAL;
+}
+
+static int lms501kf03_power_on(struct lms501kf03 *lcd)
+{
+	int ret = 0;
+	struct lcd_platform_data *pd;
+
+	pd = lcd->lcd_pd;
+
+	if (!pd->power_on) {
+		dev_err(lcd->dev, "power_on is NULL.\n");
+		return -EFAULT;
+	} else {
+		pd->power_on(lcd->ld, 1);
+		msleep(pd->power_on_delay);
+	}
+
+	if (!pd->reset) {
+		dev_err(lcd->dev, "reset is NULL.\n");
+		return -EFAULT;
+	} else {
+		pd->reset(lcd->ld);
+		msleep(pd->reset_delay);
+	}
+
+	ret = lms501kf03_ldi_init(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "failed to initialize ldi.\n");
+		return ret;
+	}
+
+	ret = lms501kf03_ldi_enable(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "failed to enable ldi.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lms501kf03_power_off(struct lms501kf03 *lcd)
+{
+	int ret = 0;
+	struct lcd_platform_data *pd;
+
+	pd = lcd->lcd_pd;
+
+	ret = lms501kf03_ldi_disable(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "lcd setting failed.\n");
+		return -EIO;
+	}
+
+	msleep(pd->power_off_delay);
+
+	pd->power_on(lcd->ld, 0);
+
+	return 0;
+}
+
+static int lms501kf03_power(struct lms501kf03 *lcd, int power)
+{
+	int ret = 0;
+
+	if (lms501kf03_power_is_on(power) &&
+		!lms501kf03_power_is_on(lcd->power))
+		ret = lms501kf03_power_on(lcd);
+	else if (!lms501kf03_power_is_on(power) &&
+		lms501kf03_power_is_on(lcd->power))
+		ret = lms501kf03_power_off(lcd);
+
+	if (!ret)
+		lcd->power = power;
+
+	return ret;
+}
+
+static int lms501kf03_get_power(struct lcd_device *ld)
+{
+	struct lms501kf03 *lcd = lcd_get_data(ld);
+
+	return lcd->power;
+}
+
+static int lms501kf03_set_power(struct lcd_device *ld, int power)
+{
+	struct lms501kf03 *lcd = lcd_get_data(ld);
+
+	if (power != FB_BLANK_UNBLANK && power != FB_BLANK_POWERDOWN &&
+		power != FB_BLANK_NORMAL) {
+		dev_err(lcd->dev, "power value should be 0, 1 or 4.\n");
+		return -EINVAL;
+	}
+
+	return lms501kf03_power(lcd, power);
+}
+
+static struct lcd_ops lms501kf03_lcd_ops = {
+	.get_power = lms501kf03_get_power,
+	.set_power = lms501kf03_set_power,
+};
+
+static int lms501kf03_probe(struct spi_device *spi)
+{
+	struct lms501kf03 *lcd = NULL;
+	struct lcd_device *ld = NULL;
+	int ret = 0;
+
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct lms501kf03), GFP_KERNEL);
+	if (!lcd)
+		return -ENOMEM;
+
+	/* lms501kf03 lcd panel uses 3-wire 9-bit SPI Mode. */
+	spi->bits_per_word = 9;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		dev_err(&spi->dev, "spi setup failed.\n");
+		return ret;
+	}
+
+	lcd->spi = spi;
+	lcd->dev = &spi->dev;
+
+	lcd->lcd_pd = spi->dev.platform_data;
+	if (!lcd->lcd_pd) {
+		dev_err(&spi->dev, "platform data is NULL\n");
+		return -EFAULT;
+	}
+
+	ld = lcd_device_register("lms501kf03", &spi->dev, lcd,
+				&lms501kf03_lcd_ops);
+	if (IS_ERR(ld))
+		return PTR_ERR(ld);
+
+	lcd->ld = ld;
+
+	if (!lcd->lcd_pd->lcd_enabled) {
+		/*
+		 * if lcd panel was off from bootloader then
+		 * current lcd status is powerdown and then
+		 * it enables lcd panel.
+		 */
+		lcd->power = FB_BLANK_POWERDOWN;
+
+		lms501kf03_power(lcd, FB_BLANK_UNBLANK);
+	} else {
+		lcd->power = FB_BLANK_UNBLANK;
+	}
+
+	dev_set_drvdata(&spi->dev, lcd);
+
+	dev_info(&spi->dev, "lms501kf03 panel driver has been probed.\n");
+
+	return 0;
+}
+
+static int lms501kf03_remove(struct spi_device *spi)
+{
+	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+
+	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
+	lcd_device_unregister(lcd->ld);
+
+	return 0;
+}
+
+#if defined(CONFIG_PM)
+static unsigned int before_power;
+
+static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
+{
+	int ret = 0;
+	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+
+	before_power = lcd->power;
+
+	/*
+	 * when lcd panel is suspend, lcd panel becomes off
+	 * regardless of status.
+	 */
+	ret = lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
+
+	return ret;
+}
+
+static int lms501kf03_resume(struct spi_device *spi)
+{
+	int ret = 0;
+	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+
+	lcd->power = FB_BLANK_POWERDOWN;
+
+	ret = lms501kf03_power(lcd, FB_BLANK_UNBLANK);
+
+	return ret;
+}
+#else
+#define lms501kf03_suspend	NULL
+#define lms501kf03_resume	NULL
+#endif
+
+void lms501kf03_shutdown(struct spi_device *spi)
+{
+	struct lms501kf03 *lcd = dev_get_drvdata(&spi->dev);
+
+	lms501kf03_power(lcd, FB_BLANK_POWERDOWN);
+}
+
+static struct spi_driver lms501kf03_driver = {
+	.driver = {
+		.name	= "lms501kf03",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= lms501kf03_probe,
+	.remove		= lms501kf03_remove,
+	.shutdown	= lms501kf03_shutdown,
+	.suspend	= lms501kf03_suspend,
+	.resume		= lms501kf03_resume,
+};
+
+module_spi_driver(lms501kf03_driver);
+
+MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
+MODULE_DESCRIPTION("lms501kf03 LCD Driver");
+MODULE_LICENSE("GPL");
-- 
1.7.2.5


