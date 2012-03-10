Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2CJVwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:52:13 -0500
Received: from static-212-123-84-234.clienti.tiscali.it ([212.123.84.234]:56339
	"EHLO mail.m31.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2CJVwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:52:12 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2012 16:52:11 EST
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH] usb: gadget: Kconfig: fix typo for 'different'
Date: Sat, 10 Mar 2012 22:44:19 +0100
Message-Id: <1331415859-23291-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/usb/gadget/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 7ecb68a..b5972e0 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -685,7 +685,7 @@ config USB_G_NCM
 	help
 	  This driver implements USB CDC NCM subclass standard. NCM is
 	  an advanced protocol for Ethernet encapsulation, allows grouping
-	  of several ethernet frames into one USB transfer and diffferent
+	  of several ethernet frames into one USB transfer and different
 	  alignment possibilities.
 
 	  Say "y" to link the driver statically, or "m" to build a
-- 
1.7.5.1

