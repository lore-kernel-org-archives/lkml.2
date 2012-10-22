Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2JVP6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:58:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48576 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2JVP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:58:08 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RESEND PATCH 2/2] Documentation: of-serial.txt - update for clocks phandle for clk
Date: Mon, 22 Oct 2012 11:58:02 -0400
Message-ID: <1350921482-22554-2-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350921482-22554-1-git-send-email-m-karicheri2@ti.com>
References: <1350921482-22554-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
index 0847fde..423b7ff 100644
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -14,7 +14,10 @@ Required properties:
 	- "serial" if the port type is unknown.
 - reg : offset and length of the register set for the device.
 - interrupts : should contain uart interrupt.
-- clock-frequency : the input clock frequency for the UART.
+- clock-frequency : the input clock frequency for the UART
+	 or
+  clocks phandle to refer to the clk used as per Documentation/devicetree
+  /bindings/clock/clock-bindings.txt
 
 Optional properties:
 - current-speed : the current active speed of the UART.
-- 
1.7.9.5

