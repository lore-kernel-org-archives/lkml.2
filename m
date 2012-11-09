Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2KIWAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:00:18 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab2KIWAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:00:14 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: tegra: tamonten: Add NCT1008 temperature sensor
Date: Fri,  9 Nov 2012 23:00:08 +0100
Message-Id: <1352498408-31955-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:daUeDP22NaVR4foO3CzsHseofKRYF/ovuj9JMjorKyr
 E81klgdZknCxCsFGv9U1i8QvQudRwCjONyrylMsyEY3BHOwgpz
 S00BQL5GyNCdLzwDKNso0/ueC9+A2vJ/hlsfk4Ynh/mC2oQDZ1
 lUPvt1xORrH71IcmUTwgcJLK5qHNL/utDhMlyz6kjAZe8OwwgZ
 bqdNDFj6Ctwk+NMnd5yxzR0rFm85bB2UXlUA8qjIk+r5fFNNMG
 PpnRc3ZJxZ4oI8a5nuLwAnlwqvJuKvlv3yeZ4Y+z/KJ8A2HkuG
 GKgG3NQ12YXg7FZVJnQy+mviXqVUwM8njYs9yV65Q/iG3AzsOc
 2++k1EFq41fC41i2YGlGLRj1xB81qnQPjpiVRzOun39bPzwYof
 bzIvdDvH/BsmRx4j02HZW1bvfClWLamX8VAbLx4VZYpvidUkDM
 e5udF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tamonten SOM has an ON Semiconductor NCT1008 connected to the DVC
bus which is used to measure the ambient (local) temperature as well as
the on-die (remote) temperature.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- rename nct1008 node to temperature-sensor

 arch/arm/boot/dts/tegra20-tamonten.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index c3540e0..95df80e 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -440,6 +440,11 @@
 				};
 			};
 		};
+
+		temperature-sensor@4c {
+			compatible = "onnn,nct1008";
+			reg = <0x4c>;
+		};
 	};
 
 	pmc {
-- 
1.8.0

