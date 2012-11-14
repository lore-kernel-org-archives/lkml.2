Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab2KNIvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:51:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:45647 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2KNIvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:51:10 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-90-50a35b7cd374
From: Cho KyongHo <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: [PATCH 3/4] ARM: EXYNOS: add System MMU definition to DT
Date: Wed, 14 Nov 2012 17:51:08 +0900
Message-id: <002301cdc245$307eca00$917c5e00$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3CRTBipmveUOsnSsuuVE6J/qZztg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI92a6MUBBqevmVtc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVM65zMVvA0qWLapzmsDYybfbsYOTkkBEwkds5tY4Gw
	xSQu3FvPBmILCSxjlJg5yRKmZtn078wQ8emMEkdniHQxcgHZ/xgl9v5dBZZgE9CSWD33OCNI
	QkSgl1HiQv9XJhCHWeABo8SKww+ZQKqEBRwljh14wQhiswioSjx+uxxsNa+ArcSuVy+gbEGJ
	H5PvgdnMQFPX7zzOBGHLS2xe8xZoGwfQSeoSj/7qgoRFBPQkDt/6zQpRIiKx78U7qPECEt8m
	H2KBKJeV2HSAGeQcCYHJ7BKPd99lhfhMUuLgihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHU
	guSC4qT0XEO94sTc4tK8dL3k/NxNjJCokdrBuLLB4hCjAAejEg/vx9ZFAUKsiWXFlbmHGCU4
	mJVEeGOtFgcI8aYkVlalFuXHF5XmpBYfYvQBunwis5Rocj4wovNK4g2NjU3MTExNzC1NzU1x
	CCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYJT7se7RIT3zOz/0F+cEC92e4WN+9j5DzJze
	x63BXmu0HR8o1u14eLHJ9JDm5Yad7pf8WD7PLC/3fiK3s9604qvX3jtR4hbSmxWNfzxc+UF0
	874l+/crTsk5qjqlfpnR87bd/y0+ZWySYXBtzlvLW3OGzTu3RU3h5oVNd9/srJ0df+5rfIqo
	QKMSS3FGoqEWc1FxIgCUZJFjxwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd2a6MUBBneOG1hc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmTOuczFbwNKli
	2qc5rA2Mm327GDk5JARMJJZN/84MYYtJXLi3ng3EFhKYzihxdIZIFyMXkP2PUWLv31VgRWwC
	WhKr5x5nBEmICPQySlzo/8oE4jALPGCUWHH4IRNIlbCAo8SxAy8YQWwWAVWJx2+Xs4DYvAK2
	ErtevYCyBSV+TL4HZjMDTV2/8zgThC0vsXnNW6BtHEAnqUs8+qsLEhYR0JM4fOs3K0SJiMS+
	F+8YJzAKzEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCofCa1
	g3Flg8UhRgEORiUe3o+tiwKEWBPLiitzDzFKcDArifDGWi0OEOJNSaysSi3Kjy8qzUktPsTo
	A/ToRGYp0eR8YMLIK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JESICSQnliSmp2aWpBaBDOOiYNT
	qoHRdfdSjcP1x2rlPZO0VjXGWJcKRpb+ry2ddOfyZcZnhw5OW3K4+0ezwJL7d4Ie8F2ZJluQ
	bTPn8bHgWr4Y7fbgmL81apuLVG69eRFqYvIv6mJca26Ug82fV6u8732tvyR55HxOxoU8E81D
	Fcq7RL9t63zBpifZb7uocVled4NrlHWxzd6MskwlluKMREMt5qLiRACTntcp9wIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds System MMU nodes to DT of Exynos SoCs.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 .../devicetree/bindings/arm/samsung/system-mmu.txt |  42 ++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  96 ++++++++++++++
 arch/arm/boot/dts/exynos4x12.dtsi                  | 124 +++++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  | 147 ++++++++++++++++++++-
 4 files changed, 407 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

diff --git a/Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
b/Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
new file mode 100644
index 0000000..5115c39
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
@@ -0,0 +1,42 @@
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
index 179a62e..0490836 100644
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
+		reg = <0x12260000 0x1000
+			0x12270000 0x1000
+			0x122A0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <16 2
+				16 3
+				16 4>;
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
index cf6a02d..7d1eaa3 100644
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
+	sysmmu-mfcL {
+		mmuname = "mfc_l";
+		reg = <0x11210000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		mmu-master = <&mfc>;
+	};
+
+	sysmmu-mfcR {
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
+		interrupts = <10 6
+				11 6
+				5 2
+				3 6
+				5 0
+				5 4>;
+	};
+
+	sysmmu-is1 {
+		mmuname = "odc", "dis0", "dis1", "3dnr";
+		reg = < 0x132C0000 0x1000
+			0x132D0000 0x1000
+			0x132E0000 0x1000
+			0x132F0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <11 0
+				10 4
+				9 4
+				5 6>;
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


