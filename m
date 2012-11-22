Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2KVTrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:47:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28190 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2KVTrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:47:47 -0500
X-AuditID: cbfee61b-b7f616d00000319b-3a-50ae0d5c8734
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH v4 02/12] ARM: EXYNOS: add System MMU definition to DT
Date: Thu, 22 Nov 2012 20:32:44 +0900
Message-id: <002301cdc8a5$16d02070$44706150$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IpRavZ83IwrtnQYuCsCn7yVERlw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zY90Y3nUBBvt3qVlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW8a57AVLAut6Ltwg+mBsbDoV2MnBwSAiYSW7d/Y4aw
	xSQu3FvP1sXIxSEksIxR4v/3n0wwRRNOTmOESCxilGhpvccO4fxjlFiw/QsbSBWbgJbE6rnH
	wapEBHoZJS70f2UCcZgFfjBKTN/8iwWkSljATeLQi7tACzk4WARUJY4fEwIJ8wrYSixb+YUF
	whaU+DH5HpjNDDR0/c7jTBC2vMTmNW/BWiUE1CUe/dUFCYsI6EmcWH4eqkREYt+Ld4wgNouA
	gMS3yYdYIMplJTYdYAa5RkJgMrvEmmeToD6TlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKK
	UTS1ILmgOCk910ivODG3uDQvXS85P3cTIyRupHcwrmqwOMQowMGoxMObYbA2QIg1say4MvcQ
	owQHs5II7z3udQFCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M6bySeENjYxMzE1MTc0tT
	c1McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGEMOvuj39DvlV5PLLFayvthI5pCbnvfs
	7Py0qUz2ivq6/i3sVZG7ly/9qB94P833lrmNg9bth0qycR4zBFMlLD6+v/q21ttw3bpPPU++
	5VXd3JJ2neHc27TGj9N/z9u2NZLJYB3bigh9pbyZR2+ouP+KOmx5X96O+f2zbXerTgvFrrpy
	gefeUiWW4oxEQy3mouJEAJC70p7IAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd0Y3nUBBt++yVtc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvGuewFSwLrei
	7cIPpgbGw6FdjJwcEgImEhNOTmOEsMUkLtxbz9bFyMUhJLCIUaKl9R47hPOPUWLB9i9sIFVs
	AloSq+ceZwRJiAj0Mkpc6P/KBOIwC/xglJi++RcLSJWwgJvEoRd3mbsYOThYBFQljh8TAgnz
	CthKLFv5hQXCFpT4MfkemM0MNHT9zuNMELa8xOY1b8FaJQTUJR791QUJiwjoSZxYfh6qRERi
	34t3jBMYBWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwVD6T
	3sG4qsHiEKMAB6MSD2+GwdoAIdbEsuLK3EOMEhzMSiK897jXBQjxpiRWVqUW5ccXleakFh9i
	9AH6cyKzlGhyPjBh5JXEGxqbmBlZGplZGJmYm+MQVhLnbfZICRASSE8sSc1OTS1ILYIZx8TB
	KdXAWHdgbalw8+qLf6eenyPU176c0e3/+mmK9zadOCdwq69D0S/12IbdTwMvTbsl9PZrmWOl
	BfPuZeq3ywV/sjb4lWiIvo96es81eZX25XefpeJlU7zF1v3TKA698mO/wgvB12oRs2YLuqQr
	KH2UYGyM+S2SH7bGN5/lRXJVRF6xQ1Kkw21BB7e5SizFGYmGWsxFxYkA9Au3OvcCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds System MMU nodes to DT of Exynos SoCs.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 .../devicetree/bindings/arm/exynos/system-mmu.txt  |  86 ++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  96 ++++++++++++++
 arch/arm/boot/dts/exynos4x12.dtsi                  | 124 +++++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  | 147 ++++++++++++++++++++-
 4 files changed, 451 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/exynos/system-mmu.txt

