Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab1FKCnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 22:43:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758510Ab1FKCm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 22:42:58 -0400
Subject: [PATCH] tty/serial: Add devicetree support for nVidia Tegra serial
 ports
To: Greg Kroah-Hartman <gregkh@suse.de>, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 10 Jun 2011 20:42:56 -0600
Message-ID: <20110611024117.12058.46473.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables the tegra serial port to be probed from device tree data.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Greg, if it's okay by you, I'll queue this one for v3.1 via the
devicetree/next tree.

g.

 drivers/tty/serial/of_serial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index c911b24..4675243 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -171,6 +171,7 @@ static struct of_device_id __devinitdata of_platform_serial_table[] = {
 	{ .compatible = "ns16550",  .data = (void *)PORT_16550, },
 	{ .compatible = "ns16750",  .data = (void *)PORT_16750, },
 	{ .compatible = "ns16850",  .data = (void *)PORT_16850, },
+	{ .compatible = "nvidia,tegra250-uart", .data = (void *)PORT_TEGRA, },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
 	{ .compatible = "ibm,qpace-nwp-serial",
 		.data = (void *)PORT_NWPSERIAL, },

