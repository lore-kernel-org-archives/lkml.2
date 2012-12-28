Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2L1Lmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:42:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51333 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2L1Lme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:42:34 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-27-50dd85a88562
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] ARM: exynos5: Add gate clocks for HS-I2C
Date: Fri, 28 Dec 2012 17:10:50 +0530
Message-id: <1356694851-1345-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkTndF690Ag4Xz1S0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL+v7/DVvCLq+L28u3MDYyPOboYOTkkBEwkJh+cwARh
	i0lcuLeerYuRi0NIYCmjRPPBY8xdjBxgRe/fFELEFzFKTL29jAXC6WGSmH7qFwtIN5uAmcTB
	RavZQWwRAVWJz20L2EGKmAWuMUrMfbKLESQhLGAr8fTqBSaQqSxARX8XGoOEeQVcJDZte8IE
	sUxBYs4kG5Awi4CAxLfJh1ggwrISmw4wg0yUEDjCJjFxwmxmiKMlJQ6uuMEygVFwASPDKkbR
	1ILkguKk9FxDveLE3OLSvHS95PzcTYzA0Dr975nUDsaVDRaHGAU4GJV4eBf23AkQYk0sK67M
	PcQowcGsJMLb13w3QIg3JbGyKrUoP76oNCe1+BCjD9AlE5mlRJPzgWGfVxJvaGxibmpsamlk
	ZGZqikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAOjj7xcY/Zn71W+L00zuD/wmyz08N0k
	azf78ruWSf57L3r16342OFl1awbfepfp/Aqnrq46VaW0KuON/v/zk98eW7rUuOd6UUGFS/zZ
	RY1nxKu6Fj7cveZz28VLG7SmrD0e2rXyfs4lw4aNlY8aTui8+nVNLU1/59H9vcocuxdzTrf/
	p1f8bOcpHyWW4oxEQy3mouJEAGfKoA1aAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9jAd0VrXcDDPbslrG4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM+P/+DlvBL66K
	28u3MzcwPuboYuTgkBAwkXj/prCLkRPIFJO4cG89WxcjF4eQwCJGiam3l7FAOD1MEtNP/WIB
	qWITMJM4uGg1O4gtIqAq8bltATtIEbPANUaJuU92MYIkhAVsJZ5evcAEsoEFqOjvQmOQMK+A
	i8SmbU+YIBYrSMyZZDOBkXsBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODAfSa1g3Fl
	g8UhRgEORiUe3oU9dwKEWBPLiitzDzFKcDArifD2Nd8NEOJNSaysSi3Kjy8qzUktPsToA7R7
	IrOUaHI+MKrySuINjU3MTY1NLU0sTMwscQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamA0
	k1T7YiUgIhtj5Pyz2VyvjPfshum7FqmxXGwreRO8575Ct6I7k+ym8CZPly/sX3cFfneZr3Hr
	40X7+alNTutt561eyeE82bM36/TMfLb7mcxX8tSmONw8u3Rh8yf1j/9tfy2fbhJc7ORaF8Kh
	26mX/cqwLWxu04K5i+ZXn6uXnvn2akJG1GclluKMREMt5qLiRADSts5iiQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds clock gating bits for High Speed I2C channels 0, 1, 2 and 3.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 arch/arm/mach-exynos/clock-exynos5.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 0208c3a..f9fa0c7 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -753,6 +753,30 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_peric_ctrl,
 		.ctrlbit	= (1 << 27),
 	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hsi2c.0",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.parent		= &exynos5_clk_aclk_66.clk,
+		.ctrlbit	= (1 << 28),
+	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hsi2c.1",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.parent		= &exynos5_clk_aclk_66.clk,
+		.ctrlbit	= (1 << 29),
+	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hsi2c.2",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.parent		= &exynos5_clk_aclk_66.clk,
+		.ctrlbit	= (1 << 30),
+	}, {
+		.name		= "hsi2c",
+		.devname	= "exynos5-hsi2c.3",
+		.enable		= exynos5_clk_ip_peric_ctrl,
+		.parent		= &exynos5_clk_aclk_66.clk,
+		.ctrlbit	= (1 << 31),
+	}, {
 		.name		= "usbhost",
 		.enable		= exynos5_clk_ip_fsys_ctrl ,
 		.ctrlbit	= (1 << 18),
-- 
1.7.9.5

