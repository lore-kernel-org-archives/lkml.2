Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541Ab0HEWeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:34:02 -0400
Received: from kroah.org ([198.145.64.141]:37757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934160Ab0HEWYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kulikov Vasiliy <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/67] serial: crisv10: formatting of pointers in printk()
Date: Thu,  5 Aug 2010 15:23:18 -0700
Message-Id: <1281047014-23429-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
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
1.7.2

