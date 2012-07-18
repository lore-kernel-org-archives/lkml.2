Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2GRMHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:07:48 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:35835 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754177Ab2GRMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:07:31 -0400
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 4/4] ARM: LPC32xx: Add PWM to base dts file
Date: Wed, 18 Jul 2012 14:06:51 +0200
Message-Id: <1342613211-13190-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342613211-13190-1-git-send-email-stigge@antcom.de>
References: <1342613211-13190-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/boot/dts/lpc32xx.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -278,6 +278,17 @@
 				status = "disabled";
 			};
 
+			pwm1: pwm@0x4005C000 {
+				compatible = "nxp,lpc3220-pwm";
+				reg = <0x4005C000 0x4>;
+				status = "disabled";
+			};
+
+			pwm2: pwm@0x4005C004 {
+				compatible = "nxp,lpc3220-pwm";
+				reg = <0x4005C004 0x4>;
+				status = "disabled";
+			};
 		};
 	};
 };
