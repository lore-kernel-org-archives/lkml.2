Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab2JSKjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:39:05 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51027 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab2JSKjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:39:03 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Thierry Reding <thierry.reding@avionic-design.de>, arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/3] DOC: PWM: Adding binding document for via,vt8500-pwm
Date: Fri, 19 Oct 2012 23:38:55 +1300
Message-Id: <1350643135-13197-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a binding document describing the PWM controller found
on arch-vt8500 supported SoCs.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 .../devicetree/bindings/pwm/vt8500-pwm.txt         |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt

diff --git a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
new file mode 100644
index 0000000..e8ba133
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
@@ -0,0 +1,17 @@
+VIA/Wondermedia VT8500/WM8xxx series SoC PWM controller
+
+Required properties:
+- compatible: should be "via,vt8500-pwm"
+- reg: physical base address and length of the controller's registers
+- #pwm-cells: should be 2.  The first cell specifies the per-chip index
+  of the PWM to use and the second cell is the period in nanoseconds.
+- clocks: pHandle to the PWM source clock
+
+Example:
+
+pwm1: pwm@d8220000 {
+	#pwm-cells = <2>;
+	compatible = "via,vt8500-pwm";
+	reg = <0xd8220000 0x1000>;
+	clocks = <&clkpwm>;
+};
-- 
1.7.9.5

