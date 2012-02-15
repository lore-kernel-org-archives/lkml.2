Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2BORz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:55:57 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41711 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363Ab2BORzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:55:55 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dwc3: linux/module.h included twice
Date: Wed, 15 Feb 2012 18:55:51 +0100
Message-Id: <1329328551-4957-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329328555;df5162cc;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/usb/dwc3/core.c and drivers/usb/dwc3/dwc3-omap.c
included 'linux/module.h' twice, remove the duplicates.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/usb/dwc3/core.c      |    1 -
 drivers/usb/dwc3/dwc3-omap.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 7c9df63..eed4a5b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -51,7 +51,6 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
-#include <linux/module.h>
 
 #include "core.h"
 #include "gadget.h"
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 3274ac8..92cc7b8 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -46,7 +46,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
-#include <linux/module.h>
 
 #include "core.h"
 #include "io.h"
-- 
1.7.8.3

