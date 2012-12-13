Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2LMQls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:41:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:49473 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab2LMQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:41:45 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b5-50ca0547b8f7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        tomasz.figa@gmail.com, balbi@ti.com, thomas.abraham@linaro.org,
        av.tikhomirov@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3] ARM: Exynos5250: Enabling dwc3-exynos driver
Date: Thu, 13 Dec 2012 22:17:43 +0530
Message-id: <1355417263-27369-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <CAFp+6iFjY9gp1x6eDCLP-WJvv++wO7fw+U_9U+0OnNb99baeEA@mail.gmail.com>
References: <CAFp+6iFjY9gp1x6eDCLP-WJvv++wO7fw+U_9U+0OnNb99baeEA@mail.gmail.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWyRsSkTted9VSAwd9vxhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZVx+YFZwSbtiz/rJzA2Me5S7GDk4JARMJDYe
	M+li5AQyxSQu3FvP1sXIxSEksJRR4s6KK4wQCROJ3bs3M4HYQgKLGCWOrXeHKJrMJHH27XNm
	kASbgK5E09tdYA0iAkUS++b/YAYpYhZ4wihx8NNEFpCEsICDxJo1v8CKWARUJU6+uwYW5xXw
	kJje9pkZYpuCxJvbz8BsToFgiR0HVjOCXCokECDx+pwTRKuAxLfJh1ggHpCV2HQAbJWEwH02
	ic0Ht0GNkZQ4uOIGywRG4QWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxAkPy9L9nUjsY
	VzZYHGIU4GBU4uEtCD8ZIMSaWFZcmXuIUYKDWUmE98ZroBBvSmJlVWpRfnxRaU5q8SFGH6BL
	JjJLiSbnA+MlryTe0NjE3NTY1NLIyMzUFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbG
	yokdjccZ/OLsFm51fsKpYhG1UO5n7w1mr/TMl1b3yh88lFh6u2i++aaf0YcNtXfYXF7sceXh
	dYUqjgymhVO+64t6WgYJ7Zcy+vkudMmd31cUZbKVf31UsLZINot3FbypmxMo5JTauVgkYuGz
	7Om37m558dZpnn/Ur7pz0THq8268fOr79esiJZbijERDLeai4kQAYDFgt3YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAV131lMBBrfXqlhc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx+YFZ
	wSXtij3rJzM3MO5R7mLk5JAQMJHYvXszE4QtJnHh3no2EFtIYBGjxLH17l2MXED2ZCaJs2+f
	M4Mk2AR0JZre7mIEsUUEiiT2zf/BDFLELPCEUeLgp4ksIAlhAQeJNWt+gRWxCKhKnHx3DSzO
	K+AhMb3tMzPENgWJN7efgdmcAsESOw6sBqrnANoWIPH6nNMERt4FjAyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYJD/pnUDsaVDRaHGAU4GJV4eAvCTwYIsSaWFVfmHmKU4GBWEuG98Roo
	xJuSWFmVWpQfX1Sak1p8iNEH6KiJzFKiyfnAeMwriTc0NjE3NTa1NLEwMbPEIawkztvskRIg
	JJCeWJKanZpakFoEM46Jg1OqgdFcUGeeW9GqiIb187j9n2xWvsL1oOsfY6D247b9q8NMqlp/
	OpwvkuyvVcnlYVdemqdktH6nsdwpW4VtZ97OTl57zfXOzrCk6P0//lU4B8kyPg1P+/A174Wb
	qcH5X99sUrcckky7mClb3tQtmX21y+VCsM+1G7ZJk711prxNPXx+J5efS+pLFSWW4oxEQy3m
	ouJEAF6PKsymAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding DWC3 device tree node for Exynos5250 along with the
device address and clock support needed for the controller.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
Changes from v2:
 - Changed the compatible string to chip specific(samsung,exynos5250),
   since dwc3-exynos is being used from exynso5250 onwards.
 - Based on changes for USB 2.0:
   https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/024413.html

Changes from v1:
 - Changed the device node name from 'dwc3' to 'usb@12000000'.
 - Added the documentation for device tree bindings for dwc3 controller.


 .../devicetree/bindings/usb/exynos-usb.txt         |   14 +++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 +++++
 arch/arm/mach-exynos/Kconfig                       |    1 +
 arch/arm/mach-exynos/clock-exynos5.c               |   24 ++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h            |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    2 +
 6 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index f66fcdd..d660410 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -38,3 +38,17 @@ Example:
 		reg = <0x12120000 0x100>;
 		interrupts = <0 71 0>;
 	};