diff --git a/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
b/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
new file mode 100644
index 0000000..9c30a36
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
@@ -0,0 +1,86 @@
+* Samsung Exynos System MMU
+
+Samsung's Exynos architecture includes System MMU that enables scattered
+physical chunks to be visible as a contiguous region to DMA-capabile peripheral
+devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
+
+System MMU is a sort of IOMMU and support identical translation table format to
+ARMv7 translation tables with minimum set of page properties including access
+permissions, shareability and security protection. In addition System MMU has
+another capabilities like L2 TLB or block-fetch buffers to minimize translation
+latency
+
+Each System MMU is included in the H/W block of a peripheral device. Thus, it is
+important to specify that a System MMU is dedicated to which peripheral device
+before using System MMU. System initialization must specify the relationships
+between a System MMU and a peripheral device that owns the System MMU.
+
+Some device drivers may control several peripheral devices with a single device
+descriptor like MFC. Since handling a System MMU with IOMMU API requires a
+device descriptor that needs the System MMU, it is best to combine the System
+MMUs of the peripheral devices and control them with a single System MMU device
+descriptor. If it is unable to combine them into a single device descriptor,
+they can be linked with each other by the means of device.parent relationship.
+
+Required properties:
+- compatible: Should be "samsung,exynos-sysmmu".
+- reg: Tuples of base address and size of System MMU registers. The number of
+       tuples can be more than one if two or more System MMUs are controlled
+       by a single device descriptor.
+- interrupt-parent: The phandle of the interrupt controller of System MMU
+- interrupts: Tuples of numbers that indicates the interrupt source. The
+              number of elements in the tuple is dependent upon
+	      'interrupt-parent' property. The number of tuples in this property
+	      must be the same with 'reg' property.
+
+Optional properties:
+- mmuname: Strings of the name of System MMU for debugging purpose. The number
+	   of strings must be the same with the number of tuples in 'reg'
+	   property.
+- mmu-master: phandle to the device node that owns System MMU. Only the device
+	   that is specified whith this property can control System MMU with
+	   IOMMU API.
+
+Examples:
+
+MFC has 2 System MMUs for each port that MFC is attached. Thus it seems natural
+to define 2 System MMUs for each port of the MFC:
+
+	sysmmu-mfc-l {
+		mmuname = "mfc_l";
+		reg = <0x11210000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		mmu-master = <&mfc>;
+	};
+
+	sysmmu-mfc-r {
+		mmuname = "mfc_r";
+		reg = <0x11200000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		mmu-master = <&mfc>;
+	};
+
+Actually, MFC device driver requires sub-devices that represents each port and
+above 'mmu-master' properties of sysmmu-mfc-l and sysmmu-mfc-r have the phandles
+to those sub-devices.
+
+However, it is also a good idea that treats the above System MMUs as one System
+MMU because those System MMUs are actually required by the MFC device:
+
+	sysmmu-mfc {
+		mmuname = "mfc_l", "mfc_r";
+		reg = <0x11210000 0x1000
+		       0x11200000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5
+			      6 2>;
+		mmu-master = <&mfc>;
+	};
+
+If System MMU of MFC is defined like the above, the number of elements and the
+order of list in 'mmuname', 'reg' and 'interrupts' must be the same.
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 939f639..d7a7a06 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -71,4 +71,100 @@
 		reg = <0x100C0000 0x100>;
 		interrupts = <2 4>;
 	};
+
+	sysmmu-mfcL {
+		mmuname = "mfc_l";
+		reg = <0x13620000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+	};
+
+	sysmmu-mfcR {
+		mmuname = "mfc_r";
+		reg = <0x13630000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+	};
+
+	sysmmu-tv {
+		mmuname = "tv";
+		reg = <0x13E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+	};
+
+	sysmmu-fimc0 {
+		mmuname = "fimc0";
+		reg = <0x11A20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+	};
+
+	sysmmu-fimc1 {
+		mmuname = "fimc1";
+		reg = <0x11A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 3>;
+	};
+
+	sysmmu-fimc2 {
+		mmuname = "fimc2";
+		reg = <0x11A40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 4>;
+	};
+
+	sysmmu-fimc3 {
+		mmuname = "fimc3";
+		reg = <0x11A50000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 5>;
+	};
+
+	sysmmu-jpeg {
+		mmuname = "jpeg";
+		reg = <0x11A60000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+	};
+
+	sysmmu-g2d {
+		mmuname = "g2d";
+		reg = <0x12A20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+	};
+
+	sysmmu-rotator {
+		mmuname = "rotator";
+		reg = <0x12A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+	};
+
+	sysmmu-fimd0 {
+		mmuname = "fimd0";
+		reg = <0x11E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+	};
+
+	sysmmu-fimd1 {
+		mmuname = "fimd1";
+		reg = <0x12220000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 3>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 179a62e..0c6d001 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -66,4 +66,128 @@
 		reg = <0x106E0000 0x1000>;
 		interrupts = <0 72 0>;
 	};
