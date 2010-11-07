Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0KGVK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:10:26 -0500
Received: from mail.perches.com ([173.55.12.10]:4548 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0KGVKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:10:24 -0500
Subject: [PATCH] drivers/serial/bfin_5xx.c: Fix line continuation defects
From: Joe Perches <joe@perches.com>
To: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Nov 2010 13:10:23 -0800
Message-ID: <1289164223.29216.316.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/bfin_5xx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a9eff2b..351cc03 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -734,8 +734,7 @@ static int bfin_serial_startup(struct uart_port *port)
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
 			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
 			uart->cts_pin = -1;
-			pr_info("Unable to attach BlackFin UART CTS interrupt.\
-				 So, disable it.\n");
+			pr_info("Unable to attach BlackFin UART CTS interrupt. So, disable it.\n");
 		}
 	}
 	if (uart->rts_pin >= 0) {
@@ -747,8 +746,7 @@ static int bfin_serial_startup(struct uart_port *port)
 	if (request_irq(uart->status_irq,
 		bfin_serial_mctrl_cts_int,
 		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
-		pr_info("Unable to attach BlackFin UART Modem \
-			Status interrupt.\n");
+		pr_info("Unable to attach BlackFin UART Modem Status interrupt.\n");
 	}
 
 	/* CTS RTS PINs are negative assertive. */


