Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1BNWzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:55:06 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12148 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1BNWzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:55:03 -0500
Date: Mon, 14 Feb 2011 23:54:00 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Sascha Hauer <s.hauer@pengutronix.de>,
        dmitry pervushin <dimka@embeddedalley.com>, trivial@kernel.org
Subject: [PATCH][trivial] Freescale STMP37XX/STMP378X Application UART driver:
 remove duplicate linux/device.h include
Message-ID: <alpine.LNX.2.00.1102142351100.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not include linux/device.h twice in drivers/tty/serial/mxs-auart.c .
Once is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mxs-auart.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 6d01ac9..7e02c9c 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/console.h>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

