Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2DQSvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:51:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39702 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2DQSvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:51:05 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/2] ARM: dt: tegra: seaboard: add eeprom nodes to the I2C bus mux
Date: Tue, 17 Apr 2012 12:50:55 -0600
Message-Id: <1334688655-8509-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334688655-8509-1-git-send-email-swarren@wwwdotorg.org>
References: <1334688655-8509-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

I don't intend this patch to be applied; it's just here as a more complete
example of the bus mux binding. Putting an EEPROM on the DDC bus might make
sense for the EDID EEPROM, but I'm not actually sure what's responding to
that I2C address on the PTA bus right now!

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra-seaboard.dts |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index e1025e2..202cb46 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -309,11 +309,21 @@
 		i2c-bus-ddc {
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			eeprom {
+				compatible = "eeprom";
+				reg = <0x50>;
+			};
 		};
 
 		i2c-bus-pta {
 			#address-cells = <1>;
 			#size-cells = <0>;
+
+			eeprom {
+				compatible = "eeprom";
+				reg = <0x50>;
+			};
 		};
 	};
 
-- 
1.7.0.4

