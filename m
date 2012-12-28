Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab2L1LnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:43:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35832 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2L1LnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:43:22 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-08-50dd85d8c486
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] arm: exynos5: Add HS-I2C device tree platform information
Date: Fri, 28 Dec 2012 17:10:51 +0530
Message-id: <1356694851-1345-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1356694851-1345-1-git-send-email-ch.naveen@samsung.com>
References: <1356694851-1345-1-git-send-email-ch.naveen@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkVvdG690Ag6ntOhaXd81hs5hxfh+T
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlfuq+zFZzir/g73aWBcQNPFyMnh4SAicSe5wvYIWwx
	iQv31rN1MXJxCAksZZSYM3ESG0zRrIb/UIlFjBKnF11mgnB6mCRe3+wFq2ITMJM4uGg12CgR
	AVWJz20gY7k4mAWuMUrMfbKLESQhLOAn0XhxO1gDC1DRx4k7gIo4OHgFXCRaNkqCmBICChJz
	JtmAVHAKuErM/nWcBcQWAqrYNWMdVKeAxLfJh1ggymUlNh1gBtkkIXCbTeLDuRWsEEdLShxc
	cYNlAqPwAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxiBoXj63zOpHYwrGywOMQpwMCrx
	8C7suRMgxJpYVlyZe4hRgoNZSYS3r/lugBBvSmJlVWpRfnxRaU5q8SFGH6BLJjJLiSbnA+Mk
	ryTe0NjE3NTY1NLIyMzUFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbGuhlrn3bvlZx6
	UHDXpKWzjCY/fvvEZUVH7qLI9FqtMIaHMqv/98/3O6yt5+nUc9dJ1e7DllMm8bt6fJUF36VV
	xRVvOdgsrbcvkiNSoiDRePGZlvmrOleuV49RWSf8zeTaQ/8d6w8fDU89dbX/zPa3wq/K3xuk
	nzA7lJY0Ze7pU1/U9729skJfVImlOCPRUIu5qDgRAB5gITRyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgO6N1rsBBvM3K1pc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmfOm+zlZwir/i
	73SXBsYNPF2MnBwSAiYSsxr+s0HYYhIX7q0Hsrk4hAQWMUqcXnSZCcLpYZJ4fbMXrIpNwEzi
	4KLV7CC2iICqxOe2BewgRcwC1xgl5j7ZxQiSEBbwk2i8uB2sgQWo6OPEHUBFHBy8Ai4SLRsl
	QUwJAQWJOZNsQCo4BVwlZv86zgJiCwFV7Jqxjm0CI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMGB/kxqB+PKBotDjAIcjEo8vAt77gQIsSaWFVfmHmKU4GBWEuHta74bIMSbklhZ
	lVqUH19UmpNafIjRB+imicxSosn5wCjMK4k3NDYxNzU2tTSxMDGzxCGsJM7b7JESICSQnliS
	mp2aWpBaBDOOiYNTqoHRgctt8lvVhGMHmO7UrQxUYX6z9z7Psb8+D3uZjeJlzVIuXfBbxPH9
	a13DU519V6sYLgorrvPLDb9gw3TlU5SpyzbP1OhAdePFjSty9i5+HPuwhUm8fN+5i2fj098b
	/Tvp++vX+Q9TeHNfy6ofWrg08QfT3FmtqaE6Siur3366MlEjxLz26PxmJZbijERDLeai4kQA
	x6p6aKECAAA=
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
index 942d576..b7fba59 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -108,6 +108,22 @@
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
 	dwmmc0@12200000 {
 		num-slots = <1>;
 		supports-highspeed;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 45799e8..a10c089 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -213,6 +213,38 @@
                 #size-cells = <0>;
 	};
 
+	hsi2c@12C50000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12C50000 0x1000>;
+		interrupts = <0 56 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	hsi2c@12D00000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12D00000 0x1000>;
+		interrupts = <0 57 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	hsi2c@12D50000 {
+		compatible = "samsung,exynos5-hsi2c";
+		reg = <0x12D50000 0x1000>;
+		interrupts = <0 58 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	hsi2c@12DE0000 {
+		compatible = "samsung,exynos5-hsi2c";
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