+
+DWC3
+Required properties:
+ - compatible: should be "samsung,exynos5250-dwc3" for USB 3.0 DWC3 controller.
+ - reg: physical base address of the controller and length of memory mapped
+   region.
+ - interrupts: interrupt number to the cpu.
+
+Example:
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwc3";
+		reg = <0x12000000 0x10000>;
+		interrupts = <0 72 0>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 75510d1..001a31b 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -299,6 +299,12 @@
 		rx-dma-channel = <&pdma0 11>; /* preliminary */
 	};
 
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwc3";
+		reg = <0x12000000 0x10000>;
+		interrupts = <0 72 0>;
+	};
+
 	usb@12110000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12110000 0x100>;
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 91d5b6f..09f9587 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -426,6 +426,7 @@ config MACH_EXYNOS5_DT
 	depends on ARCH_EXYNOS5
 	select ARM_AMBA
 	select USE_OF
+	select USB_ARCH_HAS_XHCI
 	help
 	  Machine support for Samsung EXYNOS5 machine with device tree enabled.
 	  Select this if a fdt blob is available for the EXYNOS5 SoC based board.
diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index 5c63bc7..f2214a0 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -768,6 +768,11 @@ static struct clk exynos5_init_clocks_off[] = {
 		.enable		= exynos5_clk_ip_fsys_ctrl ,
 		.ctrlbit	= (1 << 18),
 	}, {
+		.name		= "usbdrd30",
+		.parent		= &exynos5_clk_aclk_200.clk,
+		.enable		= exynos5_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 19),
+	}, {
 		.name		= "usbotg",
 		.enable		= exynos5_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 7),
@@ -1121,6 +1126,16 @@ static struct clksrc_sources exynos5_clkset_group = {
 	.nr_sources	= ARRAY_SIZE(exynos5_clkset_group_list),
 };
 
+struct clk *exynos5_clkset_usbdrd30_list[] = {
+	[0] = &exynos5_clk_mout_mpll.clk,
+	[1] = &exynos5_clk_mout_cpll.clk,
+};
+
+struct clksrc_sources exynos5_clkset_usbdrd30 = {
+	.sources        = exynos5_clkset_usbdrd30_list,
+	.nr_sources     = ARRAY_SIZE(exynos5_clkset_usbdrd30_list),
+};
+
 /* Possible clock sources for aclk_266_gscl_sub Mux */
 static struct clk *clk_src_gscl_266_list[] = {
 	[0] = &clk_ext_xtal_mux,
@@ -1415,6 +1430,15 @@ static struct clksrc_clk exynos5_clksrcs[] = {
 			.parent		= &exynos5_clk_mout_cpll.clk,
 		},
 		.reg_div = { .reg = EXYNOS5_CLKDIV_GEN, .shift = 4, .size = 3 },
+	}, {
+		.clk    = {
+			.name           = "sclk_usbdrd30",
+			.enable         = exynos5_clksrc_mask_fsys_ctrl,
+			.ctrlbit        = (1 << 28),
+		},
+		.sources = &exynos5_clkset_usbdrd30,
+		.reg_src = { .reg = EXYNOS5_CLKSRC_FSYS, .shift = 28, .size = 1 },
+		.reg_div = { .reg = EXYNOS5_CLKDIV_FSYS0, .shift = 24, .size = 4 },
 	},
 };
 
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 4bf6fd9..74470ca 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -201,6 +201,7 @@
 #define EXYNOS4_PA_EHCI			0x12580000
 #define EXYNOS4_PA_OHCI			0x12590000
 #define EXYNOS4_PA_HSPHY		0x125B0000
+#define EXYNOS5_PA_DRD			0x12000000
 #define EXYNOS5_PA_EHCI			0x12110000
 #define EXYNOS5_PA_OHCI			0x12120000
 #define EXYNOS4_PA_MFC			0x13400000
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 07aa586..26dd6c8 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -114,6 +114,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"s5p-ehci", NULL),
 	OF_DEV_AUXDATA("samsung,exynos4210-ohci", EXYNOS5_PA_OHCI,
 				"exynos-ohci", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-dwc3", EXYNOS5_PA_DRD,
+				"exynos-dwc3", NULL),
 	{},
 };
 
-- 
1.7.6.5

