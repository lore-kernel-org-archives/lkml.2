Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab2EPHdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:33:35 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:10771
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759548Ab2EPHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:31:29 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: <sonic.zhang@analog.com>
To: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>
CC: <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 6/8] i2c:i2c-bfin-twi: include twi head file
Date: Wed, 16 May 2012 15:20:24 +0800
Message-ID: <1337152826-9850-6-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

TWI bit mask macros are moved to twi head file.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 594bbb1..d7e8fba 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -25,6 +25,7 @@
 #include <asm/blackfin.h>
 #include <asm/portmux.h>
 #include <asm/irq.h>
+#include <asm/bfin_twi.h>
 
 /* SMBus mode*/
 #define TWI_I2C_MODE_STANDARD		1
-- 
1.7.0.4


