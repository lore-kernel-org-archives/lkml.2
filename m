Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2L1T1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:27:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55621 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932337Ab2L1TTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:39 -0500
Message-Id: <20121228190339.438295612@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 045/173] usb: musb: cppi_dma: export cppi_interrupt()
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 8b416b0b25d5d8ddb3a91c1d20e1373582c50405 upstream.

Now that DaVinci glue layer can be modular, we must export cppi_interrupt()
that it may call...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/musb/cppi_dma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -1313,6 +1313,7 @@ irqreturn_t cppi_interrupt(int irq, void
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(cppi_interrupt);
 
 /* Instantiate a software object representing a DMA controller. */
 struct dma_controller *__init


