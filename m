Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab0HJWFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:05:18 -0400
Received: from kroah.org ([198.145.64.141]:45003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab0HJWAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/68] serial: crisv10: formatting of pointers in printk()
Date: Tue, 10 Aug 2010 14:59:13 -0700
Message-Id: <1281477570-18944-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kulikov Vasiliy <segooon@gmail.com>

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/crisv10.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 5696710..c856905 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -4533,8 +4533,8 @@ static int __init rs_init(void)
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
1.7.2

