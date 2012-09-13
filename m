Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab2IMSFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:05:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38274 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab2IMSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:05:08 -0400
From: Henrique Camargo <henrique@henriquecamargo.com>
To: nsekhar@ti.com, khilman@ti.com, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, nicolas.pitre@linaro.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Henrique Camargo <henrique@henriquecamargo.com>
Subject: [PATCH] davinci: fix the uart number in the comment
Date: Thu, 13 Sep 2012 15:04:36 -0300
Message-Id: <1347559476-25363-1-git-send-email-henrique@henriquecamargo.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit 0 of the field is uart0 and the bit 1 is uart1 and so on.

Signed-off-by: Henrique Camargo <henrique@henriquecamargo.com>
---
 arch/arm/mach-davinci/include/mach/serial.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/include/mach/serial.h b/arch/arm/mach-davinci/include/mach/serial.h
index 46b3cd1..86a01fa 100644
--- a/arch/arm/mach-davinci/include/mach/serial.h
+++ b/arch/arm/mach-davinci/include/mach/serial.h
@@ -38,7 +38,7 @@
 
 #ifndef __ASSEMBLY__
 struct davinci_uart_config {
-	/* Bit field of UARTs present; bit 0 --> UART1 */
+	/* Bit field of UARTs present; bit 0 --> UART0 */
 	unsigned int enabled_uarts;
 };
 
-- 
1.7.9.5

