Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1DEPE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:04:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab1DEO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:35 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Sailer <t.sailer@alumni.ethz.ch>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 17/34] hdlcdrv: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:04 +0200
Message-Id: <1302015561-21047-18-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: linux-hams@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/net/hamradio/hdlcdrv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 5b37579..a4a3516 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -749,7 +749,7 @@ EXPORT_SYMBOL(hdlcdrv_unregister);
 static int __init hdlcdrv_init_driver(void)
 {
 	printk(KERN_INFO "hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA\n");
-	printk(KERN_INFO "hdlcdrv: version 0.8 compiled " __TIME__ " " __DATE__ "\n");
+	printk(KERN_INFO "hdlcdrv: version 0.8\n");
 	return 0;
 }
 
-- 
1.7.4.1

