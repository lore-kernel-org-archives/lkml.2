Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2LNFvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:51:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:63188 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2LNFvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:51:22 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-39-50cabe58e6dd
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        sjg@chromium.org, grundler@chromium.org, naveen@chromium.org,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH 2/2] i2c-s3c2410: Add GPIO based bus arbitration functionality
Date: Fri, 14 Dec 2012 11:20:54 +0530
Message-id: <1355464254-12768-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkWjdy36kAg2MLmSw6/n5htLi8aw6b
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgynj6p7Jgs3zFwYZbLA2M8yW7GDk5JARMJF49
	+MAMYYtJXLi3ng3EFhJYyijx5rY5TM2Slw+YIOKLGCUOdZh0MXIB2T1MEq+mzgJrZhMwkzi4
	aDU7iC0ikCDROekUWAOzwGtGiYV7WUFsYQE/iUVb54PVswioSrSuvwa2jFfAVeLaii1ANgfQ
	MgWJOZNsQMKcAm4Se691M4OEhYBKvjZHQ3QKSHybfIgFolpWYtMBZpBrJATus0n0/HzFCHGy
	pMTBFTdYJjAKL2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRGI6n/z2T2sG4ssHiEKMA
	B6MSD+9HoVMBQqyJZcWVuYcYJTiYlUR4t+0CCvGmJFZWpRblxxeV5qQWH2L0AbpkIrOUaHI+
	MFbySuINjU3MTY1NLY2MzExNcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamDkNLQO399W
	ftj/X9NFFumfk434pb5ee6ti6Bv2K+y5xM8GF5Hzt16uOO6e5dNp/Xi26cz5niFPaiS5Vltm
	Wa++fCPiX7r69wv70iwOhJf09V/atH7KMk7fMEbD4/M9U9ccdtjL7HzZX+PimWevueQmf7B3
	Dtqu7djR0iH7yy5lQYvOobnSWv5KLMUZiYZazEXFiQDiAB//dAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAd2IfacCDP49MLTo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj6Z/K
	gs3yFQcbbrE0MM6X7GLk5JAQMJFY8vIBE4QtJnHh3no2EFtIYBGjxKEOky5GLiC7h0ni1dRZ
	zCAJNgEziYOLVrOD2CICCRKdk06BNTMLvGaUWLiXFcQWFvCTWLR1Plg9i4CqROv6a2BDeQVc
	Ja6t2AJkcwAtU5CYM8kGJMwp4Cax91o3M0hYCKjka3P0BEbeBYwMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCw/2Z1A7GlQ0WhxgFOBiVeHg/Cp0KEGJNLCuuzD3EKMHBrCTCu20XUIg3
	JbGyKrUoP76oNCe1+BCjD9BNE5mlRJPzgbGYVxJvaGxibmpsamliYWJmiUNYSZy32SMlQEgg
	PbEkNTs1tSC1CGYcEwenVAPj8W+XWI9alWy/3nF5XmT3ducJgtF9Qs48028e+bmQMUbJfd8k
	liO6ccHFPjJsZxorj4SnNP0sY1MP+Zam9UjMT/yc8sQ1KwKDZ1g2W9UHRVneXCUQWBPsMufn
	SfFjesk5dSkRzZnr92/Yf2D6un+yyy7Ev9u5QM7oj94rNjHxxUEabw2msQgpsRRnJBpqMRcV
	JwIAT0slzqQCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes use of the generic fucntions in of_i2c.c to parse arbitration
timing information and GPIOs for arbitration.

Also uses devm_gpio_request() instead of gpio_request() and
removes the gpio_free() calls

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c |   79 +++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 32 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index e93e7d6..d055cf8 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -855,54 +855,61 @@ static inline void s3c24xx_i2c_deregister_cpufreq(struct s3c24xx_i2c *i2c)
 #endif
 
 #ifdef CONFIG_OF
