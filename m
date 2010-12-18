Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab0LRFJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 00:09:13 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36915 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0LRFJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 00:09:09 -0500
Date: Fri, 17 Dec 2010 21:09:05 -0800
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] psmouse: fix up Synaptics comment
Message-ID: <20101217210905.334329bc@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Minor comment fixup for typos and grammar.  Noticed while adding a separate
workaround.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/input/mouse/synaptics.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 75fbf33..10e8612 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -832,8 +832,8 @@ int synaptics_init(struct psmouse *psmouse)
 
 	/*
 	 * Toshiba's KBC seems to have trouble handling data from
-	 * Synaptics as full rate, switch to lower rate which is roughly
-	 * thye same as rate of standard PS/2 mouse.
+	 * Synaptics at full rate.  Switch to a lower rate (roughly
+	 * the same rate as a standard PS/2 mouse).
 	 */
 	if (psmouse->rate >= 80 && impaired_toshiba_kbc) {
 		printk(KERN_INFO "synaptics: Toshiba %s detected, limiting rate to 40pps.\n",
-- 
1.7.2.3

