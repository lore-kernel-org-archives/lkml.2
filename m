Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab2LRPed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:34:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31804 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2LRPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:34:31 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ef-50d08d056334
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com, balbi@ti.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        p.paneri@samsung.com
Subject: [PATCH 2/2] ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy
 driver
Date: Tue, 18 Dec 2012 21:09:42 +0530
Message-id: <1355845182-14104-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkSpe190KAwbQrVhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZez6VlDwhLVibnMHawPjA5YuRk4OCQETidXb
	NkHZYhIX7q1n62Lk4hASWMoo8eXVWXaYohtztjOB2EICixglbs7ygCiazCTxpOsII0iCTUBX
	ountLjBbREBV4nPbAnaQImaBPiaJi8f2gk0SFgiTeDz3GNg6FqCi80d3gk3lFfCQ2HLuKCPE
	NgWJN7efMYPYnAKeEgubfrFDbPaQOPxyHitEr4DEt8mHgOZwANXLSmw6wAyyS0LgPpvE8mmf
	2CDmSEocXHGDZQKj8AJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYgWF5+t8z6R2Mqxos
	DjEKcDAq8fD+jD8fIMSaWFZcmXuIUYKDWUmEV6H1QoAQb0piZVVqUX58UWlOavEhRh+gSyYy
	S4km5wNjJq8k3tDYxNzU2NTSyMjM1BSHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRvl5
	FcEqIjGVIlPqavYy1+1ytY3ztFhRMsvmwqyydVNKDlqv+baPY6FRW3RQwZHrB+Wy3ayDDe/U
	aZ9PmxVWHPbtpILYFcueUzs+Wns27LH0+btkvu6k+QJa+41d8y8d3qdw+WDFBo+Z2gm6u82U
	1/rYhref3ji/bdLnz9HKtZXBSpMZDAXeKLEUZyQaajEXFScCAEU94s94AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAV3W3gsBBhsP6lpc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix61tB
	wRPWirnNHawNjA9Yuhg5OSQETCRuzNnOBGGLSVy4t54NxBYSWMQocXOWRxcjF5A9mUniSdcR
	RpAEm4CuRNPbXWC2iICqxOe2BewgRcwCfUwSF4/tZQdJCAuESTyeewxsAwtQ0fmjO8E28Ap4
	SGw5d5QRYpuCxJvbz5hBbE4BT4mFTb/YITZ7SBx+OY91AiPvAkaGVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBQf9MegfjqgaLQ4wCHIxKPLw/488HCLEmlhVX5h5ilOBgVhLhVWi9ECDE
	m5JYWZValB9fVJqTWnyI0QfoqonMUqLJ+cCIzCuJNzQ2MTc1NrU0sTAxs8QhrCTO2+yREiAk
	kJ5YkpqdmlqQWgQzjomDU6qBMUsw7e+ppVt/PFqwoyGkZPn1+EIhzvky4poc8z/o8v6w+XL3
	6J71TmXOQlLz1KRM2C461f04sVHjb8akde+1S9t5l62MiQo8vFTnmOT6Bawnbr5rvhHJqDtR
	2UvNL1W9vWuC1dLWO3ql8+8lXfp/bNI6w1d75flb353NZ9lqxx+f/PTYRlblRiWW4oxEQy3m
	ouJEANlxpDenAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding base address information required for enabling
USB 3.0 DRD phy on exynos5250 SOC.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index bbdb2c2..07b7477 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -316,7 +316,8 @@
 
 	usbphy@12130000 {
 		compatible = "samsung,exynos5250-usbphy";
-		reg = <0x12130000 0x100>;
+		reg = <0x12130000 0x100>,
+		      <0x12100000 0x100>;
 		samsung,usb-phyhandle = <&phy_h0 &phy_h1 &phy_h2>;
 		samsung,enable-mask = <1>;
 	};
-- 
1.7.6.5

