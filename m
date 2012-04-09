Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2DIHVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:21:37 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44022 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754369Ab2DIHVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:21:34 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org, jwboyer@gmail.com, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Tanmay Inamdar <tinamdar@apm.com>
Subject: [V2 3/5] powerpc: dts: klondike: Add UART nodes
Date: Mon,  9 Apr 2012 12:50:50 +0530
Message-Id: <1333956052-25319-3-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
In-Reply-To: <1333956052-25319-2-git-send-email-tinamdar@apm.com>
References: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
 <1333956052-25319-2-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding UART nodes in Klondike device tree file.

Version 2:
Removed unnecessary 'virtual-reg' property from UART node.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
:100644 100644 4ff2852... b1e516e... M	arch/powerpc/boot/dts/klondike.dts
 arch/powerpc/boot/dts/klondike.dts |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/klondike.dts b/arch/powerpc/boot/dts/klondike.dts
index 4ff2852..b1e516e 100644
--- a/arch/powerpc/boot/dts/klondike.dts
+++ b/arch/powerpc/boot/dts/klondike.dts
@@ -222,6 +222,28 @@
 				#size-cells = <1>;
 				ranges;
 				clock-frequency = <0>;
+
+				UART0: serial@50001000 {
+				       device_type = "serial";
+				       compatible = "ns16550";
+				       reg = <0x50001000 0x00000100>;
+				       clock-frequency = <0>; /* Filled in by U-Boot */
+				       current-speed = <115200>;
+				       interrupt-parent = <&UIC0>;
+				       interrupts = <0x0 0x4>;
+				       reg-shift = <2>;
+				};
+
+				UART1: serial@50002000 {
+				       device_type = "serial";
+				       compatible = "ns16550";
+				       reg = <0x50002000 0x00000100>;
+				       clock-frequency = <0>; /* Filled in by U-Boot */
+				       current-speed = <115200>;
+				       interrupt-parent = <&UIC0>;
+				       interrupts = <0x1 0x4>;
+				       reg-shift = <2>;
+			       };
 			};
 		};
 	};
-- 
1.6.1.rc3

