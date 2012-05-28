Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2E1J7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:59:25 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:50669 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938Ab2E1J7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:59:23 -0400
From: Roland Stigge <stigge@antcom.de>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] serial/of-serial: Add 16654 chip to compatible string list
Date: Mon, 28 May 2012 11:58:54 +0200
Message-Id: <1338199134-23885-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The (ST)16654 chip was missing in the list of supported chips in of-serial.
This patch adds the string "st16654" to it, and to the documentation.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.4

 Documentation/devicetree/bindings/tty/serial/of-serial.txt |    1 +
 drivers/tty/serial/of_serial.c                             |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.orig/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ linux-2.6/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -6,6 +6,7 @@ Required properties:
 	- "ns16450"
 	- "ns16550a"
 	- "ns16550"
+	- "st16654"
 	- "ns16750"
 	- "ns16850"
 	- "nvidia,tegra20-uart"
--- linux-2.6.orig/drivers/tty/serial/of_serial.c
+++ linux-2.6/drivers/tty/serial/of_serial.c
@@ -179,6 +179,7 @@ static struct of_device_id __devinitdata
 	{ .compatible = "ns16450",  .data = (void *)PORT_16450, },
 	{ .compatible = "ns16550a", .data = (void *)PORT_16550A, },
 	{ .compatible = "ns16550",  .data = (void *)PORT_16550, },
+	{ .compatible = "st16654",  .data = (void *)PORT_16654, },
 	{ .compatible = "ns16750",  .data = (void *)PORT_16750, },
 	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
 	{ .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
