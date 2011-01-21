Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1AUBcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 20:32:55 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37482 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab1AUBcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 20:32:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rAzylRat9UbaoBMmJ9VzrTMkwnChmVJFyzarj2R666D2At6+0R8YdMT5meXukCyqfB
         lL6nUMlPxP4B9Ps9RTxR8/mgZt0zM8E88rIO1qwcAzXcqk96azypdU3Xb4Cc0bSSl81b
         pBe3gj2Cev8GGeBXTWH7uRlRNsyfa1yCl1SIo=
From: ahern.michael.t@gmail.com
To: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michael Ahern <ahern.michael.t@gmail.com>
Subject: [PATCH 2/2] Coding style in serial2002
Date: Fri, 21 Jan 2011 12:32:18 +1100
Message-Id: <1295573538-18973-2-git-send-email-ahern.michael.t@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1295573538-18973-1-git-send-email-ahern.michael.t@gmail.com>
References: <1295573538-18973-1-git-send-email-ahern.michael.t@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ahern <ahern.michael.t@gmail.com>

This patch removes incorrect mutli-line comment

Signed-off-by: Michael Ahern <ahern.michael.t@gmail.com>
---
 drivers/staging/comedi/drivers/serial2002.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index eee14dd..dfe257c 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -247,11 +247,6 @@ static void tty_setspeed(struct file *f, int speed)
 
 		tty_ioctl(f, TCGETS, (unsigned long)&settings);
 
-		/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
-		 * better
-		 * pr_info("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
-		 */
-
 		settings.c_iflag = 0;
 		settings.c_oflag = 0;
 		settings.c_lflag = 0;
@@ -285,10 +280,6 @@ static void tty_setspeed(struct file *f, int speed)
 			break;
 		}
 		tty_ioctl(f, TCSETS, (unsigned long)&settings);
-/* printk("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
- * better
- * pr_info("Speed: %d\n", settings.c_cflag & (CBAUD | CBAUDEX));
- */
 	}
 	{
 		/*  Set low latency */
-- 
1.7.0.4

