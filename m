Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab2BYBWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:22:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46559 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2BYBWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:22:30 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: balbi@ti.com
Cc: dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 2/6] amd5536udc: Fix coding style issues.
Date: Sat, 25 Feb 2012 02:14:58 +0100
Message-Id: <1330132502-17057-3-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary whitespaces.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 8d19053..a57f5cd 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -2114,7 +2114,7 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
 	if (use_dma) {
 		/* BNA event ? */
 		if (tmp & AMD_BIT(UDC_EPSTS_BNA)) {
-			DBG(dev, "BNA ep%dout occurred - DESPTR = %x \n",
+			DBG(dev, "BNA ep%dout occurred - DESPTR = %x\n",
 					ep->num, readl(&ep->regs->desptr));
 			/* clear BNA */
 			writel(tmp | AMD_BIT(UDC_EPSTS_BNA), &ep->regs->sts);
@@ -2329,7 +2329,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 		/* BNA ? */
 		if (epsts & AMD_BIT(UDC_EPSTS_BNA)) {
 			dev_err(&dev->pdev->dev,
-				"BNA ep%din occurred - DESPTR = %08lx \n",
+				"BNA ep%din occurred - DESPTR = %08lx\n",
 				ep->num,
 				(unsigned long) readl(&ep->regs->desptr));
 
@@ -2342,7 +2342,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 	/* HE event ? */
 	if (epsts & AMD_BIT(UDC_EPSTS_HE)) {
 		dev_err(&dev->pdev->dev,
-			"HE ep%dn occurred - DESPTR = %08lx \n",
+			"HE ep%dn occurred - DESPTR = %08lx\n",
 			ep->num, (unsigned long) readl(&ep->regs->desptr));
 
 		/* clear HE */
@@ -2702,7 +2702,7 @@ static irqreturn_t udc_control_in_isr(struct udc *dev)
 	tmp = readl(&dev->ep[UDC_EP0IN_IX].regs->sts);
 	/* DMA completion */
 	if (tmp & AMD_BIT(UDC_EPSTS_TDC)) {
-		VDBG(dev, "isr: TDC clear \n");
+		VDBG(dev, "isr: TDC clear\n");
 		ret_val = IRQ_HANDLED;
 
 		/* clear TDC bit */
-- 
1.7.9

