Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0GINw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:52:28 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50524 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870Ab0GINw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:52:27 -0400
Date: Fri, 9 Jul 2010 15:52:25 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 01/11] Removing dead 68328_SERIAL_UART
Message-ID: <824fd4e71f2141a8eb60bf30a1e423bba0f534d1.1278682302.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

68328_SERIAL_UART doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/68328serial.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/68328serial.h b/drivers/serial/68328serial.h
index 58aa215..c6d5382 100644
--- a/drivers/serial/68328serial.h
+++ b/drivers/serial/68328serial.h
@@ -181,13 +181,8 @@ struct m68k_serial {
 /* 
  * Define the number of ports supported and their irqs.
  */
-#ifndef CONFIG_68328_SERIAL_UART2
-#define NR_PORTS 1
-#define UART_IRQ_DEFNS {UART_IRQ_NUM}
-#else
 #define NR_PORTS 2
 #define UART_IRQ_DEFNS {UART1_IRQ_NUM, UART2_IRQ_NUM}
-#endif
 
 #endif /* __KERNEL__ */
 #endif /* !(_MC683XX_SERIAL_H) */
-- 
1.7.0.4

