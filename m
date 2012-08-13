Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2HMKEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:04:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53217 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2HMKEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:04:15 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Sourav Poddar <sourav.poddar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 4/4] arm/dts: omap5-evm: Add bmp085 sensor support
Date: Mon, 13 Aug 2012 15:35:13 +0530
Message-ID: <1344852313-30484-5-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
References: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bmp085 pressure sensor data in omap5 evm dts file.

Tested on omap5430 evm with 3.5 custom kernel.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 arch/arm/boot/dts/omap5-evm.dts |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
index c2ea189..18e499c 100644
--- a/arch/arm/boot/dts/omap5-evm.dts
+++ b/arch/arm/boot/dts/omap5-evm.dts
@@ -39,3 +39,12 @@
 		reg = <0x48>;
 	};
 };
+
+&i2c2 {
+	clock-frequency = <400000>;
+
+	bmp085@77 {
+		compatible = "bosch,bmp085";
+		reg = <0x77>;
+	};
+};
-- 
1.7.1

