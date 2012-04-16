Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2DPJW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:22:59 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:57498 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2DPJV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:26 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Joachim Eastwood <manabian@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 06/12] ARM: at91: remove empty at91_init_serial function
Date: Mon, 16 Apr 2012 11:20:50 +0200
Message-Id: <926de6d8b90feee26717c01543243b8e07681303.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Eastwood <manabian@gmail.com>

The real function is long gone and the empty one will generate warnings
when configured without Atmel serial:
  arch/arm/mach-at91/at91rm9200_devices.c:1176: warning: 'struct at91_uart_config' declared inside parameter list
  arch/arm/mach-at91/at91rm9200_devices.c:1176: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200_devices.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 99ce5c9..05774e5 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -1173,7 +1173,6 @@ void __init at91_add_device_serial(void)
 		printk(KERN_INFO "AT91: No default serial console defined.\n");
 }
 #else
-void __init __deprecated at91_init_serial(struct at91_uart_config *config) {}
 void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins) {}
 void __init at91_set_serial_console(unsigned portnr) {}
 void __init at91_add_device_serial(void) {}
-- 
1.7.10

