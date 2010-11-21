Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0KUXqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:46:46 -0500
Received: from smtp.duncanthrax.net ([89.31.1.170]:38130 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab0KUXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:46:46 -0500
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Nov 2010 18:46:45 EST
From: Sven Schnelle <svens@stackframe.org>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, Sven Schnelle <svens@stackframe.org>
Subject: [PATCH 2/2] [AVR32] Fix typo in atmel_usba_udc.c
Date: Mon, 22 Nov 2010 00:28:07 +0100
Message-Id: <1290382087-3849-3-git-send-email-svens@stackframe.org>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290382087-3849-1-git-send-email-svens@stackframe.org>
References: <1290382087-3849-1-git-send-email-svens@stackframe.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be 'udc' not 'ubc' in usba_udc_probe()

Signed-off-by: Sven Schnelle <svens@stackframe.org>
---
 drivers/usb/gadget/atmel_usba_udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index b5e20e8..717ff65 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2017,7 +2017,7 @@ static int __init usba_udc_probe(struct platform_device *pdev)
 			}
 		} else {
 			/* gpio_request fail so use -EINVAL for gpio_is_valid */
-			ubc->vbus_pin = -EINVAL;
+			udc->vbus_pin = -EINVAL;
 		}
 	}
 
-- 
1.7.2.3

