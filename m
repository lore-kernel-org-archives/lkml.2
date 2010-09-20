Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0ITOcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 10:32:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab0ITOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 10:32:38 -0400
From: Thomas Weber <weber@corscience.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: [PATCH] Fix typo interrest[ing|ed] => interest[ing|ed]
Date: Mon, 20 Sep 2010 16:30:54 +0200
Message-Id: <1284993054-18645-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:pvvR0WMEiLWEe2Xd6fP48KR9fGp5v36eYc+xs/WiCI+
 qwpcr3QSkWzrnJ5AiccMOi1/l9xWLJJipGDcQZfWmgB20DX+YI
 4tAPH4td4ebuq0KzBnFGZIRm1lgJ9XSt6ABKmK4n5pVtdByksj
 ur/8mW5NqfGOwrAVlg3geBPYBX924lxE5LmwdblCOdZmdiIJMc
 XNTX/ytIf/UjhzVGSFBSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typos with interrest*.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/char/stallion.c |    4 ++--
 drivers/net/wan/hdlc.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index f2167f8..d7d7d4f 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -3180,7 +3180,7 @@ static void stl_cd1400flush(struct stlport *portp)
 
 /*
  *	Return the current state of data flow on this port. This is only
- *	really interresting when determining if data has fully completed
+ *	really interesting when determining if data has fully completed
  *	transmission or not... This is easy for the cd1400, it accurately
  *	maintains the busy port flag.
  */
@@ -4130,7 +4130,7 @@ static void stl_sc26198flush(struct stlport *portp)
 
 /*
  *	Return the current state of data flow on this port. This is only
- *	really interresting when determining if data has fully completed
+ *	really interesting when determining if data has fully completed
  *	transmission or not... The sc26198 interrupt scheme cannot
  *	determine when all data has actually drained, so we need to
  *	check the port statusy register to be sure.
diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index 9937bba..5d4bb61 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -109,7 +109,7 @@ static int hdlc_device_event(struct notifier_block *this, unsigned long event,
 		return NOTIFY_DONE; /* not an HDLC device */
 
 	if (event != NETDEV_CHANGE)
-		return NOTIFY_DONE; /* Only interrested in carrier changes */
+		return NOTIFY_DONE; /* Only interested in carrier changes */
 
 	on = netif_carrier_ok(dev);
 
-- 
1.7.2.3

