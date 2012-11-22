Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2KVS2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:28:42 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52545
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab2KVS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:28:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <kernel@pengutronix.de>
CC: <javier.martin@vista-silicon.com>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v4 2/3] ARM: mx27: Align IIM registers with MX27 Reference Manual
Date: Thu, 22 Nov 2012 14:12:48 -0200
Message-ID: <1353600769-28693-2-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353600769-28693-1-git-send-email-fabio.estevam@freescale.com>
References: <1353600769-28693-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align IIM registers with the MX27 Reference Manual.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v3:
- No changes
Changes since v2:
- No changes. Newly introduced on this series
 arch/arm/mach-imx/iim.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-imx/iim.h b/arch/arm/mach-imx/iim.h
index 315bffa..d1d6f35 100644
--- a/arch/arm/mach-imx/iim.h
+++ b/arch/arm/mach-imx/iim.h
@@ -36,11 +36,11 @@
 #define MXC_IIMSCS1             0x0030
 #define MXC_IIMSCS2             0x0034
 #define MXC_IIMSCS3             0x0038
-#define MXC_IIMFBAC0            0x0800
-#define MXC_IIMJAC              0x0804
-#define MXC_IIMHWV1             0x0808
-#define MXC_IIMHWV2             0x080C
-#define MXC_IIMHAB0             0x0810
+#define MXC_IIMFBAC0            0x003C
+#define MXC_IIMWORD1_BANK0	0x0804
+#define MXC_IIMWORD2_BANK0	0x0808
+#define MXC_IIMWORD3_BANK0	0x080C
+#define MXC_IIMWORD4_BANK0	0x0810
 #define MXC_IIMHAB1             0x0814
 /* Definitions for i.MX27 TO2 */
 #define MXC_IIMMAC              0x0814
-- 
1.7.9.5


