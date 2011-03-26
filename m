Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab1CZBju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:39:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:32977 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932161Ab1CZBjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:39:48 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+bEqAN9GGb3rxbny8A+AuZ/uqhFGjpV74Nywcid0
	zEfRc0V8Jfl4bg
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 08/27] staging/et131x: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:17 +0100
Message-Id: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/brcm80211.

WRONG -> RIGHT
accomodate  -> accommodate
occured     -> occurred

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/et131x/et1310_rx.c  |    2 +-
 drivers/staging/et131x/et131x_isr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 339136f..fc6bd43 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -122,7 +122,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * number of entries in FBR1.
 	 *
 	 * FBR1 holds "large" frames, FBR0 holds "small" frames.  If FBR1
-	 * entries are huge in order to accomodate a "jumbo" frame, then it
+	 * entries are huge in order to accommodate a "jumbo" frame, then it
 	 * will have less entries.  Conversely, FBR1 will now be relied upon
 	 * to carry more "normal" frames, thus it's entry size also increases
 	 * and the number of entries goes up too (since it now carries
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index ce4d930..f716e40 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -466,7 +466,7 @@ void et131x_isr_handler(struct work_struct *work)
 		/* Handle SLV Timeout Interrupt */
 		if (status & ET_INTR_SLV_TIMEOUT) {
 			/*
-			 * This means a timeout has occured on a read or
+			 * This means a timeout has occurred on a read or
 			 * write request to one of the JAGCore registers. The
 			 * Global Resources block has terminated the request
 			 * and on a read request, returned a "fake" value.
-- 
1.7.3.4

