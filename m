Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2CZFnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:43:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52552 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab2CZFm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:42:29 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/7] pch_uart: change type to %d to %02x
Date: Mon, 26 Mar 2012 14:43:02 +0900
Message-Id: <1332740586-28496-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332740586-28496-1-git-send-email-tomoya.rohm@gmail.com>
References: <1332740586-28496-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%02x format is easier to understand better than %d.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/tty/serial/pch_uart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 6347f01..c025c4b 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1087,7 +1087,7 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 			ret = PCH_UART_HANDLED_MS_INT;
 			break;
 		default:	/* Never junp to this label */
-			dev_err(priv->port.dev, "%s:iid=%d (%lu)\n", __func__,
+			dev_err(priv->port.dev, "%s:iid=%02x (%lu)\n", __func__,
 				iid, jiffies);
 			ret = -1;
 			break;
-- 
1.7.7.6

