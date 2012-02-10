Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab2BJOsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:48:31 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:42847
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758089Ab2BJOsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:48:30 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: isdn@linux-pingi.de, netdev@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] isdn: Fix typo in callc.c and tei.c
Date: Fri, 10 Feb 2012 23:48:00 +0900
Message-Id: <1328885280-3195-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "ioclt" to "ioctl" in
drivers/isdn/hisax/callc.c

Correct spelling "asigned" to "assigned" in
drivers/isdn/hisax/tei.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/isdn/hisax/callc.c |    2 +-
 drivers/isdn/hisax/tei.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/callc.c b/drivers/isdn/hisax/callc.c
index c4897e1..9ae92b4 100644
--- a/drivers/isdn/hisax/callc.c
+++ b/drivers/isdn/hisax/callc.c
@@ -1693,7 +1693,7 @@ HiSax_command(isdn_ctrl * ic)
 				default:
 					if (csta->auxcmd)
 						return(csta->auxcmd(csta, ic));
-					printk(KERN_DEBUG "HiSax: invalid ioclt %d\n",
+					printk(KERN_DEBUG "HiSax: invalid ioctl %d\n",
 						(int) ic->arg);
 					return (-EINVAL);
 			}
diff --git a/drivers/isdn/hisax/tei.c b/drivers/isdn/hisax/tei.c
index 842f9c9..9b6db9c 100644
--- a/drivers/isdn/hisax/tei.c
+++ b/drivers/isdn/hisax/tei.c
@@ -130,7 +130,7 @@ tei_id_request(struct FsmInst *fi, int event, void *arg)
 
 	if (st->l2.tei != -1) {
 		st->ma.tei_m.printdebug(&st->ma.tei_m,
-			"assign request for already asigned tei %d",
+			"assign request for already assigned tei %d",
 			st->l2.tei);
 		return;
 	}
-- 
1.7.6.5

