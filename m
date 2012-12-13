Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2LMQaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:30:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30490 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2LMQaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:30:15 -0500
X-AuditID: cbfee61b-b7f616d00000319b-24-50ca02959f42
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, jg1.han@samsung.com,
        thomas.abraham@linaro.org
Subject: [PATCH v3 1/2] ARM: Exynos5250: Enabling ehci-s5p driver
Date: Thu, 13 Dec 2012 22:06:01 +0530
Message-id: <1355416562-25539-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355416562-25539-1-git-send-email-gautam.vivek@samsung.com>
References: <1355416562-25539-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWyRsSkSncq06kAg8ePRCwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgyrg5/TVzwR3pimcz5zI2MH4S62Lk5JAQMJE4
	9+sQM4QtJnHh3nq2LkYuDiGBpYwSL8+1ssMUze67D5WYziixqOElK4QzmUnizZcTrCBVbAK6
	Ek1vdzGC2CICRRL75v9gBiliFljIKPH+5UmwHcICjhJfJrSANbAIqEq87GoFa+AV8JDoan/C
	ArFOQeLN7Wdg9ZwCnhLzz28EqxcCqplz8zw7RK+AxLfJh4DqOYDqZSU2HQDbJSHwmE1i/ePb
	UHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzA0Dz975n0DsZVDRaH
	GAU4GJV4eAvDTwYIsSaWFVfmHmKU4GBWEuG98RooxJuSWFmVWpQfX1Sak1p8iNEH6JKJzFKi
	yfnAuMkriTc0NjE3NTa1NDIyMzXFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgXGh9795
	V+bLdzw7kbNEKzVg9rytfjP0mNT12z9rTTcol4xpPpe7+lzrKhPxaPXnl5s+vdjs6X6J+cEX
	recLpu8/H79UZ9mNbm097+vbvnRm9XuHb1qpXnrn9sZY1+Cn1vHPWcun/Guz37NFSdehWuX/
	Dqtd3ItXfO5dXdTRWLKRI6ZVc8PG3+FKLMUZiYZazEXFiQDctoudegIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQd2pTKcCDFZt5bC4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj5vTX
	zAV3pCuezZzL2MD4SayLkZNDQsBEYnbffTYIW0ziwr31QDYXh5DAdEaJRQ0vWSGcyUwSb76c
	YAWpYhPQlWh6u4sRxBYRKJLYN/8HM0gRs8BCRon3L08ygySEBRwlvkxoAWtgEVCVeNnVCtbA
	K+Ah0dX+hAVinYLEm9vPwOo5BTwl5p/fCFYvBFQz5+Z59gmMvAsYGVYxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBAf+M+kdjKsaLA4xCnAwKvHwFoafDBBiTSwrrsw9xCjBwawkwnvjNVCI
	NyWxsiq1KD++qDQntfgQow/QVROZpUST84FRmVcSb2hsYm5qbGppYmFiZolDWEmct9kjJUBI
	ID2xJDU7NbUgtQhmHBMHp1QDo8lELsmPb4pF1x5Wni9ydNf88NefAtJELp+R6uHdcLd9x5R9
	+Z1Fu1suJTJItMTarnVPjDFb9PSUbrbfpQs3I3OfeMadsXRU2xzB0/qmV+TQU4uFG7XXBM9K
	Fpf8kHhJp3upUsL0k+pXXxyYnlz0+QWP3NVN9496fvy5/MqNqVKHn8/5NvNnk4cSS3FGoqEW
	c1FxIgCqz0nvqQIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding EHCI device tree node for Exynos5250 along with
the device base adress and gpio line for vbus.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 .../devicetree/bindings/usb/exynos-usb.txt         |   25 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    4 +++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++
 arch/arm/mach-exynos/include/mach/map.h            |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 +
 5 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/exynos-usb.txt

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
new file mode 100644
index 0000000..e8bbb47
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -0,0 +1,25 @@
+Samsung Exynos SoC USB controller
+
+The USB devices interface with USB controllers on Exynos SOCs.
+The device node has following properties.
+
+EHCI
+Required properties:
+ - compatible: should be "samsung,exynos4210-ehci" for USB 2.0
+   EHCI controller in host mode.
+ - reg: physical base address of the controller and length of memory mapped
+   region.
+ - interrupts: interrupt number to the cpu.
+
+Optional properties:
+ - samsung,vbus-gpio:  if present, specifies the GPIO that
+   needs to be pulled up for the bus to be powered.
+
+Example:
+
+	usb@12110000 {
+		compatible = "samsung,exynos4210-ehci";
+		reg = <0x12110000 0x100>;
+		interrupts = <0 71 0>;
+		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 711b55f..f990086 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -218,4 +218,8 @@
 	i2s_2: i2s@12D70000 {
 		status = "disabled";
 	};
+
+	usb@12110000 {
+		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 581e57a..584bb9a 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -299,6 +299,12 @@
 		rx-dma-channel = <&pdma0 11>; /* preliminary */
 	};
 
+	usb@12110000 {
+		compatible = "samsung,exynos4210-ehci";
+		reg = <0x12110000 0x100>;
+		interrupts = <0 71 0>;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index cbb2852..b2c662f 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -201,6 +201,7 @@
 #define EXYNOS4_PA_EHCI			0x12580000
 #define EXYNOS4_PA_OHCI			0x12590000
 #define EXYNOS4_PA_HSPHY		0x125B0000
+#define EXYNOS5_PA_EHCI			0x12110000
 #define EXYNOS4_PA_MFC			0x13400000
 
 #define EXYNOS4_PA_UART			0x13800000
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 462e5ac..b3b9af1 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -110,6 +110,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"samsung-i2s.1", NULL),
 	OF_DEV_AUXDATA("samsung,samsung-i2s", 0x12D70000,
 				"samsung-i2s.2", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-ehci", EXYNOS5_PA_EHCI,
+				"s5p-ehci", NULL),
 	{},
 };
 
-- 
1.7.6.5

