Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0KXI6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:58:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57886 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0KXI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:58:10 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/6] init: add some KERN_CONT markers to continuation lines
Date: Wed, 24 Nov 2010 09:57:48 +0100
Message-Id: <1290589070-854-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101124085645.GW4693@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 init/do_mounts.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 830aaec..5d2afd4 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -348,8 +348,8 @@ retry:
 	printk_all_partitions();
 	printk("No filesystem could mount root, tried: ");
 	for (p = fs_names; *p; p += strlen(p)+1)
-		printk(" %s", p);
-	printk("\n");
+		printk(KERN_CONT " %s", p);
+	printk(KERN_CONT "\n");
 #ifdef CONFIG_BLOCK
 	__bdevname(ROOT_DEV, b);
 #endif
-- 
1.7.2.3

