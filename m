Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2LRPeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:34:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31722 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2LRPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:34:05 -0500
X-AuditID: cbfee61b-b7f616d00000319b-8e-50d08cea69a7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com, balbi@ti.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        p.paneri@samsung.com
Subject: [PATCH 1/2] ARM: Exynos5250: Enabling samsung-usbphy driver
Date: Tue, 18 Dec 2012 21:09:41 +0530
Message-id: <1355845182-14104-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkVvdVz4UAg+e91haXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZXxdsoOpYI5QxYZzC9kaGNfydzFyckgImEgs
	aDvICGGLSVy4t56ti5GLQ0hgKaPEhivTGGGKDv08zgiRWMQo8f/6DXaQhJDAZCaJhi3pIDab
	gK5E09tdYA0iAqoSn9sWsIM0MAv0MUlcPLYXyOHgEBZwkXh+mhWkhgWoZuOX/SwgNq+Ah8Sm
	1i9QyxQk3tx+xgxicwp4Sixs+gW1y0Pi8Mt5UL0CEt8mH2IBGSkhICux6QAzyCoJgcdsEv87
	9kLNkZQ4uOIGywRG4QWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxAsPy9L9n0jsYVzVY
	HGIU4GBU4uH9GX8+QIg1say4MvcQowQHs5IIr0LrhQAh3pTEyqrUovz4otKc1OJDjD5Al0xk
	lhJNzgfGTF5JvKGxibmpsamlkZGZqSkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjBL5
	kuqP3lz3TeFd89Pb35tvXabM7HU8Z4SumGRdbUsM2ByjK7xc5kJtgNQG8VihQpEzy+RkRDxz
	J8pLv9NVnRp+8PO/aNaFCcE902zuqEryPrj7nXX1neOaXkuX6QQXHHp2yX+Z8uo20XOVM/ZG
	Z2gk3o0PK56V+tzrgkVS9Y+Ss+fT6z9NUWIpzkg01GIuKk4EAMIebMx4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAd1XPRcCDL6t1LG4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjHj65Id
	TAVzhCo2nFvI1sC4lr+LkZNDQsBE4tDP44wQtpjEhXvr2boYuTiEBBYxSvy/foMdJCEkMJlJ
	omFLOojNJqAr0fR2F1iDiICqxOe2BewgDcwCfUwSF4/tBXI4OIQFXCSen2YFqWEBqtn4ZT8L
	iM0r4CGxqfUL1DIFiTe3nzGD2JwCnhILm35B7fKQOPxyHusERt4FjAyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYKD/pn0DsZVDRaHGAU4GJV4eH/Gnw8QYk0sK67MPcQowcGsJMKr0Hoh
	QIg3JbGyKrUoP76oNCe1+BCjD9BVE5mlRJPzgRGZVxJvaGxibmpsamliYWJmiUNYSZy32SMl
	QEggPbEkNTs1tSC1CGYcEwenVAPj9NMbTaNtQ0U/v+aczHspv3d+z+uTHW90vbO7VmXf0znG
	09Tf476g8U7EXf7L+U/OP01h5GAL8Op99kHi+Huz2ibX19Hp0jGXJDUaH0Qd432Xfopngtuz
	I2pMD0tXTXm5myMl0KilzuLXbJWWeQfSZNevF+r9sySv/OP5Y38jV0y+FS0bZOmtxFKckWio
	xVxUnAgAglHoKacCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding usbphy node for Exynos5250 along with the
necessary device data to be parsed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi       |   22 ++++++++++++++++++++++
 arch/arm/mach-exynos/include/mach/map.h |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c  |    2 ++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 581e57a..bbdb2c2 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -299,6 +299,28 @@
 		rx-dma-channel = <&pdma0 11>; /* preliminary */
 	};
 
+	phy_h0: usbdev_phyctrl@10040704 {
+		compatible = "samsung,usbdev-phyctrl";
+		samsung,phyhandle-reg = <0x10040704>;
+	};
+
+	phy_h1: usbhost_phyctrl@10040708 {
+		compatible = "samsung,usbhost-phyctrl";
+		samsung,phyhandle-reg = <0x10040708>;
+	};
+
+	phy_h2: usbhost_phycfg@10050230 {
+		compatible = "samsung,usb-phycfg";
+		samsung,phyhandle-reg = <0x10050230>;
+	};
+
+	usbphy@12130000 {
+		compatible = "samsung,exynos5250-usbphy";
+		reg = <0x12130000 0x100>;
+		samsung,usb-phyhandle = <&phy_h0 &phy_h1 &phy_h2>;
+		samsung,enable-mask = <1>;
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index cbb2852..778348e 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -201,6 +201,7 @@
 #define EXYNOS4_PA_EHCI			0x12580000
 #define EXYNOS4_PA_OHCI			0x12590000
 #define EXYNOS4_PA_HSPHY		0x125B0000
+#define EXYNOS5_PA_HSPHY		0x12130000
 #define EXYNOS4_PA_MFC			0x13400000
 
 #define EXYNOS4_PA_UART			0x13800000
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 462e5ac..24e7529 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -110,6 +110,8 @@ static const struct of_dev_auxdata exynos5250_auxdata_lookup[] __initconst = {
 				"samsung-i2s.1", NULL),
 	OF_DEV_AUXDATA("samsung,samsung-i2s", 0x12D70000,
 				"samsung-i2s.2", NULL),
+	OF_DEV_AUXDATA("samsung,exynos5250-usbphy", EXYNOS5_PA_HSPHY,
+				"s3c-usbphy", NULL),
 	{},
 };
 
-- 
1.7.6.5

