Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab3AIVMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:12:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:42912 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933676Ab3AIUjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 062/123] usb: musb: cppi_dma: export cppi_interrupt()
Date: Wed,  9 Jan 2013 12:35:01 -0800
Message-Id: <20130109201506.548811867@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 8b416b0b25d5d8ddb3a91c1d20e1373582c50405 upstream.

Now that DaVinci glue layer can be modular, we must export cppi_interrupt()
that it may call...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/cppi_dma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -1314,6 +1314,7 @@ irqreturn_t cppi_interrupt(int irq, void
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(cppi_interrupt);
 
 /* Instantiate a software object representing a DMA controller. */
 struct dma_controller *__devinit


