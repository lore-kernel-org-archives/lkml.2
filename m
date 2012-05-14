Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2ENQPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:15:46 -0400
Received: from faui45.informatik.uni-erlangen.de ([131.188.34.45]:34424 "EHLO
	faui45.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756568Ab2ENQPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:15:42 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 12:15:41 EDT
From: Reinhard Tartler <tartler@cs.fau.de>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@lists.cs.fau.de, Reinhard Tartler <tartler@cs.fau.de>
Subject: [PATCH] usb: musb: cppi: add missing include to fix compilation
Date: Mon, 14 May 2012 18:05:20 +0200
Message-Id: <1337011520-15286-1-git-send-email-tartler@cs.fau.de>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes compilation as module.

Signed-off-by: Reinhard Tartler <tartler@cs.fau.de>
---
 drivers/usb/musb/cppi_dma.c |    1 +
 1 file changed, 1 insertion(+)

This patch was found by tools developed in the VAMOS project:
http://www4.cs.fau.de/Research/VAMOS/

diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index 318fb4e..b25451f 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -6,6 +6,7 @@
  * The TUSB6020, using VLYNQ, has CPPI that looks much like DaVinci.
  */
 
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-- 
1.7.9.5

