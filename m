Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1FIHam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:30:42 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:56172 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1FIHal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:30:41 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] pch_uart: add missing comment about OKI ML7223
Date: Thu,  9 Jun 2011 09:30:31 +0200
Message-Id: <1307604631-10168-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/tty/serial/pch_uart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4652109..e3e6d6b 100644
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

