Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab0E1MP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 08:15:28 -0400
Received: from sdcmail01.amcc.com ([198.137.200.72]:35694 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab0E1MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 08:15:26 -0400
X-IronPort-AV: E=Sophos;i="4.53,318,1272870000"; 
   d="scan'208";a="26073253"
Date: Fri, 28 May 2010 17:45:20 +0530
From: Rupjyoti Sarmah <rsarmah@amcc.com>
Message-Id: <201005281215.o4SCFKNi025548@amcc.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]Device tree update for the 460ex DWC SATA
Cc: rsarmah@appliedmicro.com, sr@denx.de, linuxppc-dev@ozlabs.org
X-OriginalArrivalTime: 28 May 2010 12:15:25.0371 (UTC) FILETIME=[73EC88B0:01CAFE5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree update for the Applied micro processor 460ex on-chip SATA.

Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com>
---
 arch/powerpc/boot/dts/canyonlands.dts |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
index cd56bb5..d3b2c99 100644
--- a/arch/powerpc/boot/dts/canyonlands.dts
+++ b/arch/powerpc/boot/dts/canyonlands.dts
@@ -163,6 +163,14 @@
 			interrupts = <0x1e 4>;
 		};
 
+		SATA0: sata@bffd1000 {
+                        compatible = "amcc,sata-460ex";
+			reg = <4 0xbffd1000 0x800 4 0xbffd0800 0x400>;
+                        interrupt-parent = <&UIC3>;
+                        interrupts = <0x0 0x4       /* SATA */
+                                      0x5 0x4>;     /* AHBDMA */
+                };
+
 		POB0: opb {
 			compatible = "ibm,opb-460ex", "ibm,opb";
 			#address-cells = <1>;
-- 
1.5.6.3

