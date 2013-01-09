Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab3AIL7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:59:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3AIL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:59:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-4f-50ed5bad7c14
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: myungjoo.ham@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, rjw@sisk.pl, jhbird.choi@samsung.com,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH 1/4] ARM: EXYNOS5: Add PPMU device tree support
Date: Wed, 09 Jan 2013 17:36:36 +0530
Message-id: <1357733199-17206-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkVndd9NsAg0PbWC0u75rDZvG59wij
	A5PH501yAYxRXDYpqTmZZalF+nYJXBmrzzxkK3ggWHF+5TymBsYlfF2MnBwSAiYSh6acYoWw
	xSQu3FvP1sXIxSEksJRR4turHcwwRYvefGGGSExnlDi64BErhNPHJLFx411GkCo2AT2JBf++
	gnWICORKzJw5hwXEZhbIl/g6aSkbiC0sYC9x+VgLO4jNIqAqceHHKbAaXgFXiU9P/wAN5QDa
	piAxZ5INRImAxLfJh1ggwrISmw6A3SAhcIBNYun1P2wQx0lKHFxxg2UCo+ACRoZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGIHBdfrfM+kdjKsaLA4xCnAwKvHwMnq+DRBiTSwrrsw9xCjB
	wawkwhvsCxTiTUmsrEotyo8vKs1JLT7E6AN0yURmKdHkfGDg55XEGxqbmJsam1oaGZmZmuIQ
	VhLnZTz1JEBIID2xJDU7NbUgtQhmHBMHp1QDoxHnFtZOpim2fV3a63dnblhaqBSYNu/fvPPT
	p6iI3Vt4ykrTrKlN9uq38Klz/FI8pL7v+ly2Uv3BQ5feG/vKNabuypiU//3Zf7Wu05/vly9s
	Xxlvb8HVvFHuTeN/kROTDNJebmVseXjn/pr/qz3WMD/Icbyx+VFRgVGHQXxbUWFZyIH7pQr7
	diuxFGckGmoxFxUnAgAwakzMWwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t9jQd210W8DDH6uNrG4vGsOm8Xn3iOM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmrD7zkK3ggWDF
	+ZXzmBoYl/B1MXJySAiYSCx684UZwhaTuHBvPVsXIxeHkMB0RomjCx6xQjh9TBIbN95lBKli
	E9CTWPDvK1iHiECuxMyZc1hAbGaBfImvk5aygdjCAvYSl4+1sIPYLAKqEhd+nAKr4RVwlfj0
	9A/QUA6gbQoScybZTGDkXsDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOHSfSe9gXNVg
	cYhRgINRiYeX0fNtgBBrYllxZe4hRgkOZiUR3mBfoBBvSmJlVWpRfnxRaU5q8SFGH6DlE5ml
	RJPzgXGVVxJvaGxibmpsamliYWJmiUNYSZyX8dSTACGB9MSS1OzU1ILUIphxTBycUg2Miy9U
	rYnW39V6jeezA0/4rpM/+YV3ba3MrNpxfdOrVy5XGg6UREYKHtme0+teIOrDWSphtK94UdQW
	8SqLP6Z9CnsLr+z8JfPm+5fzyUwBHbvsxMQ/Pfz4fbv0xs3+bzfbOCmE9vf8va6hUxX54rx7
	l42G5P9+617+f9v5VzEtWVP9ZKr6mvvlSizFGYmGWsxFxYkApKmMfooCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPMU is required by the devfreq driver. Add a device tree
node for it.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 .../bindings/arm/exynos/ppmu-exynos5.txt           |   28 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    9 ++++++
 2 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt

diff --git a/Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt b/Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt
new file mode 100644
index 0000000..a424dfa
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/exynos/ppmu-exynos5.txt
@@ -0,0 +1,28 @@
+Exynos5 PPMU driver
+-------------------
+
+Performance events are primitive values used to get performance data. These
+events provide information about the behavior of the SoC that can be used
+when analyzing system performance. These events are made visible using the
+PPMU logic.
+Exynos5 PPMU driver is used by the exynos5 devfreq driver to control the bus
+frequency/voltage.
+
+Required properties:
+- compatible: should be one of the following.
+	* samsung,exynos5-ppmu - for exynos5250 type ppmu.
+- reg:
+	* physical base address of the PPMUs (DDR, Right Bus and CPU) and
+	length of memory mapped region.
+
+Example:
+--------
+
+	ppmu {
+		compatible = "samsung,exynos5250-ppmu";
+		reg = <0x10C40000 0x2000
+		       0x10C50000 0x2000
+		       0x10C60000 0x2000
+		       0x10CB0000 0x2000
+		       0x13660000 0x2000>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 30485de..d504cba 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -732,4 +732,13 @@
 		interrupt-parent = <&combiner>;
 		interrupts = <24 1>;
 	};
+
+	ppmu {
+		compatible = "samsung,exynos5250-ppmu";
+		reg = <0x10C40000 0x2000	/* PPMU_DDR_C */
+		       0x10C50000 0x2000	/* PPMU_DDR_R1 */
+		       0x10CB0000 0x2000	/* PPMU_DDR_L */
+		       0x13660000 0x2000	/* PPMU_DDR_RIGHT */
+		       0x10C60000 0x2000>;	/* PPMU_DDR_CPU */
+	};
 };
-- 
1.7.8.6