-static int s3c24xx_i2c_parse_dt_gpio(struct s3c24xx_i2c *i2c)
+static int of_i2c_parse_gpio(struct device *dev, const char *name,
+		int gpios[], size_t count, bool required)
 {
-	int idx, gpio, ret;
-
-	if (i2c->quirks & QUIRK_NO_GPIO)
-		return 0;
+	struct device_node *dn = dev->of_node;
+	int idx, gpio;
 
-	for (idx = 0; idx < 2; idx++) {
-		gpio = of_get_gpio(i2c->dev->of_node, idx);
+	for (idx = 0; idx < count; idx++) {
+		gpio = of_get_named_gpio(dn, name, idx);
 		if (!gpio_is_valid(gpio)) {
-			dev_err(i2c->dev, "invalid gpio[%d]: %d\n", idx, gpio);
-			goto free_gpio;
+			dev_dbg(dev, "invalid gpio[%d]: %d\n", idx, gpio);
+			if (idx || required) {
+				dev_err(dev, "invalid gpio[%d]: %d\n",
+					idx, gpio);
+			}
+			return -EINVAL;
 		}
-		i2c->gpios[idx] = gpio;
+		gpios[idx] = gpio;
 
-		ret = gpio_request(gpio, "i2c-bus");
-		if (ret) {
-			dev_err(i2c->dev, "gpio [%d] request failed\n", gpio);
-			goto free_gpio;
+		if (devm_gpio_request(dev, gpio, "i2c-bus")) {
+			dev_err(dev, "gpio [%d] request failed\n", gpio);
+			return -EINVAL;
 		}
 	}
 	return 0;
-
-free_gpio:
-	while (--idx >= 0)
-		gpio_free(i2c->gpios[idx]);
-	return -EINVAL;
 }
 
-static void s3c24xx_i2c_dt_gpio_free(struct s3c24xx_i2c *i2c)
+static int s3c24xx_i2c_parse_dt_gpio(struct s3c24xx_i2c *i2c)
 {
-	unsigned int idx;
+	int ret = 0;
 
 	if (i2c->quirks & QUIRK_NO_GPIO)
-		return;
+		goto out;
+
+	if (of_i2c_parse_gpio(i2c->dev, "gpios", i2c->gpios, 2, true)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	for (idx = 0; idx < 2; idx++)
-		gpio_free(i2c->gpios[idx]);
+	if (i2c->adap.gpio_arbit) {
+		if (!of_i2c_parse_gpio(i2c->dev, "bus-arbitration-gpios",
+			i2c->adap.gpio_arbit->arb_gpios, I2C_ARB_GPIO_COUNT,
+			false)) {
+			dev_warn(i2c->dev, "GPIO-based arbitration enabled");
+		} else
+			ret = -EINVAL;
+	}
+
+ out:
+	return ret;
 }
 #else
 static int s3c24xx_i2c_parse_dt_gpio(struct s3c24xx_i2c *i2c)
 {
 	return 0;
 }
-
-static void s3c24xx_i2c_dt_gpio_free(struct s3c24xx_i2c *i2c)
-{
-}
 #endif
 
 /* s3c24xx_i2c_init
@@ -981,6 +988,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 {
 	struct s3c24xx_i2c *i2c;
 	struct s3c2410_platform_i2c *pdata = NULL;
+	struct i2c_gpio_arbit *arbit = NULL;
 	struct resource *res;
 	int ret;
 
@@ -1004,11 +1012,21 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_noclk;
 	}
 
+	arbit = devm_kzalloc(&pdev->dev, sizeof(*arbit), GFP_KERNEL);
+	if (!arbit) {
+		ret = -ENOMEM;
+		goto err_noclk;
+	}
+
 	i2c->quirks = s3c24xx_get_device_quirks(pdev);
 	if (pdata)
 		memcpy(i2c->pdata, pdata, sizeof(*pdata));
-	else
+	else {
 		s3c24xx_i2c_parse_dt(pdev->dev.of_node, i2c);
+		/* Arbitration parameters */
+		i2c->adap.gpio_arbit = of_get_arbitrator_info(
+					pdev->dev.of_node, arbit);
+	}
 
 	strlcpy(i2c->adap.name, "s3c2410-i2c", sizeof(i2c->adap.name));
 	i2c->adap.owner   = THIS_MODULE;
@@ -1158,9 +1176,6 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 	clk_disable_unprepare(i2c->clk);
 	clk_put(i2c->clk);
 
-	if (pdev->dev.of_node && IS_ERR(i2c->pctrl))
-		s3c24xx_i2c_dt_gpio_free(i2c);
-
 	return 0;
 }
 
-- 
1.7.9.5

