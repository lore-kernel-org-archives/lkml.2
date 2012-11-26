Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2KZBbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 20:31:41 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:64298 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab2KZBb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 20:31:28 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-bd-50b2c66e1fa8
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>,
        "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: 
In-reply-to: 
Subject: [PATCH v4 2/2] therma: exynos: Supports thermal tripping
Date: Mon, 26 Nov 2012 10:31:25 +0900
Message-id: <000101cdcb75$c03344d0$4099ce70$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22X7ZVF4M1NdAyQSSqkck9CTHe3QAAAg6wADTi5aAD4ZQRQAEu+fZg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zI928Y5sCDJ7/4bO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZsz/xFkyQqDjw+SBjA+NegS5GTg4JAROJI2/WMULYYhIX7q1n
	62Lk4hASWMYo0X7vFBtM0aTle9khEosYJR5sXsoE4cxjkli27wULSBWbgK7EsfVbWEFsEYFo
	iT+Ne5hBipgFmhglGucvAnI4gDq4JVY3B4HUcArwSKz708kMYgsLOEp8fXQebA6LgKrE4qZ5
	YCfxCthJLLj/jwnCFpT4MfkeWA2zgJbE+p3HmSBseYnNa96CjZcQUJd49FcX4gQ3iZZF+1kh
	SkQk9r14xwgxXkDi2+RDLBDlshKbDoBdKSGwiF3i55VTrBAPS0ocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESWVI7GFc2WBxiFOBgVOLhNfi1
	MUCINbGsuDL3EKMEB7OSCO9Epk0BQrwpiZVVqUX58UWlOanFhxh9gC6fyCwlmpwPjPq8knhD
	Y2MTMxNTE3NLU3NTHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhhl5pp29iWGpgbfehMn
	x3J70mmZZbxXHnf/SP0c2+PTt8R+jcXc3zV21/qz905eIve5aZn6d2lvtfOGndqTTwuV+ut7
	h0s8/GvBtciO/8u0bL63wjsfXGcL/hdYvPHq7d3zrmyN5M/U61LnuZETlOfPceCLHs/uK18+
	Md3TqxYqX/ti8qNUY1YlluKMREMt5qLiRADeWyuw2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd28Y5sCDBY+4bK4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGbM/8RZMkKg48PkgYwPj
	XoEuRk4OCQETiUnL97JD2GISF+6tZ+ti5OIQEljEKPFg81ImCGcek8SyfS9YQKrYBHQljq3f
	wgpiiwhES/xp3MMMUsQs0MQo0Th/EZDDAdTBLbG6OQikhlOAR2Ldn05mEFtYwFHi66PzYHNY
	BFQlFjfNYwSxeQXsJBbc/8cEYQtK/Jh8D6yGWUBLYv3O40wQtrzE5jVvwcZLCKhLPPqrC3GC
	m0TLov2sECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS
	9ZLzczcxguP2mdQOxpUNFocYBTgYlXh4DX5tDBBiTSwrrsw9xCjBwawkwjuRaVOAEG9KYmVV
	alF+fFFpTmrxIUYfoEcnMkuJJucDU0peSbyhsYmZkaWRmYWRibk5DmElcd5mj5QAIYH0xJLU
	7NTUgtQimHFMHJxSDYypvscEeGY3vV98yu6m8ZbdGk3yL5Mzzh54E6H8+s2DiHDDnsZpu9rs
	/j8yvvBradHr39UdAc2zbxW7XYkIdTVYWNyptiR50x9VsUNKucc/Ryl0RMj4Je1hdzjJaGR6
	U0uvVe/1lT3X/pVl1Cv7T/d3SmyXN7JVNYkONWj/pXI9Y0U914TDdUosxRmJhlrMRcWJAA63
	A9wIAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TMU urgently sends active-high signal (thermal trip) to PMU,
and thermal tripping by hardware logic i.e PMU is performed.
Thermal tripping means that PMU cut off the whole power of SoC
by controlling external voltage regulator.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/thermal/exynos_thermal.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c
b/drivers/thermal/exynos_thermal.c
index 129e827..f0ce099 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -631,6 +631,12 @@ static int exynos_tmu_initialize(struct platform_device
*pdev)
                        goto out;
                }
                rising_threshold |= (threshold_code << 16);
+               threshold_code = temp_to_code(data,
pdata->trigger_levels[3]);
+               if (threshold_code < 0) {
+                       ret = threshold_code;
+                       goto out;
+               }
+               rising_threshold |= (threshold_code << 24);

                writel(rising_threshold,
                                data->base + EXYNOS_THD_TEMP_RISE);
@@ -669,10 +675,14 @@ static void exynos_tmu_control(struct platform_device
*pdev, bool on)

        if (on) {
                con |= EXYNOS_TMU_CORE_ON;
-               interrupt_en = pdata->trigger_level3_en << 12 |
-                       pdata->trigger_level2_en << 8 |
+               interrupt_en = pdata->trigger_level2_en << 8 |
                        pdata->trigger_level1_en << 4 |
                        pdata->trigger_level0_en;
+
+               if (data->soc == SOC_ARCH_EXYNOS4210)
+                       interrupt_en |= pdata->trigger_level3_en << 12;
+               else
+                       con |= pdata->trigger_level3_en << 12;
        } else {
                interrupt_en = 0; /* Disable all interrupts */
        }
@@ -770,6 +780,7 @@ static struct exynos_tmu_platform_data const
exynos_default_tmu_data = {
        .trigger_levels[0] = 85,
        .trigger_levels[1] = 103,
        .trigger_levels[2] = 110,
+       .trigger_levels[3] = 120,
        .trigger_level0_en = 1,
        .trigger_level1_en = 1,
        .trigger_level2_en = 1,
@@ -917,8 +928,10 @@ static int __devinit exynos_tmu_probe(struct
platform_device *pdev)
        /* Register the sensor with thermal management interface */
        (&exynos_sensor_conf)->private_data = data;
        exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
-                       pdata->trigger_level1_en + pdata->trigger_level2_en
+
-                       pdata->trigger_level3_en;
+                       pdata->trigger_level1_en + pdata->trigger_level2_en;
+
+       if (data->soc == SOC_ARCH_EXYNOS4210)
+               exynos_sensor_conf.trip_data.trip_count +=
pdata->trigger_level3_en;

        for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
                exynos_sensor_conf.trip_data.trip_val[i] =
--
1.7.4.1

