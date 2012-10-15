Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2JOMsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:48:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37089 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2JOMsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:48:14 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [PATCH RESEND] usb: gadget: lpc32xx_udc: Disable setup request error
Date: Mon, 15 Oct 2012 09:47:36 -0300
Message-Id: <1350305256-27295-2-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1350305256-27295-1-git-send-email-aletes.xgr@gmail.com>
References: <1350305256-27295-1-git-send-email-aletes.xgr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is an debugging message. It's useful for finding protocol
details but it's not necessarily an error.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/gadget/lpc32xx_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index 21a9861..d1cf1f4 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -2399,7 +2399,7 @@ static void udc_handle_ep0_setup(struct lpc32xx_udc *udc)
 
 		if (i < 0) {
 			/* setup processing failed, force stall */
-			dev_err(udc->dev,
+			dev_dbg(udc->dev,
 				"req %02x.%02x protocol STALL; stat %d\n",
 				reqtype, req, i);
 			udc->ep0state = WAIT_FOR_SETUP;
-- 
1.7.10

