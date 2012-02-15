Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2BOR4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:56:14 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41730 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193Ab2BOR4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:56:11 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] at91_udc: linux/prefetch.h included twice
Date: Wed, 15 Feb 2012 18:56:07 +0100
Message-Id: <1329328567-5012-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329328571;28a28797;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/gadget/at91_udc.c included 'linux/prefetch.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/usb/gadget/at91_udc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 143a725..d8dee22 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -29,7 +29,6 @@
 #include <linux/clk.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
-#include <linux/prefetch.h>
 
 #include <asm/byteorder.h>
 #include <mach/hardware.h>
-- 
1.7.8.3

