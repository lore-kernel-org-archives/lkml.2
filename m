Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928Ab0HEW0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:26:14 -0400
Received: from kroah.org ([198.145.64.141]:37763 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934528Ab0HEWYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/67] serial: "altera_uart: simplify altera_uart_console_putc()" checkpatch fixes
Date: Thu,  5 Aug 2010 15:23:19 -0700
Message-Id: <1281047014-23429-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#32: FILE: drivers/serial/altera_uart.c:397:
+^I         ALTERA_UART_STATUS_TRDY_MSK))$

total: 1 errors, 0 warnings, 39 lines checked

./patches/altera_uart-simplify-altera_uart_console_putc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches


This fix got lost when someone merged "altera_uart: simplify
altera_uart_console_putc()".  Please don't lose fixes.  Please don't write
of mere patches which have trivial checkpatch errors.

Cc: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/altera_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index 0f11896..f8d8a00 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -394,7 +394,7 @@ int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp)
 static void altera_uart_console_putc(struct uart_port *port, const char c)
 {
 	while (!(readl(port->membase + ALTERA_UART_STATUS_REG) &
-	         ALTERA_UART_STATUS_TRDY_MSK))
+		 ALTERA_UART_STATUS_TRDY_MSK))
 		cpu_relax();
 
 	writel(c, port->membase + ALTERA_UART_TXDATA_REG);
-- 
1.7.2

