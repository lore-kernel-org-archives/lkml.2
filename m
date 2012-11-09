Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2KIWB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:01:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61856 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2KIWB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:01:26 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: ventana: Add NCT1008 temperature sensor
Date: Fri,  9 Nov 2012 23:01:21 +0100
Message-Id: <1352498481-32032-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:H6OVSLRWpWbA64Le4wrho8SP8XD6SWhazHCpUpb0KZk
 sZis/CMGygN4MOi8tOe7RRqvYHBGl6Wc1oYnMhpTg9P9FykUsp
 11MA2X5lMye9h+SQzfr6d+reM+OQQs50ohKEWeIh+7XpdH4Y+b
 dgKr3dBcPbN5E4OLFTvtW1PPnBdVvGi5tXizTW/c10i/WqyHzz
 HgG4gHPWe19VFYgcSJZQxMHg3TL0Lhnt0E0cFFvwwKHC661LFy
 9lnawGDr8xsUmedHB7vkWjLMD84JlMZ3OgGLL5DoKSoR9d5mz9
 L25/QTmVnd4Wvhh0dPcN71jddbNBUPt3TU9d0rA8Tam7WyIwxU
 92L1RzWjJHfYfQFi/ALLZtVngk0Z8C4znQn69Q9nqnj85pYeM5
 97MGsLOcqwvyW/qowLLSU+peBfpDofdV1AJsaLg17leHKE5Jqu
 4iyGm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Harmony board has an ON Semiconductors NCT1008 temperature sensor
connected to the DVC bus. It can be used to monitor the ambient (local)
and on-die (remote) temperatures.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 1dde0d3..adc4754 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -473,6 +473,11 @@
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

