Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2LNKpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:45:11 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9217 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2LNKpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:45:08 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f0-50cb02e88f71
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: [PATCH] gpio: samsung: remove exynos_gpio_cfg
Date: Fri, 14 Dec 2012 19:44:01 +0900
Message-id: <1355481842-17952-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zPd2XTKcDDGZuYLS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4vbCDveCgdMXzBVINjLPEuhg5OCQETCRm3uPqYuQE
	MsUkLtxbz9bFyMUhJLCMUeLK7kMsEAkTiWX/fzKB2EIC0xkl5s9KgihqYZI4N6OJHSTBJqAn
	cWfbcbAiEQFziSmvX7GB2MwC5RLtv3czg9jCAmYSc6Y8A6tnEVCV6HzcBlbDK+AucfNyEyPE
	QQoScybZQJQISHybDHIDSFhWYtMBZpC1EgJ72CRu9O5khLhNUuLgihssExgFFzAyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQICSvpHYyrGiwOMQpwMCrx8H4QOhUgxJpYVlyZe4hRgoNZ
	SYRX8ghQiDclsbIqtSg/vqg0J7X4EKMP0CUTmaVEk/OBIZ9XEm9obGBsaGhpaGZqaWqAQ1hJ
	nLfZIyVASCA9sSQ1OzW1ILUIZhwTBycw+GMXfr5lYbzZ7YR4NtOl3FM+fOwfFLXFNyvsmXjr
	vNzN6KDnux7cS2EvOTHPNlD6zDeW421lv68/Pxp4eHn3kc+X/+/jic1wYVxzS+l04azFGnGL
	km6v3h6vFi66dMkniZnyfoVi51xfTnFknCzuG3V6k7ProntZmrV6T+df3rr1Q6c25/QJy6qV
	WIozEg21mIuKEwEg1IGpWAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd0XTKcDDHatMLO4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuL2wg73goHTF
	8wVSDYyzxLoYOTkkBEwklv3/yQRhi0lcuLeeDcQWEpjOKDF/VlIXIxeQ3cIkcW5GEztIgk1A
	T+LOtuNgDSIC5hJTXr8Ca2AWKJdo/72bGcQWFjCTmDPlGVg9i4CqROfjNrAaXgF3iZuXmxi7
	GDmAlilIzJlkM4GRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4LB9Jr2DcVWDxSFG
	AQ5GJR7eD0KnAoRYE8uKK3MPMUpwMCuJ8EoeAQrxpiRWVqUW5ccXleakFh9i9AFaPpFZSjQ5
	HxhTeSXxhsYmZkaWRmbGJubGxjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwAoPNJUL7l8WH
	N/Ir/026YRMj+anwhejKLcsNKqaUfYufZjmhlPPazFqlr/eq5py6I2Ow5myjb+rvxA/RNbO6
	8ywOvfw7s3NzHd/BoC9HlTfO8/iRcDPKZ8amWwXOp/uiWSbq2XzYefDgpTBRcb6FXacuzAu9
	1z/t0rfeff8dVS5u3fn25sknXSsVRJVYijMSDbWYi4oTAahXSuCIAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exynos_gpio_cfg can be substituted to samsung_gpio_cfgs[8].

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpio/gpio-samsung.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 6f93d36..a462f2c 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -452,15 +452,6 @@ static struct samsung_gpio_cfg s3c24xx_gpiocfg_banka = {
 };
 #endif
 
-#if defined(CONFIG_ARCH_EXYNOS4) || defined(CONFIG_ARCH_EXYNOS5)
-static struct samsung_gpio_cfg exynos_gpio_cfg = {
-	.set_pull	= exynos_gpio_setpull,
-	.get_pull	= exynos_gpio_getpull,
-	.set_config	= samsung_gpio_setcfg_4bit,
-	.get_config	= samsung_gpio_getcfg_4bit,
-};
-#endif
-
 #if defined(CONFIG_CPU_S5P6440) || defined(CONFIG_CPU_S5P6450)
 static struct samsung_gpio_cfg s5p64x0_gpio_cfg_rbank = {
 	.cfg_eint	= 0x3,
@@ -2181,7 +2172,7 @@ static struct samsung_gpio_chip s5pv210_gpios_4bit[] = {
  * Followings are the gpio banks in EXYNOS SoCs
  *
  * The 'config' member when left to NULL, is initialized to the default
- * structure exynos_gpio_cfg in the init function below.
+ * structure samsung_gpio_cfgs[8] in the init function below.
  *
  * The 'base' member is also initialized in the init function below.
  * Note: The initialization of 'base' member of samsung_gpio_chip structure
@@ -2837,7 +2828,7 @@ static __init void exynos4_gpiolib_init(void)
 
 	for (i = 0; i < nr_chips; i++, chip++) {
 		if (!chip->config) {
-			chip->config = &exynos_gpio_cfg;
+			chip->config = &samsung_gpio_cfgs[8];
 			chip->group = group++;
 		}
 		exynos_gpiolib_attach_ofnode(chip,
@@ -2864,7 +2855,7 @@ static __init void exynos4_gpiolib_init(void)
 
 	for (i = 0; i < nr_chips; i++, chip++) {
 		if (!chip->config) {
-			chip->config = &exynos_gpio_cfg;
+			chip->config = &samsung_gpio_cfgs[8];
 			chip->group = group++;
 		}
 		exynos_gpiolib_attach_ofnode(chip,
@@ -2885,7 +2876,7 @@ static __init void exynos4_gpiolib_init(void)
 
 	for (i = 0; i < nr_chips; i++, chip++) {
 		if (!chip->config) {
-			chip->config = &exynos_gpio_cfg;
+			chip->config = &samsung_gpio_cfgs[8];
 			chip->group = group++;
 		}
 		exynos_gpiolib_attach_ofnode(chip,
@@ -2940,7 +2931,7 @@ static __init void exynos5_gpiolib_init(void)
 
 	for (i = 0; i < nr_chips; i++, chip++) {
 		if (!chip->config) {
-			chip->config = &exynos_gpio_cfg;
+			chip->config = &samsung_gpio_cfgs[8];
 			chip->group = group++;
 		}
 		exynos_gpiolib_attach_ofnode(chip,
@@ -2961,7 +2952,7 @@ static __init void exynos5_gpiolib_init(void)
 
 	for (i = 0; i < nr_chips; i++, chip++) {
 		if (!chip->config) {
-			chip->config = &exynos_gpio_cfg;
+			chip->config = &samsung_gpio_cfgs[8];
 			chip->group = group++;
 		}
 		exynos_gpiolib_attach_ofnode(chip,
@@ -2989,7 +2980,7 @@ static __init void exynos5_gpiolib_init(void)
 
 	for (i = 0; i < nr_chips; i++, chip++) {
 		if (!chip->config) {
-			chip->config = &exynos_gpio_cfg;
+			chip->config = &samsung_gpio_cfgs[8];
 			chip->group = group++;
 		}
 		exynos_gpiolib_attach_ofnode(chip,
@@ -3010,7 +3001,7 @@ static __init void exynos5_gpiolib_init(void)
 
 	for (i = 0; i < nr_chips; i++, chip++) {
 		if (!chip->config) {
-			chip->config = &exynos_gpio_cfg;
+			chip->config = &samsung_gpio_cfgs[8];
 			chip->group = group++;
 		}
 		exynos_gpiolib_attach_ofnode(chip,
-- 
1.7.9.5

