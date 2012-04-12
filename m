Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838Ab2DLSrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:47:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43812 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964829Ab2DLSpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:24 -0400
Date: Thu, 12 Apr 2012 20:45:30 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 11/13] ARM: Exynos4: dts: Specify address and size cells for
 i2c controllers
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Message-id: <1334256332-29867-12-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/boot/dts/exynos4210.dtsi |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index a1dd2ee..be3c57c 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -100,48 +100,64 @@
 	};
 
 	i2c@13860000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x13860000 0x100>;
 		interrupts = <0 58 0>;
 	};
 
 	i2c@13870000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x13870000 0x100>;
 		interrupts = <0 59 0>;
 	};
 
 	i2c@13880000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x13880000 0x100>;
 		interrupts = <0 60 0>;
 	};
 
 	i2c@13890000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x13890000 0x100>;
 		interrupts = <0 61 0>;
 	};
 
 	i2c@138A0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x138A0000 0x100>;
 		interrupts = <0 62 0>;
 	};
 
 	i2c@138B0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x138B0000 0x100>;
 		interrupts = <0 63 0>;
 	};
 
 	i2c@138C0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x138C0000 0x100>;
 		interrupts = <0 64 0>;
 	};
 
 	i2c@138D0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
 		compatible = "samsung,s3c2440-i2c";
 		reg = <0x138D0000 0x100>;
 		interrupts = <0 65 0>;
-- 
1.7.9.1

