Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab2BJPB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:01:28 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42860 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab2BJPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:01:27 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: Danny Kukawka <dkukawka@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jesper Juhl <jj@chaosbits.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mISDN/hfcsusb: remove unused variable hfcsusb_rev
Date: Fri, 10 Feb 2012 16:01:08 +0100
Message-Id: <1328886068-22646-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328886086;30fdf808;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused variable hfcsusb_rev (-Wunused-variable) and
copied Revision info to file comment block above to keep the info.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 0e1f4d5..43b4d29 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -27,6 +27,7 @@
  *   poll=<n>, default 128
  *     n : burst size of PH_DATA_IND at transparent rx data
  *
+ * Revision: 0.3.3 (socket), 2008-11-05
  */
 
 #include <linux/module.h>
@@ -36,8 +37,6 @@
 #include <linux/slab.h>
 #include "hfcsusb.h"
 
-static const char *hfcsusb_rev = "Revision: 0.3.3 (socket), 2008-11-05";
-
 static unsigned int debug;
 static int poll = DEFAULT_TRANSP_BURST_SZ;
 
-- 
1.7.7.3

