Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2BYBXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:23:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38417 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab2BYBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:22:31 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: balbi@ti.com
Cc: dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 3/6] amd5536udc: Fix indentation.
Date: Sat, 25 Feb 2012 02:14:59 +0100
Message-Id: <1330132502-17057-4-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an unnecessary level of indentation.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index a57f5cd..3d627db 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -2408,9 +2408,9 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 				/* write fifo */
 				udc_txfifo_write(ep, &req->req);
 				len = req->req.length - req->req.actual;
-						if (len > ep->ep.maxpacket)
-							len = ep->ep.maxpacket;
-						req->req.actual += len;
+				if (len > ep->ep.maxpacket)
+					len = ep->ep.maxpacket;
+				req->req.actual += len;
 				if (req->req.actual == req->req.length
 					|| (len != ep->ep.maxpacket)) {
 					/* complete req */
-- 
1.7.9

