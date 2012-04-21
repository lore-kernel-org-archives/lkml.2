Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2DUSdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:33:21 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17594 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2DUSdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:33:17 -0400
Date: Sat, 21 Apr 2012 20:33:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: David Woodhouse <dwmw2@infradead.org>,
        Andres Salomon <dilinger@queued.net>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/3] staging: olpc_dcon.c: Remove a few spaces between casts
 and variables
In-Reply-To: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204212031360.25551@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a trivial style cleanup.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 7fe6eb6..992275c 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -134,7 +134,7 @@ static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
 power_up:
 	if (is_powered_down) {
 		x = 1;
-		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		if (x) {
 			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power up: %d!\n",
 				x);
@@ -153,7 +153,7 @@ power_up:
 		printk(KERN_ERR "olpc-dcon:  unable to stabilize dcon's smbus, reasserting power and praying.\n");
 		BUG_ON(olpc_board_at_least(olpc_board(0xc2)));
 		x = 0;
-		olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		msleep(100);
 		is_powered_down = 1;
 		goto power_up;	/* argh, stupid hardware.. */
@@ -219,7 +219,7 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
 
 	if (sleep) {
 		x = 0;
-		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
+		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
 		if (x)
 			printk(KERN_WARNING "olpc-dcon:  unable to force dcon to power down: %d!\n",
 				x);
@@ -598,7 +598,7 @@ static int dcon_fb_notifier(struct notifier_block *self,
 	struct fb_event *evdata = data;
 	struct dcon_priv *dcon = container_of(self, struct dcon_priv,
 			fbevent_nb);
-	int *blank = (int *) evdata->data;
+	int *blank = (int *)evdata->data;
 	if (((event != FB_EVENT_BLANK) && (event != FB_EVENT_CONBLANK)) ||
 			dcon->ignore_fb_events)
 		return 0;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

