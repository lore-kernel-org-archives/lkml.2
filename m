Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab2ILREo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:04:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62613 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760Ab2ILRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:42 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] drivers/usb/host/sl811-hcd.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:22 +0200
Message-Id: <1347469402-27557-15-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/usb/host/sl811-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 91ce1c0..619b05f 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -156,7 +156,7 @@ static void setup_packet(
 	writeb(SL_SETUP /* | ep->epnum */, data_reg);
 	writeb(usb_pipedevice(urb->pipe), data_reg);
 
-	/* always OUT/data0 */ ;
+	/* always OUT/data0 */
 	sl811_write(sl811, bank + SL11H_HOSTCTLREG,
 			control | SL11H_HCTLMASK_OUT);
 	ep->length = 0;

