Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2DVTyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 15:54:23 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12393 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2DVTyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 15:54:21 -0400
Date: Sun, 22 Apr 2012 21:54:19 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: JJ Ding <dgdunix@gmail.com>, Axel Lin <axel.lin@gmail.com>,
        Vojtech Pavlik <vojtech@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: atkbd - Fix language in a printed message
Message-ID: <alpine.LNX.2.00.1204222144550.27455@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe that "trying to access hardware" is more correct english
than "trying acess hardware".

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/input/keyboard/atkbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index e05a2e7..add5ffd 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -433,7 +433,7 @@ static irqreturn_t atkbd_interrupt(struct serio *serio, unsigned char data,
 		if (printk_ratelimit())
 			dev_warn(&serio->dev,
 				 "Spurious %s on %s. "
-				 "Some program might be trying access hardware directly.\n",
+				 "Some program might be trying to access hardware directly.\n",
 				 data == ATKBD_RET_ACK ? "ACK" : "NAK", serio->phys);
 		goto out;
 	case ATKBD_RET_ERR:
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