+
+	sysmmu-mfcL {
+		mmuname = "mfc_l";
+		reg = <0x13620000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+	};
+
+	sysmmu-mfcR {
+		mmuname = "mfc_r";
+		reg = <0x13630000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+	};
+
+	sysmmu-tv {
+		mmuname = "tv";
+		reg = <0x13E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+	};
+
+	sysmmu-fimc0 {
+		mmuname = "fimc0";
+		reg = <0x11A20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+	};
+
+	sysmmu-fimc1 {
+		mmuname = "fimc1";
+		reg = <0x11A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 3>;
+	};
+
+	sysmmu-fimc2 {
+		mmuname = "fimc2";
+		reg = <0x11A40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 4>;
+	};
+
+	sysmmu-fimc3 {
+		mmuname = "fimc3";
+		reg = <0x11A50000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 5>;
+	};
+
+	sysmmu-jpeg {
+		mmuname = "jpeg";
+		reg = <0x11A60000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+	};
+
+	sysmmu-g2d {
+		mmuname = "g2d";
+		reg = <0x10A40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+	};
+
+	sysmmu-rotator {
+		mmuname = "rotator";
+		reg = <0x12A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+	};
+
+	sysmmu-fimd0 {
+		mmuname = "fimd0";
+		reg = <0x11E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+	};
+
+	sysmmu-is0 {
+		mmuname = "isp", "drc", "fd";
+		reg = < 0x12260000 0x1000
+			0x12270000 0x1000
+			0x122A0000 0x1000 >;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <  16 2
+				16 3
+				16 4 >;
+	};
+
+	sysmmu-is1 {
+		mmuname = "ispcpu";
+		reg = <0x122B0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <16 5>;
+	};
+
+	sysmmu-flite0 {
+		mmuname = "fimc-lite0";
+		reg = <0x123B0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <16 0>;
+	};
+
+	sysmmu-flite1 {
+		mmuname = "fimc-lite1";
+		reg = <0x123C0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <16 1>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index cf6a02d..ff2311d 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -62,7 +62,7 @@
 		interrupts = <0 42 0>;
 	};
 
-	codec@11000000 {
+	mfc: codec@11000000 {
 		compatible = "samsung,mfc-v6";
 		reg = <0x11000000 0x10000>;
 		interrupts = <0 96 0>;
@@ -547,9 +547,152 @@
 		interrupts = <0 95 0>;
 	};
 
-	mixer {
+	mixer: mixer {
 		compatible = "samsung,exynos5-mixer";
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
 	};
+
+	sysmmu-mfc-l {
+		mmuname = "mfc_l";
+		reg = <0x11210000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		mmu-master = <&mfc>;
+	};
+
+	sysmmu-mfc-r {
+		mmuname = "mfc_r";
+		reg = <0x11200000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		mmu-master = <&mfc>;
+	};
+
+	sysmmu-tv {
+		mmuname = "tv";
+		reg = <0x14650000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <7 4>;
+		mmu-master = <&mixer>;
+	};
+
+	sysmmu-gsc0 {
+		mmuname = "gsc0";
+		reg = <0x13E80000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		mmu-master = <&gsc_0>;
+	};
+
+	sysmmu-gsc1 {
+		mmuname = "gsc1";
+		reg = <0x13E90000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>;
+		mmu-master = <&gsc_1>;
+	};
+
+	sysmmu-gsc2 {
+		mmuname = "gsc2";
+		reg = <0x13EA0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		mmu-master = <&gsc_2>;
+	};
+
+	sysmmu-gsc3 {
+		mmuname = "gsc3";
+		reg = <0x13EB0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 6>;
+		mmu-master = <&gsc_3>;
+	};
+
+	sysmmu-fimd1 {
+		mmuname = "fimd1";
+		reg = <0x14640000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <3 2>;
+	};
+
+	sysmmu-rotator {
+		mmuname = "rotator";
+		reg = <0x11D40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+	};
+
+	sysmmu-is0 {
+		mmuname = "isp", "drc", "scalerc", "scalerp", "fd", "mcu";
+		reg = < 0x13260000 0x1000
+			0x13270000 0x1000
+			0x13280000 0x1000
+			0x13290000 0x1000
+			0x132A0000 0x1000
+			0x132B0000 0x1000 >;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <  10 6
+				11 6
+				 5 2
+				 3 6
+				 5 0
+				 5 4 >;
+	};
+
+	sysmmu-is1 {
+		mmuname = "odc", "dis0", "dis1", "3dnr";
+		reg = < 0x132C0000 0x1000
+			0x132D0000 0x1000
+			0x132E0000 0x1000
+			0x132F0000 0x1000 >;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <  11 0
+				10 4
+				 9 4
+				 5 6 >;
+	};
+
+	sysmmu-2d {
+		mmuname = "2d";
+		reg = <0x10A60000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+	};
+
+	sysmmu-jpeg {
+		mmuname = "jpeg";
+		reg = <0x11F20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+	};
+
+	sysmmu-flite0 {
+		mmuname = "flite0";
+		reg = <0x13C40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+	};
+
+	sysmmu-flite1 {
+		mmuname = "flite1";
+		reg = <0x13C50000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+	};
 };
-- 
1.8.0


