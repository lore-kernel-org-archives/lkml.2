Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2DQGq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:46:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4856 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DQGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:46:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 16 Apr 2012 23:46:36 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rdunlap@xenotime.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        cbouatmailru@gmail.com, olof@lixom.net, linus.walleij@linaro.org,
        lars@metafoo.de, bfreed@chromium.org, grundler@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/3] ARM: dt: tegra_ventana: als and proximity sensor isl29018 support
Date: Tue, 17 Apr 2012 12:15:55 +0530
Message-Id: <1334645155-13799-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com>
References: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device info for ALS and proximity sensor isl29018.
This device is connected on i2c0 bus.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra-ventana.dts |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-ventana.dts b/arch/arm/boot/dts/tegra-ventana.dts
index 71eb2e5..dd474e1 100644
--- a/arch/arm/boot/dts/tegra-ventana.dts
+++ b/arch/arm/boot/dts/tegra-ventana.dts
@@ -256,6 +256,12 @@
 			micdet-delay = <100>;
 			gpio-cfg = < 0xffffffff 0xffffffff 0 0xffffffff 0xffffffff >;
 		};
+
+		/* ALS and proximity sensor */
+		isl29018: isl29018@44 {
+			compatible = "isl,isl29018";
+			reg = <0x44>;
+		};
 	};
 
 	i2c@7000c400 {
-- 
1.7.1.1

