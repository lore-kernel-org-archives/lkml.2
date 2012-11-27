Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2K0NEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:04:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27801 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2K0NEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:04:10 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e2-50b4ba48c899
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com
Subject: [PATCH 3/3] arm: exynos5: Add HS-I2C device tree platform information
Date: Tue, 27 Nov 2012 18:30:36 +0530
Message-id: <1354021236-28596-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
References: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkVtdj15YAg+l71C06/n5htLi8aw6b
	xYzz+5gcmD0+b5ILYIzisklJzcksSy3St0vgyrj4YBpLwSn+iq2nZ7E2MO7l6WLk5JAQMJFY
	fP4XG4QtJnHh3nogm4tDSGApo8STlu+MMEWr/0xkh0gsYpRYsO8XlNPDJNE2fwsLSBWbgJnE
	wUWrwRIiAr2MEgs3bWUGcZhBWs5cPMoMUiUs4Ccxee5usIUsAqoSj44sA9rBwcEr4Cpxtr8U
	xJQQUJCYM8kGxOQUcJNYscMGpFgIqGDtt3OMEI0CEt8mH2KBqJaV2HQAbJGEwHM2iR2vOtkh
	jpaUOLjiBssERuEFjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MQLD8vS/Z9I7GFc1WBxi
	FOBgVOLhzVy0OUCINbGsuDL3EKMEB7OSCO/CVVsChHhTEiurUovy44tKc1KLDzH6AF0ykVlK
	NDkfGDN5JfGGxibmpsamlkZGZqamOISVxHmbPVIChATSE0tSs1NTC1KLYMYxcXBKNTDaWb14
	8nLqCmfGvHO3hFfU/dCqdK1xmF92prDw2r4ZZ57eZ3hvLcRpF6JU1Hf+1PEOKdcV/U/1JGs9
	mv/m7VD2mLh0asXM1jwL1zKVPPkPFcen33iiWbq84Ikn32F5/y+n+Mq3dIiv2Ft27OUzUbPr
	1g6NsV+lvyxYzZa4SEzZ7/Q6Af32VYJKLMUZiYZazEXFiQDq3oTQeAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAV2PXVsCDF4tk7To+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj4oNp
	LAWn+Cu2np7F2sC4l6eLkZNDQsBEYvWfiewQtpjEhXvr2boYuTiEBBYxSizY94sdwulhkmib
	v4UFpIpNwEzi4KLVYAkRgV5GiYWbtjKDOMwgLWcuHmUGqRIW8JOYPHc3G4jNIqAq8ejIMsYu
	Rg4OXgFXibP9pSCmhICCxJxJNiAmp4CbxIodNiDFQkAFa7+dY5zAyLuAkWEVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnDQP5PewbiqweIQowAHoxIPb+aizQFCrIllxZW5hxglOJiVRHgX
	rtoSIMSbklhZlVqUH19UmpNafIjRB+ikicxSosn5wIjMK4k3NDYxNzU2tTSxMDGzxCGsJM7b
	7JESICSQnliSmp2aWpBaBDOOiYNTqoFR7M2dvwxvD7kU3Ga5VPvn+PPHxacWp6svKjaZv6Lj
	IssxjS0nm5KmhZokne1V0K7ddN5/8QSbwE7nWuU5U/9Hrl244M/ng282dDr+9o6YdIVvGfOS
	io7rTPsvW1/Sqdh7Y0fMLbNivX1347dXyKpZPJ9ZIRN5nH1XscN2PeGe876zTtywmPpQW4ml
	OCPRUIu5qDgRAHe7UrenAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds HS-I2C device tree platform information in
exynos5.dtsi and exynos5-smdk5250.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |   16 +++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi         |   32 +++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index fc37e19..4e22b84 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -161,6 +161,22 @@
 		};
 	};
 
+	hsi2c@12C50000 {
+		status = "disabled";
+	};
+
+	hsi2c@12D00000 {
+		status = "disabled";
+	};
+
+	hsi2c@12D50000 {
+		status = "disabled";
+	};
+
+	hsi2c@12DE0000 {
+		status = "disabled";
+	};
+
 	dwmmc_0: dwmmc0@12200000 {
 		num-slots = <1>;
 		supports-highspeed;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index a42b02b0..276ecb3 100755
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -182,6 +182,38 @@
 		#size-cells = <0>;
 	};
 
+	hsi2c@12C50000 {
+		compatible = "samsung,exynos5-hs-i2c";
+		reg = <0x12C50000 0x1000>;
+		interrupts = <0 56 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	hsi2c@12D00000 {
+		compatible = "samsung,exynos5-hs-i2c";
+		reg = <0x12D00000 0x1000>;
+		interrupts = <0 57 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	hsi2c@12D50000 {
+		compatible = "samsung,exynos5-hs-i2c";
+		reg = <0x12D50000 0x1000>;
+		interrupts = <0 58 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	hsi2c@12DE0000 {
+		compatible = "samsung,exynos5-hs-i2c";
+		reg = <0x12DE0000 0x1000>;
+		interrupts = <0 59 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
 	spi_0: spi@12d20000 {
 		compatible = "samsung,exynos4210-spi";
 		reg = <0x12d20000 0x100>;
-- 
1.7.9.5

