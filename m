Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2KKMwn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:52:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2KKMus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:48 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] serial: bcm63xx_uart: remove unnecessary include
Date: Sun, 11 Nov 2012 13:50:42 +0100
Message-Id: <1352638249-29298-9-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm63xx_clk.h does not need to be included anymore as clk.h already
provides all required prototypes.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/tty/serial/bcm63xx_uart.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index c0b68b9..0187aff 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -30,7 +30,6 @@
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 
-#include <bcm63xx_clk.h>
 #include <bcm63xx_irq.h>
 #include <bcm63xx_regs.h>
 #include <bcm63xx_io.h>
-- 
1.7.2.5

