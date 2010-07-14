Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0GNSFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:05:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38378 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab0GNSFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F/8BcF0Ptsx7hzIim13u/Xd69HriJjICRdwx4Qa252Fs/4xUtXHycK+q/Q8aqtDrPS
         OE+CTtBc/xZ/J8h5CpyQSJ4JOilaaM82O6sgwNm2fjv3qJh1m9SVj7sy+NTkwVjXfLS/
         t3+uL1w5XAY7WYeLtsquYgmLB1mwNOjCxa4Lc=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] serial: crisv10: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:04:42 +0400
Message-Id: <1279130682-13704-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/serial/crisv10.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index ca47072..1be395a 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -4522,8 +4522,8 @@ static int __init rs_init(void)
 		INIT_WORK(&info->work, do_softint);
 
 		if (info->enabled) {
-			printk(KERN_INFO "%s%d at 0x%x is a builtin UART with DMA\n",
-			       serial_driver->name, info->line, (unsigned int)info->ioport);
+			printk(KERN_INFO "%s%d at %p is a builtin UART with DMA\n",
+			       serial_driver->name, info->line, info->ioport);
 		}
 	}
 #ifdef CONFIG_ETRAX_FAST_TIMER
-- 
1.7.0.4

