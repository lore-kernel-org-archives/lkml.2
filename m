Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1GDNfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:35:55 -0400
Received: from 61-96-236-77.server-home.net ([77.236.96.61]:49173 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab1GDNfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:35:54 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH resend] pch_uart: add missing comment about OKI ML7223
Date: Mon,  4 Jul 2011 15:35:51 +0200
Message-Id: <1309786551-5879-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/tty/serial/pch_uart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index d3ba85b..91da2a9 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -44,6 +44,7 @@ enum {
 /* Set the max number of UART port
  * Intel EG20T PCH: 4 port
  * OKI SEMICONDUCTOR ML7213 IOH: 3 port
+ * OKI SEMICONDUCTOR ML7223 IOH: 2 port
 */
 #define PCH_UART_NR	4
 
-- 
1.7.3.4

