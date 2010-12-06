Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0LFWJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:09:10 -0500
Received: from mail.perches.com ([173.55.12.10]:2333 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/29] drivers/usb/musb: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:04 -0800
Message-Id: <a72b1a7ebb30db4e9cb2758573e616689d17e119.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/musb/musb_host.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 4d5bcb4..bcabdb3 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -120,8 +120,8 @@ static void musb_h_tx_flush_fifo(struct musb_hw_ep *ep)
 		musb_writew(epio, MUSB_TXCSR, csr);
 		csr = musb_readw(epio, MUSB_TXCSR);
 		if (WARN(retries-- < 1,
-				"Could not flush host TX%d fifo: csr: %04x\n",
-				ep->epnum, csr))
+			 "Could not flush host TX%d fifo: csr: %04x\n",
+			 ep->epnum, csr))
 			return;
 		mdelay(1);
 	}
@@ -144,7 +144,7 @@ static void musb_h_ep0_flush_fifo(struct musb_hw_ep *ep)
 	} while (--retries);
 
 	WARN(!retries, "Could not flush host TX%d fifo: csr: %04x\n",
-			ep->epnum, csr);
+	     ep->epnum, csr);
 
 	/* and reset for the next transfer */
 	musb_writew(epio, MUSB_TXCSR, 0);
-- 
1.7.3.2.245.g03276.dirty

