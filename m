Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0HWTBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:01:41 -0400
Received: from mail.perches.com ([173.55.12.10]:1292 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0HWTBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:01:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2] drivers/serial/bfin_5xx.c: Fix logging messages continued with \
Date: Mon, 23 Aug 2010 12:01:36 -0700
Message-Id: <6028a858f4eb3f07cc5cdddebf5af64fb0e6204e.1282589920.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using continuation lines often introduces undesired whitespace.
Fix the misuses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/bfin_5xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a9eff2b..4e38f99 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -734,8 +734,8 @@ static int bfin_serial_startup(struct uart_port *port)
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
 			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
 			uart->cts_pin = -1;
-			pr_info("Unable to attach BlackFin UART CTS interrupt.\
-				 So, disable it.\n");
+			pr_info("Unable to attach BlackFin UART CTS interrupt. "
+				"So, disable it.\n");
 		}
 	}
 	if (uart->rts_pin >= 0) {
@@ -747,8 +747,8 @@ static int bfin_serial_startup(struct uart_port *port)
 	if (request_irq(uart->status_irq,
 		bfin_serial_mctrl_cts_int,
 		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
-		pr_info("Unable to attach BlackFin UART Modem \
-			Status interrupt.\n");
+		pr_info("Unable to attach BlackFin UART Modem "
+			"Status interrupt.\n");
 	}
 
 	/* CTS RTS PINs are negative assertive. */
-- 
1.7.2.19.g9a302

