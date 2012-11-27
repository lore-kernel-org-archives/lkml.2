Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2K0NDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:03:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36139 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2K0NDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:03:30 -0500
X-AuditID: cbfee61b-b7f616d00000319b-47-50b4ba20e91c
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com
Subject: [PATCH 2/3] ARM: exynos5: Add gate clocks for HS-I2C
Date: Tue, 27 Nov 2012 18:30:35 +0530
Message-id: <1354021236-28596-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
References: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkTldh15YAg7b3shYdf78wWlzeNYfN
	Ysb5fUwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZfxbplhwg7Pi4K0OtgbGB+xdjJwcEgImEgcX
	74OyxSQu3FvPBmILCSxllJix1RqmZk3TZnaI+CJGiYP3zLsYuYDsHiaJzonPWUASbAJmEgcX
	rWYHSYgI9DJKLNy0lRnEYQbpOHPxKJDDwSEsYCtx5SkTSAOLgKrExK9LwJp5BVwlLrXcYAMp
	kRBQkJgzyQbE5BRwk1ixwwZir6vE2m/nGCE6BSS+TT7EAlEtK7HpANgiCYHHbBJPnvcwQdws
	KXFwxQ2WCYzCCxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEBuTpf8+kdzCuarA4xCjA
	wajEw5u5aHOAEGtiWXFl7iFGCQ5mJRHehau2BAjxpiRWVqUW5ccXleakFh9i9AG6ZCKzlGhy
	PjBa8kriDY1NzE2NTS2NjMxMTXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgDHN8aTnt
	aIbo3jNmcs/NpHi/KIirxvo8OVP3l8tCpT5zks5x1mkpHzau3mR38aZ3FEvvjJqoWn3LtBMW
	R7Q48+yyjlQ/dpv+Xcj5t/OfXzwfssJZK96n9ArXJP12qPbjZDTuOXotvb76VknDEk+1TMXX
	Obd3mit9m65jP1lQvnZ+e+rcsC9KLMUZiYZazEXFiQAi583edQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAV2FXVsCDL5NELDo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj3zLF
	ghucFQdvdbA1MD5g72Lk5JAQMJFY07QZyhaTuHBvPRuILSSwiFHi4D3zLkYuILuHSaJz4nMW
	kASbgJnEwUWr2UESIgK9jBILN21lBnGYQTrOXDwK5HBwCAvYSlx5ygTSwCKgKjHx6xKwZl4B
	V4lLLTfYQEokBBQk5kyyATE5BdwkVuywgdjrKrH22znGCYy8CxgZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEB/wz6R2MqxosDjEKcDAq8fBmLtocIMSaWFZcmXuIUYKDWUmEd+GqLQFC
	vCmJlVWpRfnxRaU5qcWHGH2AbprILCWanA+MxrySeENjE3NTY1NLEwsTM0scwkrivM0eKQFC
	AumJJanZqakFqUUw45g4OKUaGHWZnd8ua3yx4d63b/Wnbxyfoe0jEGUTY3WiJnHDjWWBojuz
	l0bxnX35NNBmz7PTpnftE1mOFexQ3xV3bKelZLH6c7ntB1MSXmxTmC1SMuHWg9OsG4zPyB+/
	5+23fXbEzmPTDmV94Ks00F1leFLzYf/PfrHaxDX8DPusPjTX+pzgyLt/4uFzu19KLMUZiYZa
	zEXFiQC35hcBpQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds clock gating bits for High Speed I2C channels 0, 1, 2 and 3.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 arch/arm/mach-exynos/clock-exynos5.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 2d3057b..37c6104 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -781,6 +781,26 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_peric_ctrl,
 		.ctrlbit	= (1 << 26),
 	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hs-i2c.0",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.ctrlbit	= (1 << 28),
+	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hs-i2c.1",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.ctrlbit	= (1 << 29),
+	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hs-i2c.2",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.ctrlbit	= (1 << 30),
+	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hs-i2c.3",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.ctrlbit	= (1 << 31),
+	}, {
 		.name		= "ac97",
 		.devname	= "samsung-ac97",
 		.enable		= exynos5_clk_ip_peric_ctrl,
-- 
1.7.9.5

