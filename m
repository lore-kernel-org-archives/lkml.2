Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2KIM5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:57:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2KIM46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:56:58 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: harmony: Add ADT7641 temperature sensor
Date: Fri,  9 Nov 2012 13:56:55 +0100
Message-Id: <1352465815-26984-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:lNtJackob9PTZwkCWOCHOw2qWSS+B45UAgVHRuhn9xn
 uRuqH8Hxf7DFGLCyZy2+K0NH4vRqZGlee/20BQ8ql4q4XuxkqI
 3gNytSUD06qYj0cy/2RQcj5mjREKP0/k1BamepvAV6pjKJxtPL
 PyyM4EUnBhGQj1zlLRxgOIn7ePCmwPO57mg5aTNd0jOYJMm0Hg
 ApzagMQbt9UCOkFZQYELGZmMkH4CrNVVG3215FRe34Q5mGi1/G
 76vLdDLxiCQwzPpA8ndVCO1Q7mQ5B8KyzSdEpqlCGz9KjWxc3C
 FXtPz3ruuSrJLkuV2VCSpow02pIg4ZHa9sHRAnM7kOwY6biR93
 Qi3td/tPvOhaQmDG3fY0ZuzJ2cx2vhv6bjXJqSjazTLzmCm4lB
 WVm/ifPCFYCEUimhB4Wxn9pW04sYohSyoiFw3dhg44TWhva8w1
 O7c5K
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Harmony board has an Analog Devices ADT7461 temperature sensor
connected to the DVC bus. It can be used to monitor the ambient (local)
and on-die (remote) temperatures.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-harmony.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 3ab0f44..ed55d50 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -396,6 +396,11 @@
 				};
 			};
 		};
+
+		adt7461@4c {
+			compatible = "adi,adt7461";
+			reg = <0x4c>;
+		};
 	};
 
 	pmc {
-- 
1.8.0

