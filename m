Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1LLD3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:29:11 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:49282
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955Ab1LLD2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:44 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 09/11] serial: bfin-uart: remove unused field for hardware flow control.
Date: Mon, 12 Dec 2011 11:28:31 +0800
Message-ID: <1323660513-9620-9-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
References: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 arch/blackfin/include/asm/bfin_serial.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin_serial.h b/arch/blackfin/include/asm/bfin_serial.h
index ecacdf3..68bcc3d 100644
--- a/arch/blackfin/include/asm/bfin_serial.h
+++ b/arch/blackfin/include/asm/bfin_serial.h
@@ -51,9 +51,6 @@ struct bfin_serial_port {
 #elif ANOMALY_05000363
 	unsigned int anomaly_threshold;
 #endif
-#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	int scts;
-#endif
 #if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
 	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
 	int cts_pin;
-- 
1.7.0.4


