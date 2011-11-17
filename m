Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1KQF6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:58:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1KQF6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:58:06 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/6] pch_uart: change type to %d to %02x
Date: Thu, 17 Nov 2011 14:57:29 +0900
Message-Id: <1321509453-12008-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321509453-12008-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 797fad2..013e16a 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -993,7 +993,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 			ret = PCH_UART_HANDLED_MS_INT;
 			break;
 		default:	/* Never junp to this label */
-			dev_err(priv->port.dev, "%s:iid=%d (%lu)\n", __func__,
+			dev_err(priv->port.dev, "%s:iid=%02x (%lu)\n", __func__,
 				iid, jiffies);
 			ret = -1;
 			break;
-- 
1.7.4.4

