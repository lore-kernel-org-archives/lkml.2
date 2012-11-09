Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab2KINIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:08:02 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2KINH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:07:59 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: tegra: tamonten: Add temperature sensor support
Date: Fri,  9 Nov 2012 14:07:54 +0100
Message-Id: <1352466474-27581-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:6thwZknxu+y0HytCyiIybCaZTnq3whglXQLxGA/uDX1
 1bfvr+7GWVEU67NaMRcsGxk1wmMQF5Pz+OdXupjoFSBMI3zIaV
 5dYiNKCW/cBWAjodW6WIm549A4NxR3cx0/R0JBym4qdkxBAher
 j0ONGOOUHKS0pQgTBwhDRYL7tNXRs7QC1/xv/4rvdFjCCUsQuL
 5q9zzmJLhp78abAPVtvImcaMowjYVKwL8uesJFradgT5EeyaES
 fmZzmhY5iA5tRd4h24VKV9uv5s/3vyzxHurc09LOGUGDO1KCSC
 nZ5WjKwJL5IhLqYG/ByBrOymDmdBOmqCpCcUvTU2roKyhNIyxG
 cKaM7VoO2p8MrVCHHVXigmFX7gcY/0gNZlPFYwRpcm1jQBBL8V
 mQoGu+gwsig4/i+bgny3eryByfaPUMF6dpWxvzx9EpsOJGS/YZ
 jTF/9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tamonten SOM has an ON Semiconductor NCT1008 connected to the DVC
bus which is used to measure the ambient (local) temperature as well as
the on-die (remote) temperature.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-tamonten.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index c3540e0..4f63b76 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -440,6 +440,11 @@
 				};
 			};
 		};
+
+		nct1008@4c {
+			compatible = "onnn,nct1008";
+			reg = <0x4c>;
+		};
 	};
 
 	pmc {
-- 
1.8.0

