Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2A3WHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:07:55 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:47582 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849Ab2A3WHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:07:18 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Johan Hovold <jhovold@gmail.com>, Jir i Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linuxusb@kobil.de
Subject: [PATCH 12/16] kobil_sct: fix debug module parameter to be bool
Date: Mon, 30 Jan 2012 23:00:16 +0100
Message-Id: <1327960820-11867-13-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327961238;bee87d9e;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix debug variable from module parameter to be really bool to
fix 'warning: return from incompatible pointer type'.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/usb/serial/kobil_sct.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 5d3beee..a92a3ef 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -38,7 +38,7 @@
 #include <linux/ioctl.h>
 #include "kobil_sct.h"
 
-static int debug;
+static bool debug;
 
 /* Version Information */
 #define DRIVER_VERSION "21/05/2004"
-- 
1.7.7.3

