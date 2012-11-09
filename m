Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2KIV6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:58:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2KIV6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:58:48 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: tegra: harmony: Add ADT7641 temperature sensor
Date: Fri,  9 Nov 2012 22:58:43 +0100
Message-Id: <1352498323-31845-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:+TUDok5YV3zTXbEo0AyzFUUJgFxCjxqiNomZoGEuAAz
 wS0nwJ2eUPkSdGKh3U/eF8EwifOEtvRLTnf2gocTMrJL1SQeoN
 koqPYfApCcofQcCUTr97TIZhYIDLOnLqPMBfmh1caTbnNuBZsx
 pXTh6Oigbm+PjW42+q4KyBIPs+IN3RTgakAh+nrry2PhF/J6oH
 5Fk3D/t9iyITAA0R9PbI4NwcvNaaAKjXZwRc3w5vclhda09YjC
 AN2s2A69oSNbkC8uq87JotRpVsyq/CFbi1rE4ZzukoICawO5HU
 EoJ07zo69b/DfEqjmSu3fSu58ZrKrY2gh1hm1Qi3SP6JswvHDo
 eBcv255krJYZNxKFq+rtIQSMTYS/31ejKzXPoAxZiDWv3AWR8E
 11EEMZj5MuUmIm9/GoWn4af3HR91Zm5Q9Hctdk1GTsgSmcAq0M
 cBWF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Harmony board has an Analog Devices ADT7461 temperature sensor
connected to the DVC bus. It can be used to monitor the ambient (local)
and on-die (remote) temperatures.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- rename adt7641 node to temperature-sensor

 arch/arm/boot/dts/tegra20-harmony.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 74b8a47..a3f2f38 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -396,6 +396,11 @@
 				};
 			};
 		};
+
+		temperature-sensor@4c {
+			compatible = "adi,adt7461";
+			reg = <0x4c>;
+		};
 	};
 
 	pmc {
-- 
1.8.0

