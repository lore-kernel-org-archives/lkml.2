Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2BCOCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:02:38 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:34991
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754216Ab2BCOCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:02:37 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] frontends: Fix typo in tda1004x.c
Date: Fri,  3 Feb 2012 22:56:59 +0900
Message-Id: <1328277419-2255-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "alocate" to "allocate" in
drivers/media/dvb/frontends/tda1004x.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/dvb/frontends/tda1004x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index ae6f22a..35d72b4 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -1272,7 +1272,7 @@ struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct tda1004x_state), GFP_KERNEL);
 	if (!state) {
-		printk(KERN_ERR "Can't alocate memory for tda10045 state\n");
+		printk(KERN_ERR "Can't allocate memory for tda10045 state\n");
 		return NULL;
 	}
 
@@ -1342,7 +1342,7 @@ struct dvb_frontend* tda10046_attach(const struct tda1004x_config* config,
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct tda1004x_state), GFP_KERNEL);
 	if (!state) {
-		printk(KERN_ERR "Can't alocate memory for tda10046 state\n");
+		printk(KERN_ERR "Can't allocate memory for tda10046 state\n");
 		return NULL;
 	}
 
-- 
1.7.6.5

