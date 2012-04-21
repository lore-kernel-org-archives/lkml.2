Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2DUSdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:33:38 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17526 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2DUSdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:33:08 -0400
Date: Sat, 21 Apr 2012 20:33:07 +0200 (CEST)
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
Subject: [PATCH 2/3] staging: olpc_dcon.c: Add missing level to a printk()
In-Reply-To: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204212030460.25551@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/olpc_dcon/olpc_dcon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 862dbb5..7fe6eb6 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -303,7 +303,7 @@ static void dcon_source_switch(struct work_struct *work)
 
 	switch (source) {
 	case DCON_SOURCE_CPU:
-		printk("dcon_source_switch to CPU\n");
+		printk(KERN_INFO "dcon_source_switch to CPU\n");
 		/* Enable the scanline interrupt bit */
 		if (dcon_write(dcon, DCON_REG_MODE,
 				dcon->disp_mode | MODE_SCAN_INT))
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

