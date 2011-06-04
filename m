Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1FDMKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 08:10:04 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50663 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab1FDMKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 08:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=myWyDSuH+27TmVH+hLxoBvZ+hESI/gVI25E2uOvCLT2HyJYBYD5tPksPcfr4L9J6Df
         zYyhGkts/jRrUjLgTZLC2UAfQe0DJHL3xsk1+m/IeatGmjONauFmKn21Q1kBj/y6eOC2
         +bnSLYuYObdftLy5M0dxXLk91yHFE0bHDHfZs=
From: Aviv Ben-Yosef <aviv.by@gmail.com>
To: Eng.Linux@digi.com, gregkh@suse.de, lucas.demarchi@profusion.mobi
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Aviv Ben-Yosef <aviv.by@gmail.com>
Subject: [PATCH 1/1] Staging: tty: epca: fixing return code-style issue
Date: Sat,  4 Jun 2011 05:09:33 -0700
Message-Id: <1307189373-28487-1-git-send-email-aviv.by@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding-style issue, ``return'' with parens.

Signed-off-by: Aviv Ben-Yosef <aviv.by@gmail.com>
---
 drivers/staging/tty/epca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tty/epca.c b/drivers/staging/tty/epca.c
index 7f1369e..2a4ba10 100644
--- a/drivers/staging/tty/epca.c
+++ b/drivers/staging/tty/epca.c
@@ -792,7 +792,7 @@ static int pc_open(struct tty_struct *tty, struct file *filp)
 	}
 	if (boardnum >= num_cards || boards[boardnum].status == DISABLED)  {
 		tty->driver_data = NULL;   /* Mark this device as 'down' */
-		return(-ENODEV);
+		return -ENODEV;
 	}
 
 	bc = ch->brdchan;
-- 
1.7.1

