Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2LMQb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:31:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:30508 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2LMQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:30:37 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ca-50ca02ac4874
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, jg1.han@samsung.com,
        thomas.abraham@linaro.org
Subject: [PATCH v3 2/2] ARM: Exynos5250: Enabling ohci-exynos driver
Date: Thu, 13 Dec 2012 22:06:02 +0530
Message-id: <1355416562-25539-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355416562-25539-1-git-send-email-gautam.vivek@samsung.com>
References: <1355416562-25539-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkVncN06kAg0OfpC0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgylj1+C9zwV3RirbVk5kaGP8IdjFyckgImEg8
	n7qOBcIWk7hwbz1bFyMXh5DAUkaJTffPMMMUtTa9g0pMZ5RY8WASC4QzmUni36rPjCBVbAK6
	Ek1vd4HZIgJFEvvm/2AGKWIWWMgo8f7lSbBRwgIuEjubn7F3MXJwsAioStycEw4S5hXwkGhZ
	e48dYpuCxJvbz8DKOQU8Jeaf38gKYgsB1cy5eR6shkVAQOLb5EMsIGMkBGQlNh0AWyUh8JhN
	YsGaLYwQcyQlDq64wTKBUXgBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjMDAPP3vmfQO
	xlUNFocYBTgYlXh4C8NPBgixJpYVV+YeYpTgYFYS4b3xGijEm5JYWZValB9fVJqTWnyI0Qfo
	konMUqLJ+cCoySuJNzQ2MTc1NrU0MjIzNcUhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB
	sTfQvL5T91rWbm/LvTn9Sw4UZnYcCp54Wqmjaol8brOpQNjmPnPnk3sYFwbHTvt0uO+VaMit
	/5vf/M2S9DedYrbb4/Sx71nNdquyFtjJT57HWiz67XkG6+M3qgpPtIUMFVbyBK99uJ5fP2z2
	tFD/z8+nB1+5E1c4I1n6kdQsq14rw9U8G6NLlFiKMxINtZiLihMBW+JxaHkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd01TKcCDHreC1hc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix6vFf
	5oK7ohVtqyczNTD+Eexi5OSQEDCRaG16xwZhi0lcuLceyObiEBKYziix4sEkFghnMpPEv1Wf
	GUGq2AR0JZre7gKzRQSKJPbN/8EMUsQssJBR4v3Lk8wgCWEBF4mdzc/Yuxg5OFgEVCVuzgkH
	CfMKeEi0rL3HDrFNQeLN7Wdg5ZwCnhLzz29kBbGFgGrm3DzPPoGRdwEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4LB/Jr2DcVWDxSFGAQ5GJR7ewvCTAUKsiWXFlbmHGCU4mJVEeG+8
	BgrxpiRWVqUW5ccXleakFh9i9AE6aiKzlGhyPjAm80riDY1NzE2NTS1NLEzMLHEIK4nzNnuk
	BAgJpCeWpGanphakFsGMY+LglGpg1JuW2RC2KsKcU+3TKufjJ4ND3ewX5rDvsau8/URGprbO
	7Nyss4dYMsIrpkesbmlR5LD8s2xFd/nLYt6DE1aHX+jm06sw6vn7sT7y0OL3xzPktp3gvRwq
	tiTka2zD9nfvF4Zq7LG79rq/QmXOgsyeB92fzV1XuB66Y1t7QYvB6ti2NoOwkwv3K7EUZyQa
	ajEXFScCAP91mxioAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding OHCI device tree node for Exynos5250 along with
the device base address.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
---
 .../devicetree/bindings/usb/exynos-usb.txt         |   15 +++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++++
 arch/arm/mach-exynos/include/mach/map.h            |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 ++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index e8bbb47..f66fcdd 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -23,3 +23,18 @@ Example:
 		interrupts = <0 71 0>;
 		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
 	};
+
+OHCI
+Required properties:
+ - compatible: should be "samsung,exynos4210-ohci" for USB 2.0
+   OHCI companion controller in host mode.
+ - reg: physical base address of the controller and length of memory mapped
+   region.
+ - interrupts: interrupt number to the cpu.
+
+Example:
+	usb@12120000 {
+		compatible = "samsung,exynos4210-ohci";
+		reg = <0x12120000 0x100>;
+		interrupts = <0 71 0>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 584bb9a..75510d1 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -305,6 +305,12 @@
 		interrupts = <0 71 0>;
 	};
 
+	usb@12120000 {
+		compatible = "samsung,exynos4210-ohci";
+		reg = <0x12120000 0x100>;
+		interrupts = <0 71 0>;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index b2c662f..4bf6fd9 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -202,6 +202,7 @@
 #define EXYNOS4_PA_OHCI			0x12590000
 #define EXYNOS4_PA_HSPHY		0x125B0000
 #define EXYNOS5_PA_EHCI			0x12110000
+#define EXYNOS5_PA_OHCI			0x12120000
 #define EXYNOS4_PA_MFC			0x13400000
 
 #define EXYNOS4_PA_UART			0x13800000
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index b3b9af1..07aa586 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -112,6 +112,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"samsung-i2s.2", NULL),
 	OF_DEV_AUXDATA("samsung,exynos4210-ehci", EXYNOS5_PA_EHCI,
 				"s5p-ehci", NULL),
+	OF_DEV_AUXDATA("samsung,exynos4210-ohci", EXYNOS5_PA_OHCI,
+				"exynos-ohci", NULL),
 	{},
 };
 
-- 
1.7.6.5

