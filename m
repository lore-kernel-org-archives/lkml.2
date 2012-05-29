Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2E2JKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:10:19 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:38504 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751943Ab2E2JKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:10:17 -0400
From: Roland Stigge <stigge@antcom.de>
To: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux@arm.linux.org.uk
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/2] serial/of-serial: Add LPC3220 standard UART compatible string
Date: Tue, 29 May 2012 11:09:30 +0200
Message-Id: <1338282570-19799-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338282570-19799-1-git-send-email-stigge@antcom.de>
References: <1338282570-19799-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a "compatible" string for the new 8250 UART type PORT_LPC3220.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v 3.4

 Documentation/devicetree/bindings/tty/serial/of-serial.txt |    1 +
 drivers/tty/serial/of_serial.c                             |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.orig/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ linux-2.6/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -9,6 +9,7 @@ Required properties:
 	- "ns16750"
 	- "ns16850"
 	- "nvidia,tegra20-uart"
+	- "nxp,lpc3220-uart"
 	- "ibm,qpace-nwp-serial"
 	- "serial" if the port type is unknown.
 - reg : offset and length of the register set for the device.
--- linux-2.6.orig/drivers/tty/serial/of_serial.c
+++ linux-2.6/drivers/tty/serial/of_serial.c
@@ -182,6 +182,7 @@ static struct of_device_id __devinitdata
 	{ .compatible = "ns16750",  .data = (void *)PORT_16750, },
 	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
 	{ .compatible = "nvidia,tegra20-uart", .data = (void *)PORT_TEGRA, },
+	{ .compatible = "nxp,lpc3220-uart", .data = (void *)PORT_LPC3220, },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
 	{ .compatible = "ibm,qpace-nwp-serial",
 		.data = (void *)PORT_NWPSERIAL, },
