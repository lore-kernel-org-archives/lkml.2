Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0J3VNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:13:34 -0400
Received: from mail.perches.com ([173.55.12.10]:3744 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab0J3VJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:39 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/39] drivers/usb/musb: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:39 -0700
Message-Id: <a2c75704fe694635912f079c6adab850d3e72559.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
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
1.7.3.1.g432b3.dirty

